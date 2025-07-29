import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Controller/EntrepriseController.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
//import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:kadoustransfert/Model/UsersKeyModel.dart';
//import 'package:kadoustransfert/Model/UtilisateurModel.dart';
//import 'package:kadoustransfert/apiSprintBoot/connexionToken.dart';
import 'package:kadoustransfert/apiSprintBoot/exportFlutterHostinger.dart';
// import 'package:kadoustransfert/apiSprintBoot/importBDToFlutter.dart';
import 'package:kadoustransfert/apiSprintBoot/importHostingerFlutter.dart';
import 'package:kadoustransfert/vue/CopyData.dart';
import 'package:kadoustransfert/vue/Entreprise.dart';
import 'package:kadoustransfert/vue/ImporterData.dart';
import 'package:kadoustransfert/vue/ListAddSim.dart';
import 'package:kadoustransfert/vue/ListClient.dart';
import 'package:kadoustransfert/vue/SynchroniseAddSim.dart';
import 'package:kadoustransfert/vue/SynchroniseEntreprise.dart';
import 'package:kadoustransfert/vue/ViderBD.dart';
// import 'package:kadoustransfert/apiSprintBoot/exportBDToSprint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Parametrage extends StatefulWidget {
  const Parametrage({Key? key}) : super(key: key);

  @override
  State<Parametrage> createState() => _ParametrageState();
}

