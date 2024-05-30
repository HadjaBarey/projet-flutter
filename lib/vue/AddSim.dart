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
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Retour en arrière
          },
        ),
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 80.0, // Hauteur du cadre contenant le texte
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            child: Center(
              child: Text(
                'KADOUS TRANSFERT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
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