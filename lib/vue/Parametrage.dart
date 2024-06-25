import 'package:flutter/material.dart';
import 'package:kadoustransfert/vue/Client.dart';
import 'package:kadoustransfert/vue/ListClient.dart';

class Parametrage extends StatefulWidget {
  const Parametrage({Key? key}) : super(key: key);

  @override
  State<Parametrage> createState() => _ParametrageState();
}

class _ParametrageState extends State<Parametrage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: Text(
                  '',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Couleur de fond gris
                      border: Border.all(
                        color: Colors.black87, // Couleur de la bordure en noir foncé
                        width: 0.0, // Épaisseur de la bordure en pixels
                      ),
                      borderRadius: BorderRadius.circular(15.0), // Bordure circulaire avec un rayon de 15 pixels
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.0), // Assure que l'effet d'encre respecte les coins arrondis
                      onTap: () {                       
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const ClientPage()),
                        // );               
                      },
                      child: Center(
                        child: Text(
                          'Utilsateur', // Le texte que vous souhaitez afficher
                          style: TextStyle(
                            color: Colors.black, // Couleur du texte
                            fontSize: 18.0, // Taille de la police
                            fontWeight: FontWeight.bold, // Mettre le texte en gras
                          ),
                        ),
                      ),
                    ),
                  ),

                Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Couleur de fond gris
                      border: Border.all(
                        color: Colors.black87, // Couleur de la bordure en noir foncé
                        width: 0.0, // Épaisseur de la bordure en pixels
                      ),
                      borderRadius: BorderRadius.circular(15.0), // Bordure circulaire avec un rayon de 15 pixels
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.0), // Assure que l'effet d'encre respecte les coins arrondis
                      onTap: () {
                        {                       
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ListeClientPage()),
                        );               
                      }
                      },
                      child: Center(
                        child: Text(
                          'Client', // Le texte que vous souhaitez afficher
                          style: TextStyle(
                            color: Colors.black, // Couleur du texte
                            fontSize: 18.0, // Taille de la police
                            fontWeight: FontWeight.bold, // Mettre le texte en gras
                          ),
                        ),
                      ),
                    ),
                  ),                
              ],
            ),
             SizedBox(height: 60),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  Container(
                          width: 150,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // Couleur de fond gris
                            border: Border.all(
                              color: Colors.black87, // Couleur de la bordure en noir foncé
                              width: 0.0, // Épaisseur de la bordure en pixels
                            ),
                            borderRadius: BorderRadius.circular(15.0), // Bordure circulaire avec un rayon de 15 pixels
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15.0), // Assure que l'effet d'encre respecte les coins arrondis
                            onTap: () {
                              // Action à réaliser lors du clic
                              print('Container cliqué');
                            },
                            child: Center(
                              child: Text(
                                'Opération Transaction', // Le texte que vous souhaitez afficher
                                style: TextStyle(
                                  color: Colors.black, // Couleur du texte
                                  fontSize: 18.0, // Taille de la police
                                  fontWeight: FontWeight.bold, // Mettre le texte en gras
                                ),
                                textAlign: TextAlign.center, // Centre le texte horizontalement
                              ),
                            ),
                          ),
                        ),


                Container(
                          width: 150,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // Couleur de fond gris
                            border: Border.all(
                              color: Colors.black87, // Couleur de la bordure en noir foncé
                              width: 0.0, // Épaisseur de la bordure en pixels
                            ),
                            borderRadius: BorderRadius.circular(15.0), // Bordure circulaire avec un rayon de 15 pixels
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15.0), // Assure que l'effet d'encre respecte les coins arrondis
                            onTap: () {
                              // Action à réaliser lors du clic
                              print('Container cliqué');
                            },
                            child: Center(
                              child: Text(
                                'Entreprise', // Le texte que vous souhaitez afficher
                                style: TextStyle(
                                  color: Colors.black, // Couleur du texte
                                  fontSize: 18.0, // Taille de la police
                                  fontWeight: FontWeight.bold, // Mettre le texte en gras
                                ),
                                textAlign: TextAlign.center, // Centre le texte horizontalement
                              ),
                            ),
                          ),
                        ),   
              ],
            ),
          ],
        ),
      ),
    );
  }
}
