import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
          alignment: Alignment.topCenter, // Aligne le cadre en haut, centré horizontalement
          child: Container(
            width: 500.0, // Ajustez la largeur du cadre selon vos besoins
            height: 90.0, // Ajustez la hauteur du cadre selon vos besoins
            decoration: BoxDecoration(
              color: Colors.orange, // Définit la couleur de fond du cadre
              // borderRadius: BorderRadius.circular(10.0), // Ajoute des coins arrondis au cadre
            ),
            child: Center(
              child: Text(
                'KADOUS TRANSFERT',
                style: TextStyle(
                  color: Colors.white, // Couleur du texte
                  fontSize: 27.0, // Taille de la police
                  fontWeight: FontWeight.bold, // Met le texte en gras
                ),
              ),
            ),
          ),
        ),
      );



  }
}