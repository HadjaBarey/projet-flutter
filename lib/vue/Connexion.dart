import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kadoustransfert/auth/auth.dart';
import 'package:kadoustransfert/homePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool auth = false;
  DateTime? madate;
  bool logi = false;
  DateTime today = DateTime.now();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    try {
      _verif().then((_) {
        if (mounted) {
          _verification();
        }
      });
    } catch (e) {
      print("Erreur initState : $e");
    }
  }

  Future<void> _verification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDate = prefs.getString('dateFinAbon');
    madate = savedDate != null ? DateTime.tryParse(savedDate) : null;

    if (savedDate != null) {
      DateTime parsed = DateTime.parse(savedDate);
      DateTime dateFinAvecHeureMax = DateTime(parsed.year, parsed.month, parsed.day, 23, 59, 59);
      print("🔎 Maintenant : ${DateTime.now()}");
      print("✅ Licence valide jusqu'à : $dateFinAvecHeureMax");

      if (DateTime.now().isBefore(dateFinAvecHeureMax)) {
        print("🟢 Licence encore valide");
      } else {
        print("🔴 Licence expirée");
      }
    } else {
      print("⚠️ Aucune date de fin trouvée dans SharedPreferences");
    }

    setState(() {
      auth = prefs.getBool("auth") ?? false;
    });

    if (madate == null || DateTime.now().isAfter(DateTime(madate!.year, madate!.month, madate!.day, 23, 59, 59))) {
      await prefs.setBool("auth", false);
    } else {
      if (auth) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }
  }

  Future<void> _verif() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String? madatasave = prefs.getString("password");
      if (madatasave != null && madatasave.isNotEmpty) {
        await verifAndprolonge(madatasave);
      }
    } catch (e) {
      print("Erreur dans _verif : $e");
    }
  }

  Future<void> verifAndprolonge(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        logi = true;
      });

      final response = await AuthKTransfert.authBypass({"password": password});
      print("📥 Réponse brute du serveur : $response");

      if (response != null && response.containsKey('dateFinAbon')) {
        print("📅 Date reçue : ${response['dateFinAbon']}");
        print("📅 Date reçue : ${response['formatabonnement']}");
        DateTime parsed = DateTime.parse(response['dateFinAbon']);
        DateTime newExpiryDate = DateTime(parsed.year, parsed.month, parsed.day, 23, 59, 59);
        int format = response['formatabonnement'] ?? 0;
        print("📅 Date après parsing : $newExpiryDate");
        print("📅 format : $format");

        if (newExpiryDate.isAfter(DateTime.now())) {
          await prefs.setBool('auth', true);
          await prefs.setString('password', password);
          await prefs.setString('dateFinAbon', newExpiryDate.toIso8601String());
          await prefs.setInt('formatabonnement', format);


          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Licence prolongée jusqu\'au $newExpiryDate')),
          );

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          await prefs.setBool('auth', false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Licence expirée.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Licence invalide ou réponse inconnue.')),
        );
      }
    } catch (e) {
      print("Erreur verifAndprolonge : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur réseau : $e')),
      );
    } finally {
      setState(() {
        logi = false;
      });
    }
  }

  Future<void> connectmyUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        logi = true;
      });

      final response = await AuthKTransfert.authBypass({"password": _passwordController.text});
      print("🔐 Réponse connexion : $response");

      if (response != null &&
          response['etat'] == 0 &&
        DateTime.parse(response['dateFinAbon']).isAfter(DateTime.now())) {
        DateTime parsed = DateTime.parse(response['dateFinAbon']);
        DateTime expiryDate = DateTime(parsed.year, parsed.month, parsed.day, 23, 59, 59);
        DateTime dateDeb = DateTime.parse(response['dateDebutAbon']);
        int format = response['formatabonnement'] ?? 0;
        
        
        
        await prefs.setBool('auth', true);
        await prefs.setString('password', _passwordController.text);
        await prefs.setString('dateFinAbon', expiryDate.toIso8601String());
        await prefs.setString('dateDebutAbon', dateDeb.toIso8601String());
        await prefs.setInt('formatabonnement', format);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connexion réussie.')),
        );

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        await prefs.setBool('auth', false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Licence invalide ou expirée.')),
        );
      }
    } catch (e) {
      print("Erreur : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion.')),
      );
    } finally {
      setState(() {
        logi = false;
      });
    }
  }

  Future<void> resetSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth');
    await prefs.remove('dateFinAbon');
    await prefs.remove('password');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Données réinitialisées.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LICENCE KADOUS TRANSFERT'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: logi
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Veuillez entrer votre licence', style: TextStyle(fontSize: 24.0)),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mot de passe',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: connectmyUser,
                      child: Text('Se connecter'),
                    ),
                    SizedBox(height: 20.0),
                    // ElevatedButton(
                    //   onPressed: resetSharedPreferences,
                    //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    //   child: Text('Réinitialiser licence'),
                    // ),
                    // SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Veuillez contacter le +226 70808881 / 77917802 pour acquérir une licence !',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
