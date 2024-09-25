import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kadoustransfert/homePage.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final String correctPassword = '000';  // Définir le mot de passe ici ou le récupérer d'une base de données Hive

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final enteredPassword = _passwordController.text;

    if (enteredPassword == correctPassword) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Veuillez entrer votre mot de passe',
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
              onPressed: _login,
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
