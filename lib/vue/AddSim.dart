import 'package:flutter/material.dart';

class AddSim extends StatefulWidget {
  const AddSim({super.key});

  @override
  State<AddSim> createState() => _AddSimState();
}

class _AddSimState extends State<AddSim> {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Sim'),
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