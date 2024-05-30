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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.0), // Espacement pour descendre le contenu
            Padding(
              padding: EdgeInsets.only(bottom: 20.0), // Espacement en bas
              child: Center( // Centre le texte horizontalement
                child: Text(
                  'Add Sim',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    // fontFamily: 'Nunito', // Changer la police ici (remplacer 'Nunito' par le nom de la police souhaitée)
                  ),
                ),
              ),
            ),
            // Ajoutez votre contenu ici
          ],
        ),
      ),
    );
  }
}