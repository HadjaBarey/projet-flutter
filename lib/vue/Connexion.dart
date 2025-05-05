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
    } catch(e) {
     print("pas de boot");
    }
  }



Future<void> _verification() async {
    if (!mounted) return;  // Vérification ajoutée pour éviter des problèmes si widget est démonté
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
 
    try {
      String? savedDate = prefs.getString('dateFinAbon');
      madate = savedDate != null ? DateTime.tryParse(savedDate) : null;
      if (mounted) {
        setState(() {
          auth = prefs.getBool("auth") ?? false;
        });
      }

      if (madate == null || madate!.isBefore(DateTime.now())) {
      //  print("Licence expirée ou inexistante.");
 await prefs.setBool("auth", false); // 👈 Désactivation forcée ici
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Votre licence a expiré ou est inexistante. Veuillez la renouveler.'),
            ),
          );
        }
      } else {
        if (auth && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
    } catch (e, stacktrace) {
      print("Erreur dans la vérification de la licence : $e");
      print("Trace : $stacktrace");
    }
  }



  Future<void> _verif() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Récupération de la valeur sauvegardée
      String? madatasave = prefs.getString("password");

      if (madatasave != null && madatasave.isNotEmpty && mounted) {
        // Appel de la méthode si la valeur est valide
        verifAndprolonge(madatasave);
      } else {
        print("Aucune donnée sauvegardée pour 'password'.");
      }
    } catch (e, stacktrace) {
      // Gestion des erreurs et log des détails
      print("Erreur lors de la récupération des données : $e");
      print("Trace : $stacktrace");
    }
  }

  Future<void> verifAndprolonge(String password) async {
    if (!mounted) return;  // Vérification ajoutée pour éviter des problèmes si widget est démonté
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (mounted) {
        setState(() {
          logi = true; // Affiche un chargement
        });
      }

      // Appeler l'authentification avec le mot de passe
      final response = await AuthKTransfert.authBypass({"password": password});

      if (!mounted) return;  // Vérification après l'opération asynchrone

      if (response.containsKey('dateFinAbon')) {
        DateTime today = DateTime.now();
        DateTime newExpiryDate = DateTime.parse(response['dateFinAbon']);

        if (newExpiryDate.isAfter(today)) {
          // La licence est valide
          prefs.setBool('auth', true);
          prefs.setString('password', password);
          prefs.setString('dateFinAbon', newExpiryDate.toIso8601String());
          print("Licence valide jusqu'à $newExpiryDate");

          if (mounted) {  // Vérification avant d'utiliser context
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Licence prolongée jusqu\'au $newExpiryDate.')),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        } else {
          // Licence expirée
          prefs.setBool('auth', false);
          print("La licence a expiré. Veuillez renouveler.");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Licence expirée. Veuillez la renouveler.')),
            );
          }
        }
      } else if (response.containsKey('error')) {
        // Erreur côté serveur ou mot de passe invalide
        print("Erreur du serveur : ${response['error']}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur du serveur : ${response['error']}')),
          );
        }
      } else {
        // Réponse inattendue
       // print("Mot de passe invalide ou réponse inconnue du serveur.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mot de passe invalide ou licence expirée.')),
          );
        }
      }
    } catch (e) {
      // Gestion des erreurs réseau ou autres
      print("Erreur de connexion : $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion : $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          logi = false; // Masque le chargement
        });
      }
    }
  }

//   // Connexion avec validation du mot de passe
Future<void> connectmyUser() async {
  if (!mounted) return;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    setState(() {
      logi = true;
    });

    final response = await AuthKTransfert.authBypass({"password": _passwordController.text});

    if (response != null &&
      response['etat'] == 0 &&
      DateTime.parse(response['dateFinAbon']).isAfter(DateTime.now()))  {

      DateTime expiryDate = DateTime.parse(response['dateFinAbon']);
      DateTime dateDeb = DateTime.parse(response['dateDebutAbon']);
      DateTime today = DateTime.now();
    
  
      // print("📅 Date du téléphone : $today");
      // print("📅 Date de début d'abonnement : $dateDeb");
      // print("📅 Date de début fin d'abonnement : $expiryDate");


      // 🔒 Vérification que la date du téléphone >= dateDeb
      // if (today.isBefore(dateDeb)) {
      //   // ❌ Date du téléphone trop ancienne
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Veuillez corriger la date du téléphone.')),
      //   );
      //   return;
      // }

      if (!expiryDate.isBefore(today)) {
        // ✅ licence valide, état 0, non expirée
        await prefs.setBool('auth', true);
        await prefs.setString('password', _passwordController.text);
        await prefs.setString('dateFinAbon', expiryDate.toIso8601String());        
        await prefs.setString('dateDebutAbon', dateDeb.toIso8601String());
      

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connexion réussie.')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // ❌ licence expirée
        await prefs.setBool('auth', false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Licence expirée.')),
        );
      }
    } else {
      // ❌ état != 0 ou réponse fausse
      await prefs.setBool('auth', false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Licence invalide ou déjà utilisée.')),
      );
    }
  } catch (e) {
    print("Erreur : $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur de connexion.')),
    );
  } finally {
    if (mounted) {
      setState(() {
        logi = false;
      });
    }
  }
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Veuillez entrer votre licence',
                      style: TextStyle(fontSize: 24.0),
                    ),
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
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Veuillez contacter le +226 70808881/77917802 pour acquérir une licence !',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
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

