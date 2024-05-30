import 'package:flutter/material.dart';

class Parametrage extends StatefulWidget {
  const Parametrage({super.key});

  @override
  State<Parametrage> createState() => _ParametrageState();
}

class _ParametrageState extends State<Parametrage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètrage'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Retour en arrière
          },
        ),
      ), 
      body: SingleChildScrollView(
        child: Container(
          // Ajoutez votre contenu ici
        ),
      ),
    );
  }
}