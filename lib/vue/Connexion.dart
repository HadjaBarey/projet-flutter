import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kadoustransfert/auth/auth.dart';
import 'dart:convert';  // Pour convertir la réponse JSON
import 'package:kadoustransfert/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool auth =false;
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  _maconnexion() async{
    try{
      await AuthKTransfert.authBypass({
        "password":_passwordController.text
      }).then((value){
        print("le resultat ${value}");
      });
    }catch(e){
      print("erreur sue les post du data $e");
    }
  }
  // Fonction pour envoyer la requête de connexion
  Future<void> _login() async {
    final enteredPassword = _passwordController.text;

    // URL de ton serveur Hostinger où le mot de passe est vérifié
    final url = Uri.parse('https://hpanel.hostinger.com/websites/kadoussconnect.com/databases/my-sql-databases');  // Remplace par ton URL réelle

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'password': enteredPassword,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success']) {
          // Si le mot de passe est correct, naviguer vers la HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          // Afficher un message d'erreur si le mot de passe est incorrect
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mot de passe incorrect')),
          );
        }
      } else {
        // Afficher une erreur si le serveur n'a pas répondu correctement
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de serveur : ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Gérer les erreurs de connexion réseau
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion : $e')),
      );
    }
  }
_verification()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try{
  setState(() {
    auth = prefs.getBool("auth")!;
  });
  if(auth==true) {
    Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
  }
  }catch(e){
    print("nothing $e");
  }
}
  connectmyUser()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      await AuthKTransfert.authBypass({
        "password":_passwordController.text
      }).then((value){
         print(value);
        if(value['response']=="true"){
          prefs.setBool('auth', true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ENREGISTREMENT EFFECTUE'))
             );
             Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('MOT DE PASSE ERRONE')),
      );
        }
      });
     
    }catch(e){
      print("une erreru sur la vue $e");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LICENCE KADOUS TRANSFERT'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
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
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mot de passe',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: (){
                connectmyUser();
              },
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
