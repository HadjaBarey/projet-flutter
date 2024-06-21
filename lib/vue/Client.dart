import 'package:flutter/material.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajouter Client Prestige',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.orange, // Couleur de l'AppBar (optionnel)
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            // Ajoutez votre contenu ici
          ],
        ),
      ),
    );
  }
}
