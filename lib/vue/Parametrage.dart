import 'package:flutter/material.dart';
import 'package:kadoustransfert/Controller/EntrepriseController.dart';
import 'package:kadoustransfert/vue/Connexion.dart';
import 'package:kadoustransfert/vue/CopyData.dart';
import 'package:kadoustransfert/vue/Entreprise.dart';
import 'package:kadoustransfert/vue/ExportWhatSapp.dart';
import 'package:kadoustransfert/vue/ExporterData.dart';
import 'package:kadoustransfert/vue/ImporterData.dart';
import 'package:kadoustransfert/vue/ListAddSim.dart';
import 'package:kadoustransfert/vue/ListClient.dart';
import 'package:kadoustransfert/vue/ListOpTransaction.dart';
import 'package:kadoustransfert/vue/ListUtilisateur.dart';
import 'package:kadoustransfert/vue/SynchroniseAddSim.dart';
import 'package:kadoustransfert/vue/SynchroniseEntreprise.dart';
import 'package:kadoustransfert/vue/ViderBD.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kadoustransfert/apiSprintBoot/token_connexion.dart';
import 'package:kadoustransfert/apiSprintBoot/transfertSprintBootBD.dart';// Importer le fichier de gestion de la connexion

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
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black87,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () async {
                      saveMultipleDefaultAddSimModels();
                      saveDefaultEntrepriseModel();

                      // Afficher une confirmation à l'utilisateur
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Données Sychonisées'),
                          content: Text(
                              'Les données ont été Sychonisées avec succès.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Synchronisation',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black87,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () async {
                      EntrepriseController entrepriseController =
                          EntrepriseController();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntreprisePage(
                            entrepriseController: entrepriseController,
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Entreprise',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black87,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ListeClientPage()),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Client',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black87,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PageListAddSim(),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Add Sim',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black87,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () async {
                      // Appel de la fonction d'exportation
                     // await exportDataToLocalStorage();
                      // Appel de la fonction pour copier le fichier exporté vers un autre dossier
                      await copyFileToDownloadDirectory();
                      // Afficher une confirmation à l'utilisateur
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Exportation terminée'),
                          content: Text(
                              'Les données ont été exportées avec succès.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Export Data',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black87,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () async {
                      importDataFromJson();
                      // Afficher une confirmation à l'utilisateur
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Données importées'),
                          content:
                              Text('Les données ont été importé avec succès.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Import Data',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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

              // Container(
              //     width: 150,
              //     height: 100,
              //     decoration: BoxDecoration(
              //       color: Colors.grey[300],
              //       border: Border.all(
              //         color: Colors.black87,
              //         width: 0.0,
              //       ),
              //       borderRadius: BorderRadius.circular(15.0),
              //     ),
              //     child: InkWell(
              //       borderRadius: BorderRadius.circular(15.0),
              //       onTap: () async {
              //         getDataFromHive();
              //         // Afficher une confirmation à l'utilisateur
              //         showDialog(
              //           context: context,
              //           builder: (_) => AlertDialog(
              //             title: Text('Données exportées'),
              //             content:
              //                 Text('Les données ont été exportées avec succès.'),
              //             actions: <Widget>[
              //               TextButton(
              //                 child: Text('OK'),
              //                 onPressed: () {
              //                   Navigator.of(context).pop();
              //                 },
              //               ),
              //             ],
              //           ),
              //         );
              //       },
              //       child: Center(
              //         child: Text(
              //           'Export backEnd',
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 18.0,
              //             fontWeight: FontWeight.bold,
              //           ),
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //     ),
              //   ),

                Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black87,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () async {
                     ViderBDPage();
                      // Afficher une confirmation à l'utilisateur
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('testttttttt'),
                          content:
                              Text('test succès.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Vider ma base',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),




Container(
  width: 150,
  height: 100,
  decoration: BoxDecoration(
    color: Colors.grey[300],
    border: Border.all(
      color: Colors.black87,
      width: 0.0,
    ),
    borderRadius: BorderRadius.circular(15.0),
  ),
  child: InkWell(
    borderRadius: BorderRadius.circular(15.0),
    onTap: () async {
      try {
        // Vérifier si l'utilisateur est connecté
        String? token = await getToken(); // Récupérer le token
        print("🔍 Vérification du token : $token"); // Debug du token

        // Si le token est null, tenter une connexion automatique
        if (token == null) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Connexion en cours...")
                ],
              ),
            ),
          );

          // Connexion automatique
          bool isConnected = await connexionManuelle('ouedraogomariam@gmail.com', '000');
          Navigator.of(context).pop();

          if (!isConnected) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Erreur de connexion'),
                content: Text('Impossible de se connecter. Veuillez réessayer.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
            return;
          }

          token = await getToken();
          print("🔍 Vérification du token après connexion : $token");
          if (token == null) {
            throw Exception('Token non trouvé après connexion.');
          }
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Exportation en cours...")
              ],
            ),
          ),
        );

        // Récupérer les données
        final operations = await getDataFromHive();

        // Envoyer les données au serveur
        await transfertDataToSpringBoot(operations);

        Navigator.of(context).pop();

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Données exportées'),
            content: Text('Les données ont été exportées avec succès.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } catch (e) {
        Navigator.of(context).pop();

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Erreur'),
            content: Text('Erreur lors de l\'exportation des données: $e'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    },
    child: Center(
      child: Text(
        'Export backEnd',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  ),
),

                // Container(
                //     width: 150,
                //     height: 100,
                //     decoration: BoxDecoration(
                //       color: Colors.grey[300],
                //       border: Border.all(
                //         color: Colors.black87,
                //         width: 0.0,
                //       ),
                //       borderRadius: BorderRadius.circular(15.0),
                //     ),
                //     child: InkWell(
                //       borderRadius: BorderRadius.circular(15.0),
                //       onTap: () async {
                //         try {
                //           // Afficher un indicateur de chargement
                //           showDialog(
                //             context: context,
                //             barrierDismissible: false,
                //             builder: (_) => AlertDialog(
                //               content: Row(
                //                 children: [
                //                   CircularProgressIndicator(),
                //                   SizedBox(width: 20),
                //                   Text("Exportation en cours...")
                //                 ],
                //               ),
                //             ),
                //           );

                //           // Récupérer les données
                //           final operations = await getDataFromHive();
                          
                //           // Envoyer les données au serveur
                //           await transfertDataToSpringBoot(operations);
                          
                //           // Fermer le dialogue de chargement
                //           Navigator.of(context).pop();
                          
                //           // Afficher une confirmation à l'utilisateur
                //           showDialog(
                //             context: context,
                //             builder: (_) => AlertDialog(
                //               title: Text('Données exportées'),
                //               content: Text('Les données ont été exportées avec succès.'),
                //               actions: <Widget>[
                //                 TextButton(
                //                   child: Text('OK'),
                //                   onPressed: () {
                //                     Navigator.of(context).pop();
                //                   },
                //                 ),
                //               ],
                //             ),
                //           );
                //         } catch (e) {
                //           // Fermer le dialogue de chargement en cas d'erreur
                //           Navigator.of(context).pop();
                          
                //           // Afficher l'erreur
                //           showDialog(
                //             context: context,
                //             builder: (_) => AlertDialog(
                //               title: Text('Erreur'),
                //               content: Text('Erreur lors de l\'exportation des données: $e'),
                //               actions: <Widget>[
                //                 TextButton(
                //                   child: Text('OK'),
                //                   onPressed: () {
                //                     Navigator.of(context).pop();
                //                   },
                //                 ),
                //               ],
                //             ),
                //           );
                //         }
                //       },
                //       child: Center(
                //         child: Text(
                //           'Export backEnd',
                //           style: TextStyle(
                //             color: Colors.black,
                //             fontSize: 18.0,
                //             fontWeight: FontWeight.bold,
                //           ),
                //           textAlign: TextAlign.center,
                //         ),
                //       ),
                //     ),
                //   ),


                // Container(
                //   width: 150,
                //   height: 100,
                //   decoration: BoxDecoration(
                //     color: Colors.grey[300],
                //     border: Border.all(
                //       color: Colors.black87,
                //       width: 0.0,
                //     ),
                //     borderRadius: BorderRadius.circular(15.0),
                //   ),
                //   child: InkWell(
                //     borderRadius: BorderRadius.circular(15.0),
                //     onTap: () async {
                //       SharedPreferences prefs =
                //           await SharedPreferences.getInstance();
                //       prefs.clear().then((v) {
                //         Navigator.pushReplacement(
                //           context,
                //           MaterialPageRoute(builder: (context) => LoginPage()),
                //         );
                //       });
                //     },
                //     child: Center(
                //       child: Text(
                //         'Deconnexion',
                //         style: TextStyle(
                //           color: Colors.black,
                //           fontSize: 18.0,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   ),
                // ),

               // Remplacez votre widget d'exportation de données dans la liste de widgets ci-dessous.

                // Container(
                //   width: 150,
                //   height: 100,
                //   decoration: BoxDecoration(
                //     color: Colors.grey[300],
                //     border: Border.all(
                //       color: Colors.black87,
                //       width: 0.0,
                //     ),
                //     borderRadius: BorderRadius.circular(15.0),
                //   ),
                //   child: InkWell(
                //     borderRadius: BorderRadius.circular(15.0),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const PageListOpTransaction(),
                //         ),
                //       );
                //     },
                //     child: Center(
                //       child: Text(
                //         'Opération Transaction',
                //         style: TextStyle(
                //           color: Colors.black,
                //           fontSize: 18.0,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   ),
                // ),



               ],
             ),


            // SizedBox(height: 60),

            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //      Container(
            //         width: 150,
            //         height: 100,
            //         decoration: BoxDecoration(
            //           color: Colors.grey[300],
            //           border: Border.all(
            //             color: Colors.black87,
            //             width: 0.0,
            //           ),
            //           borderRadius: BorderRadius.circular(15.0),
            //         ),
            //         child: InkWell(
            //           borderRadius: BorderRadius.circular(15.0),
            //           onTap: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(builder: (context) => const PageListeUtilisateur()),
            //             );
            //           },
            //           child: Center(
            //             child: Text(
            //               'Utilisateur',
            //               style: TextStyle(
            //                 color: Colors.black,
            //                 fontSize: 18.0,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),

            //   //     // Remplacez votre widget d'exportation de données dans la liste de widgets ci-dessous.

            //       Container(
            //         width: 150,
            //         height: 100,
            //         decoration: BoxDecoration(
            //           color: Colors.grey[300],
            //           border: Border.all(
            //             color: Colors.black87,
            //             width: 0.0,
            //           ),
            //           borderRadius: BorderRadius.circular(15.0),
            //         ),
            //         child: InkWell(
            //           borderRadius: BorderRadius.circular(15.0),
            //           onTap: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => const PageListOpTransaction(),
            //               ),
            //             );
            //           },
            //           child: Center(
            //             child: Text(
            //               'Opération Transaction',
            //               style: TextStyle(
            //                 color: Colors.black,
            //                 fontSize: 18.0,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //               textAlign: TextAlign.center,
            //             ),
            //           ),
            //         ),
            //       ),

            //     ],
            //   ),
          ],
        ),
      ),
    );
  }
}