class _ParametrageState extends State<Parametrage> {
  bool isLoading = false; // ✅ Déclaration ici au bon endroit
  bool isImporting = false;
  bool isExportingBackEnd = false;
  bool isImportingBackEnd = false;

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
                      bool? confirmation = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                                'Êtes-vous sûr de vouloir synchroniser les données ?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Annuler'),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                              TextButton(
                                child: Text('Confirmer'),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmation == true) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? dateDebStr = prefs.getString('dateDebutAbon');

                        if (dateDebStr != null) {
                          DateTime dateDeb =
                              DateTime.parse(dateDebStr); // Conversion

                          saveMultipleDefaultAddSimModels();
                          //saveDefaultEntrepriseModel(dateDeb); // Appel avec DateTime a activer a la fin
                          saveDefaultEntrepriseModel();
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Données Synchronisées'),
                              content: Text(
                                  'Les données ont été synchronisées avec succès.'),
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
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Date de début d\'abonnement introuvable.')),
                          );
                        }
                      }
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
                        'Opérateur mobile',
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
                      bool confirm = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                                'Voulez-vous vraiment exporter les données du téléphone vers le fichier?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false), // Annuler
                                child: Text('Non'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pop(true), // Confirmer
                                child: Text('Oui'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        // Démarrez l'indicateur de chargement
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          // Appel de la fonction pour exporter les données
                          await exportDataToJson();

                          // Affichage du message de succès
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Exportation terminée'),
                              content: Text(
                                  'Les données ont été exportées vers le fichier avec succès.'),
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
                        } finally {
                          // Arrêtez l'indicateur de chargement une fois terminé
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator() // Indicateur de chargement circulaire
                          : Text(
                              'Enregistrer Téléphone',
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
                      bool confirm = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                                'Voulez-vous vraiment importer les données du fichier vers le téléphone?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('Non'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text('Oui'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        setState(() {
                          isImporting = true;
                        });

                        try {
                          await importDataFromJson();

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Importation terminée'),
                              content: Text(
                                  'Les données ont été importées vers le téléphone avec succès.'),
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
                        } finally {
                          setState(() {
                            isImporting = false;
                          });
                        }
                      }
                    },
                    child: Center(
                      child: isImporting
                          ? CircularProgressIndicator()
                          : Text(
                              'Récupérer Téléphone',
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
                // Premier bouton : Export backEnd

Container(
  width: 150,
  height: 100,
  decoration: BoxDecoration(
    color: Colors.grey[300],
    border: Border.all(color: Colors.black87, width: 0.0),
    borderRadius: BorderRadius.circular(15.0),
  ),
  child: InkWell(
    borderRadius: BorderRadius.circular(15.0),
    onTap: () async {
      if (isExportingBackEnd) return;

      final entreprise = await getEntrepriseFromHiveHos();
      if (entreprise == null || entreprise.DateControle.isEmpty) {
        showAlertDialog(context, "❗ Date de contrôle introuvable.");
        return;
      }

      bool confirm = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Confirmation'),
              content: Text(
                  'Voulez-vous vraiment exporter les données pour la date : ${entreprise.DateControle} ?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Non'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Oui'),
                ),
              ],
            ),
          ) ??
          false;

      if (!confirm) return;

      setState(() {
        isExportingBackEnd = true;
      });

      try {
        // ✅ Appel des deux fonctions en parallèle
        await Future.wait([
          exportVersBackend(context: context, isCaisse: true),
          exportVersBackend(context: context, isCaisse: false),
        ]);
      } catch (e) {
        showAlertDialog(context, "💥 Une erreur est survenue : $e");
      } finally {
        setState(() {
          isExportingBackEnd = false;
        });
      }
    },
    child: Center(
      child: isExportingBackEnd
          ? CircularProgressIndicator()
          : Text(
              'Enregistrer Internet',
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


///////////////////////////////// OPTION EXPORT DE FLUTTER VERS SPRING BOOT

                // Container(
                //   width: 150,
                //   height: 100,
                //   decoration: BoxDecoration(
                //     color: Colors.grey[300],
                //     border: Border.all(color: Colors.black87, width: 0.0),
                //     borderRadius: BorderRadius.circular(15.0),
                //   ),
                //   child: InkWell(
                //     borderRadius: BorderRadius.circular(15.0),
                //     onTap: () async {
                //       if (isExportingBackEnd) return; // Évite les doubles clics

                //       setState(() {
                //         isExportingBackEnd = true;
                //       });

                //       try {
                //         // Vérifier la connexion internet
                //         bool isConnected = await isConnectedToInternet();
                //         if (!isConnected) {
                //           showDialog(
                //             context: context,
                //             builder: (_) => AlertDialog(
                //               title: Text('Erreur de connexion'),
                //               content: Text(
                //                   'Vous devez être connecté à Internet pour exporter les données.'),
                //               actions: [
                //                 TextButton(
                //                     child: Text('OK'),
                //                     onPressed: () =>
                //                         Navigator.of(context).pop())
                //               ],
                //             ),
                //           );
                //           return;
                //         }

                //         // Vérifier connexion utilisateur à Spring Boot
                //         String? token = await getToken(context);
                //         if (token == null) {
                //           bool isManuallyConnected = await connexionManuelle(
                //             context,
                //             'ouedraogomariam@gmail.com',
                //             '000',
                //           );
                //           if (!isManuallyConnected) {
                //             showDialog(
                //               context: context,
                //               builder: (_) => AlertDialog(
                //                 title: Text('Erreur de connexion'),
                //                 content: Text(
                //                     'Vous devez être connecté à Spring Boot pour exporter les données.'),
                //                 actions: [
                //                   TextButton(
                //                       child: Text('OK'),
                //                       onPressed: () =>
                //                           Navigator.of(context).pop())
                //                 ],
                //               ),
                //             );
                //             return;
                //           }
                //         }

                //         // Récupérer l'entreprise
                //         EntrepriseModel? entreprise =
                //             await getEntrepriseFromHive();
                //         if (entreprise == null ||
                //             entreprise.numeroTelEntreprise.isEmpty ||
                //             entreprise.DateControle.isEmpty) {
                //           showDialog(
                //             context: context,
                //             builder: (_) => AlertDialog(
                //               title: Text('Information manquante'),
                //               content: Text(
                //                   'Le numéro de téléphone ou la date de contrôle de l\'entreprise est manquant.'),
                //               actions: [
                //                 TextButton(
                //                     child: Text('OK'),
                //                     onPressed: () =>
                //                         Navigator.of(context).pop())
                //               ],
                //             ),
                //           );
                //           return;
                //         }

                //         // Demander confirmation
                //         bool confirm = await showDialog(
                //           context: context,
                //           builder: (BuildContext context) {
                //             return AlertDialog(
                //               title: Text('Confirmation'),
                //               content: Text(
                //                   'Voulez-vous vraiment exporter les données du téléphone vers internet pour la date : ${entreprise.DateControle} ?'),
                //               actions: [
                //                 TextButton(
                //                     onPressed: () =>
                //                         Navigator.of(context).pop(false),
                //                     child: Text('Non')),
                //                 TextButton(
                //                     onPressed: () =>
                //                         Navigator.of(context).pop(true),
                //                     child: Text('Oui')),
                //               ],
                //             );
                //           },
                //         );

                //         if (confirm != true) return;

                //         final operations = await getDataFromHive();
                //         await transfertDataToSpringBoot(
                //             operations, entreprise.DateControle, context);

                //         showDialog(
                //           context: context,
                //           builder: (_) => AlertDialog(
                //             title: Text('Données exportées'),
                //             content: Text(
                //                 'Les données ont été exportées du téléphone vers internet avec succès pour la date : ${entreprise.DateControle}'),
                //             actions: [
                //               TextButton(
                //                   child: Text('OK'),
                //                   onPressed: () => Navigator.of(context).pop())
                //             ],
                //           ),
                //         );
                //       } catch (e) {
                //         showDialog(
                //           context: context,
                //           builder: (_) => AlertDialog(
                //             title: Text('Erreur'),
                //             content: Text(
                //                 'Erreur lors de l\'exportation des données vers internet: $e'),
                //             actions: [
                //               TextButton(
                //                   child: Text('OK'),
                //                   onPressed: () => Navigator.of(context).pop())
                //             ],
                //           ),
                //         );
                //       } finally {
                //         setState(() {
                //           isExportingBackEnd = false;
                //         });
                //       }
                //     },
                //     child: Center(
                //       child: isExportingBackEnd
                //           ? CircularProgressIndicator()
                //           : Text(
                //               'Export backEnd',
                //               style: TextStyle(
                //                 color: Colors.black,
                //                 fontSize: 18.0,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //               textAlign: TextAlign.center,
                //             ),
                //     ),
                //   ),
                // ),
///////////////////////////////// FIN OPTION EXPORT DE FLUTTER VERS SPRING BOOT

                // Deuxième bouton : Import backEnd

                Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.black87, width: 0.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () async {
                      if (isImportingBackEnd) return;

                      showDatePickerDialog(context, (selectedDate) async {
                        setState(() {
                          isImportingBackEnd = true;
                        });

                        try {
                          bool confirm = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmation'),
                                content: Text(
                                  'Voulez-vous vraiment importer les données du serveur pour la date : $selectedDate ?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text('Non'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text('Oui'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (!confirm) return;
                          if (selectedDate.isEmpty ||
                              selectedDate == "00000000") {
                            print("🚨 Date invalide : $selectedDate");
                            return;
                          }

                          // Ouverture des boîtes Hive sans bloquer si elles sont vides
                          final boxEnt =
                              await Hive.openBox<EntrepriseModel>('todobos2');
                          final boxUser =
                              await Hive.openBox<UsersKeyModel>('todobos7');

                          final entreprise =
                              boxEnt.isNotEmpty ? boxEnt.values.first : null;
                          final user =
                              boxUser.isNotEmpty ? boxUser.values.first : null;

                          final numeroEntreprise =
                              entreprise?.numeroTelEntreprise ?? "";
                          final emailEntreprise =
                              entreprise?.emailEntreprise ?? "";
                          final numeroAleatoire = user?.numeroaleatoire ?? "";

                          await fetchAndSaveFromBackend(
                            context: context,
                            numeroEntreprise: numeroEntreprise,
                            dateOperation: selectedDate,
                            emailEntreprise: emailEntreprise,
                            numeroAleatoire: numeroAleatoire,
                          );

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Données importées'),
                              content: Text(
                                'Les données ont été importées avec succès pour la date : $selectedDate',
                              ),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Erreur'),
                              content:
                                  Text('❌ Erreur lors de l\'importation : $e'),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        } finally {
                          setState(() {
                            isImportingBackEnd = false;
                          });
                        }
                      });
                    },
                    child: Center(
                      child: isImportingBackEnd
                          ? CircularProgressIndicator()
                          : Text(
                              'Récupérer Internet',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                )

                // Container(
                //   width: 150,
                //   height: 100,
                //   decoration: BoxDecoration(
                //     color: Colors.grey[300],
                //     border: Border.all(color: Colors.black87, width: 0.0),
                //     borderRadius: BorderRadius.circular(15.0),
                //   ),
                //   child: InkWell(
                //     borderRadius: BorderRadius.circular(15.0),
                //     onTap: () async {
                //       if (isImportingBackEnd) return;

                //       showDatePickerDialog(context, (selectedDate) async {
                //         setState(() {
                //           isImportingBackEnd = true;
                //         });

                //         try {
                //           String? token = await getToken(context);
                //           if (token == null) {
                //             bool isConnected = await connexionManuelle(
                //                 context, 'ouedraogomariam@gmail.com', '000');
                //             if (!isConnected) {
                //               showDialog(
                //                 context: context,
                //                 builder: (_) => AlertDialog(
                //                   title: Text('Erreur de connexion'),
                //                   content: Text(
                //                       'Vous devez être connecté à internet pour importer les données vers le téléphone.'),
                //                   actions: [
                //                     TextButton(
                //                       child: Text('OK'),
                //                       onPressed: () =>
                //                           Navigator.of(context).pop(),
                //                     ),
                //                   ],
                //                 ),
                //               );
                //               return;
                //             }
                //           }

                //           bool confirm = await showDialog(
                //             context: context,
                //             builder: (BuildContext context) {
                //               return AlertDialog(
                //                 title: Text('Confirmation'),
                //                 content: Text(
                //                     'Voulez-vous vraiment importer les données de internet vers le téléphone pour la date : $selectedDate ?'),
                //                 actions: [
                //                   TextButton(
                //                     onPressed: () =>
                //                         Navigator.of(context).pop(false),
                //                     child: Text('Non'),
                //                   ),
                //                   TextButton(
                //                     onPressed: () =>
                //                         Navigator.of(context).pop(true),
                //                     child: Text('Oui'),
                //                   ),
                //                 ],
                //               );
                //             },
                //           );

                //           if (!confirm) return;

                //           if (selectedDate.isEmpty ||
                //               selectedDate == "00000000") {
                //             print("🚨 Date invalide : $selectedDate");
                //             return;
                //           }

                //           await transfertDataToFlutter(context, selectedDate);

                //           showDialog(
                //             context: context,
                //             builder: (_) => AlertDialog(
                //               title: Text('Données importées'),
                //               content: Text(
                //                   'Les données ont été importées de internet vers le téléphone avec succès pour la date : $selectedDate'),
                //               actions: [
                //                 TextButton(
                //                   child: Text('OK'),
                //                   onPressed: () => Navigator.of(context).pop(),
                //                 ),
                //               ],
                //             ),
                //           );
                //         } catch (e) {
                //           showDialog(
                //             context: context,
                //             builder: (_) => AlertDialog(
                //               title: Text('Erreur'),
                //               content: Text(
                //                   'Erreur lors de l\'importation de internet vers le téléphone : $e'),
                //               actions: [
                //                 TextButton(
                //                   child: Text('OK'),
                //                   onPressed: () => Navigator.of(context).pop(),
                //                 ),
                //               ],
                //             ),
                //           );
                //         } finally {
                //           setState(() {
                //             isImportingBackEnd = false;
                //           });
                //         }
                //       });
                //     },
                //     child: Center(
                //       child: isImportingBackEnd
                //           ? CircularProgressIndicator()
                //           : Text(
                //               'Import backEnd',
                //               style: TextStyle(
                //                 color: Colors.black,
                //                 fontSize: 18.0,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //               textAlign: TextAlign.center,
                //             ),
                //     ),
                //   ),
                // ),
              ],
            ),
            // SizedBox(height: 60),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Container(
            //       width: 150,
            //       height: 100,
            //       decoration: BoxDecoration(
            //         color: Colors.grey[300],
            //         border: Border.all(
            //           color: Colors.black87,
            //           width: 0.0,
            //         ),
            //         borderRadius: BorderRadius.circular(15.0),
            //       ),
            //       child: InkWell(
            //         borderRadius: BorderRadius.circular(15.0),
            //         onTap: () async {
            //           ViderBDPage();
            //           // Afficher une confirmation à l'utilisateur
            //           showDialog(
            //             context: context,
            //             builder: (_) => AlertDialog(
            //               title: Text('testttttttt'),
            //               content: Text('test succès.'),
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
            //         },
            //         child: Center(
            //           child: Text(
            //             'Vider ma base',
            //             style: TextStyle(
            //               color: Colors.black,
            //               fontSize: 18.0,
            //               fontWeight: FontWeight.bold,
            //             ),
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}

Future<void> showDatePickerDialog(
    BuildContext context, Function(String) onDateSelected) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000), // Date minimale
    lastDate: DateTime(2100), // Date maximale
    locale: const Locale("fr", "FR"), // Pour le format français
    helpText: "Sélectionnez une date", // Texte d'aide
  );

  if (pickedDate != null) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
    onDateSelected(formattedDate); // On renvoie la date sélectionnée
  }
}

void showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Information'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
        ),
      ],
    ),
  );
}
