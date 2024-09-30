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
  bool logi =false;
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
     setState(() {
        logi=true;
      });
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
    }finally{
       setState(() {
        logi=false;
      });
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
      body: logi==true?
      Center(
        child: CircularProgressIndicator(),
      )
       :SingleChildScrollView(
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
              SizedBox(height: 20.0),
              Container(
                  padding: EdgeInsets.all(16.0), // Ajoute un peu d'espace autour du texte
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Change la couleur de fond si nécessaire
                    borderRadius: BorderRadius.circular(10.0), // Ajoute des bords arrondis
                  ),
                  child: Text(
                    'Veuillez contacter le +226 70808881/77917802 pour acquerir une licence! ', // Remplace par le texte que tu veux afficher
                    style: TextStyle(
                      fontSize: 16.0, // Taille du texte
                      color: Colors.black, // Couleur du texte
                      fontWeight: FontWeight.bold, // Style du texte en gras (optionnel)
                    ),
                    textAlign: TextAlign.center, // Centre le texte à l'intérieur du container
                  ),
                )


            ],
          ),
        ),
      ),
    );
  }
}
