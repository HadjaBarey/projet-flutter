import 'package:flutter/material.dart';

class Historique extends StatefulWidget {
  const Historique({super.key});

  @override
  State<Historique> createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {
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
                  'Historique',
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