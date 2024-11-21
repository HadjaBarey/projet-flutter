import 'package:flutter/material.dart';
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
    _verif();
    _verification(); 
    
    // Vérifie la licence au démarrage
  }

  // Vérification initiale de la licence
  Future<void> _verification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    

    try {
      // Récupération des données locales

      String savedDate = prefs.getString('date_fin')!;
      madate = DateTime.tryParse(savedDate);

      setState(() {
        auth = prefs.getBool("auth") ?? false; // Défaut: false si non défini
      });

      // Si la licence a expiré
      if (madate!.isBefore(today)) {
        print("Licence expirée ou inexistante. Tentative de mise à jour...");
        
      } else {
        // Licence encore valide
        if (auth) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
    } catch (e) {
      print("Erreur dans la vérification de la licence : $e");
    }
  }

  // Revalidation de la licence auprès du serveur
  _verif()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      String madatasave= prefs.getString("password")!;
     verifAndprolonge(madatasave);
    }catch (e) {
      print("pas de save $e");
    }
  }  

  Future<void> verifAndprolonge(password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      setState(() {
        logi = true; // Affiche un chargement
      });

      var response = await AuthKTransfert.authBypass({
        "password": password,
      });

      print("Réponse du serveur : $response");
      DateTime today1 = DateTime.now();
      // Si la licence est valide
      print(response['date_fin']);
      DateTime newExpiryDate = DateTime.parse(response['date_fin']);
      if (newExpiryDate.isAfter(today1)) {
        prefs.setBool('auth', true);
         prefs.setString('password', password);
        prefs.setString('date_fin', newExpiryDate.toString());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connexion réussie.')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      print("Erreur dans la connexion : $e");
    } finally {
      setState(() {
        logi = false; // Masque le chargement
      });
    }
  }

  // Connexion manuelle avec validation du mot de passe
  Future<void> connectmyUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      setState(() {
        logi = true; // Affiche un chargement
      });

      var response = await AuthKTransfert.authBypass({
        "password": _passwordController.text,
      });

      print("Réponse du serveur : $response");

      // Si la licence est valide
      if (response['response'] == "true") {
        DateTime newExpiryDate = DateTime.parse(response['date_fin']);
        prefs.setBool('auth', true);
        prefs.setString('password', _passwordController.text);
        prefs.setString('date_fin', newExpiryDate.toString());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connexion réussie.')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        verifAndprolonge(_passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mot de-passe incorrect ou licence expirée.')),
        );
      }
    } catch (e) {
      print("Erreur dans la connexion : $e");
    } finally {
      setState(() {
        logi = false; // Masque le chargement
      });
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
