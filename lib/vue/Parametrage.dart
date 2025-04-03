import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour formater la date
import 'package:kadoustransfert/Controller/EntrepriseController.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/apiSprintBoot/transfertFlutterBD.dart';
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
                        // Afficher une boîte de dialogue de confirmation
                        bool? confirmation = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmation'),
                              content: Text('Êtes-vous sûr de vouloir synchroniser les données ?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Annuler'),
                                  onPressed: () {
                                    Navigator.of(context).pop(false); // Annuler
                                  },
                                ),
                                TextButton(
                                  child: Text('Confirmer'),
                                  onPressed: () {
                                    Navigator.of(context).pop(true); // Confirmer
                                  },
                                ),
                              ],
                            );
                          },
                        );

                        // Si l'utilisateur a confirmé, procéder à la synchronisation
                        if (confirmation == true) {
                          saveMultipleDefaultAddSimModels();
                          saveDefaultEntrepriseModel();

                          // Afficher une confirmation à l'utilisateur
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Données Synchronisées'),
                              content: Text('Les données ont été synchronisées avec succès.'),
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
                      // Appel de la fonction pour copier le fichier exporté vers un autre dossier
                      await exportDataToJson();
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
                // Premier bouton : Export backEnd
                Container(
                  width: 150, // Largeur fixe
                  height: 100, // Hauteur fixe
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.black87, width: 0.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () async {
                      
                      showDatePickerDialog(context, (selectedDate) async {
                        try {
                          // Vérifier le token
                          String? token = await getTokenDataFlutter();
                          if (token == null) {
                            bool isConnected = await connexionManuelleDataFlutter(
                                'ouedraogomariam@gmail.com', '000');
                            if (!isConnected) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('Erreur de connexion'),
                                  content: Text('Impossible de se connecter.'),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                          }

                          // Récupérer les données
                          EntrepriseModel? entreprise = await getEntrepriseFromHive();
                          if (entreprise == null) {
                            print('❌ Aucune entreprise trouvée.');
                            return;
                          }

                          final operations = await getDataFromHive();

                          // Envoyer les données
                          await transfertDataToSpringBoot(operations, selectedDate);

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Données exportées'),
                              content: Text(
                                  'Les données ont été exportées avec succès pour la date : $selectedDate'),
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
                              content: Text('Erreur lors de l\'exportation : $e'),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        }
                      });
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
      showDatePickerDialog(context, (selectedDate) async {
        try {
          // Vérifier si la date est vide ou invalide
          if (selectedDate.isEmpty || selectedDate == "00000000") {
            print("🚨 Date invalide : $selectedDate");
            return;
          }

          // Vérification du token
          String? token = await getTokenDataFlutter(); // Utilisez la fonction correcte pour récupérer le token
          if (token == null) {
            bool isConnected = await connexionManuelleDataFlutter('ouedraogomariam@gmail.com', '000');
            if (!isConnected) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Erreur de connexion'),
                  content: Text('Impossible de se connecter.'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
              return;
            }
          }

         // Importation des données depuis Spring Boot et stockage dans Hive
         await transfertDataToFlutter(context, selectedDate);
          // Afficher une confirmation de succès
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Données importées'),
              content: Text('Les données ont été importées avec succès pour la date : $selectedDate'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        } catch (e) {
          // Afficher un message d'erreur en cas d'exception
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Erreur'),
              content: Text('Erreur lors de l\'importation : $e'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        }
      });
    },
    child: Center(
      child: Text(
        'Import backEnd',
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

               ],
             )
             
          ],
        ),
      ),
    );
  }
}

Future<void> showDatePickerDialog(BuildContext context, Function(String) onDateSelected) async {
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



