import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Controller/CaisseController.dart';
//import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';
import 'package:kadoustransfert/vue/AddCaisse.dart';
import 'package:kadoustransfert/Controller/OrangeController.dart';

class CaissePage extends StatefulWidget {
  const CaissePage({super.key});

  @override
  State<CaissePage> createState() => _CaissePageState();
}

class _CaissePageState extends State<CaissePage> {
  final CaisseController _controller = CaisseController();
  List<JournalCaisseModel> listCaiss = [];
  final OrangeController _orangeController = OrangeController([]);
  String? dateControle;
  DateTime dateJour = new DateTime.now();
  final ValueNotifier<List<JournalCaisseModel>> _filteredListNotifier = ValueNotifier<List<JournalCaisseModel>>([]);




  double getSumMontantJ() {
    double sum = 0.0;
    for (var item in _filteredListNotifier.value) {
      sum += double.tryParse(item.montantJ) ?? 0.0;
    }
    return sum;
  }
  

  Future<void> DateControleRecupere() async {
    await _controller.DateControleRecupere().then((v){
       setState(() {
        dateControle = _controller.dateJournalController.text;
       // print('Date de contrôle récupérée : $dateControle');
        filterListByDate();
      });  
    }); 
    
  }



  void filterListByDate() {
    // print("ma date ");
    if (dateControle != null) {
      _filteredListNotifier.value = listCaiss.where((item) => item.dateJournal == dateControle).toList();
      //print('Liste filtrée par date : ${_filteredListNotifier.value}');
    } else {
      _filteredListNotifier.value = listCaiss;
      // print('Aucune date de contrôle, utilisation de la liste complète');
    }
  }

  Future<List<TableRow>> buildTableRows(List<JournalCaisseModel> filteredList) async {
    final formatter = NumberFormat('###,###', 'fr_FR');

    // Remplacez temporairement les valeurs de 'operateur'
    for (var item in filteredList) {
      if (item.typeCompte == '2') {
        item.operateur = '100';
      }
    }

    // Triez la liste modifiée
    filteredList.sort((a, b) {
      int operateurComparison = a.operateur.compareTo(b.operateur);
      if (operateurComparison != 0) {
        return operateurComparison;
      }
      return a.typeCompte.compareTo(b.typeCompte);
    });

    // Map pour stocker les sommes regroupées
    Map<String, double> sumMap = {};
    sumMap['100_2'] = 0.0;

    // Calculer les sommes regroupées
    for (var item in filteredList) {
      String key = '${item.operateur}_${item.typeCompte}';
      double montant = double.tryParse(item.montantJ) ?? 0.0;
      if (sumMap.containsKey(key)) {
        sumMap[key] = sumMap[key]! + montant;
      } else {
        sumMap[key] = montant;
      }
    }

    // Calculer l'augmentation et la diminution
    final sumResult = await _orangeController.calculateSum(DateFormat('dd/MM/yyyy'));
    final augmentation = sumResult['augmentation'] ?? {};
    final diminution = sumResult['diminution'] ?? {};

    // Variables pour stocker la somme totale des soldes initiaux et finaux
    double totalSoldeInitial = 0.0;
    double totalSoldeFinal = 0.0;

    // Construire les lignes du tableau
    List<TableRow> rows = [];
    sumMap.forEach((key, sum) {
      List<String> parts = key.split('_');
      String operateur = parts[0];
      String typeCompte = parts[1];
      String formattedMontantJ = formatter.format(sum).replaceAll(',', ' ');

      double augmentationValue = augmentation[operateur] ?? 0.0;
      double diminutionValue = diminution[operateur] ?? 0.0;

      // Calculer le solde final
      double soldeFinal = sum + augmentationValue - diminutionValue;
      String formattedSoldeFinal = formatter.format(soldeFinal).replaceAll(',', ' ');

      // Ajouter aux totaux
      totalSoldeInitial += sum;
      totalSoldeFinal += soldeFinal;

      rows.add(
        TableRow(
          children: [
          TableCell(
              child: Align(
                alignment: Alignment.topLeft,
                child: FutureBuilder<String>(
                  future: _controller.getLibOperateur(operateur),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Erreur');
                    } else if (!snapshot.hasData) {
                      return Text('Non disponible');
                    } else {
                      return Text(snapshot.data ?? 'Caisse');
                    }
                  },
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(formattedMontantJ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(formatter.format(augmentationValue).replaceAll(',', ' ')),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(formatter.format(diminutionValue).replaceAll(',', ' ')),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(formattedSoldeFinal),
              ),
            ),
          ],
        ),
      );
    });

    // Ajouter la ligne de totaux au tableau
    final formattedTotalSoldeInitial = formatter.format(totalSoldeInitial).replaceAll(',', ' ');
    final formattedTotalSoldeFinal = formatter.format(totalSoldeFinal).replaceAll(',', ' ');

    rows.add(
      TableRow(
        children: [
          TableCell(
            child: Align(
              alignment: Alignment.center,
              child: Text('Totaux'),
            ),
          ),
          TableCell(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(formattedTotalSoldeInitial),
            ),
          ),
          TableCell(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(''),
            ),
          ),
          TableCell(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(''),
            ),
          ),
          TableCell(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(formattedTotalSoldeFinal),
            ),
          ),
        ],
      ),
    );

    return rows;
  }

  Future<void> iniData() async {
    try {
      await _controller.loadData().then((value) async {
        setState(() {
          listCaiss = value;
          // filterListByDate();
          DateControleRecupere();
        });
      });
    } catch (e) {
      // Handle error
      //print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    DateControleRecupere(); // Appel de la fonction pour récupérer la date
    iniData();
  }

///////////////////////////GESTION DE LA TABLE DETAILS /////////////////////////////////////////////////////

// Future<List<TableRow>> buildDetailRows(List<JournalCaisseModel> filteredList) async {
//   final formatter = NumberFormat('###,###', 'fr_FR');
//    final CaisseController caisseController = CaisseController(); // Créer une instance du contrôleur
//   List<TableRow> rows = [];

//   for (var item in filteredList) {
//     // Récupérer le libellé de l'opérateur
//     String libelleOperateur = await caisseController.getLibOperateur(item.operateur);

//     // Formater le montant
//     String formattedMontantJ = formatter.format(double.tryParse(item.montantJ) ?? 0.0).replaceAll(',', ' ');

//     // Ajouter la ligne avec les informations
//     rows.add(
//       TableRow(
//         children: [
//           TableCell(
//             child: Align(
//               alignment: Alignment.topLeft,
//               child: Text(libelleOperateur), // Affiche la date
//             ),
//           ),
//           TableCell(
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: Text(formattedMontantJ), // Montant formaté
//             ),
//           ),
//           TableCell(
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: Text('0'), // Affiche le libellé de l'opérateur
//             ),
//           ),
//           TableCell(
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: Text('0'), // Si vous avez d'autres valeurs à afficher
//             ),
//           ),
//           TableCell(
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: Text('0'), // Si vous avez d'autres valeurs à afficher
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   rows.add(
//     TableRow(
//       children: [
//         TableCell(
//           child: Align(
//             alignment: Alignment.topLeft,
//             child: Text('Totaux'),
//           ),
//         ),
//         TableCell(
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: Text('0'), // Mettre le total si calculé
//           ),
//         ),
//         TableCell(
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: Text('0'), // Mettre le total si calculé
//           ),
//         ),
//         TableCell(
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: Text('0'), // Mettre le total si calculé
//           ),
//         ),
//         TableCell(
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: Text('0'), // Mettre le total si calculé
//           ),
//         ),
//       ],
//     ),
//   );

//   return rows;
// }

/////////////////////////////////////////FIN////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    double totalMontantJ = getSumMontantJ();
     _filteredListNotifier.value = listCaiss.where((item) => item.dateJournal == _controller.dateJournalController.text).toList();
    final formattedTotalMontantJ = NumberFormat('###,###', 'fr_FR').format(totalMontantJ).replaceAll(',', ' ');



// Calculer la hauteur dynamique en fonction de la taille de l'écran
  double screenHeight = MediaQuery.of(context).size.height;
  double dynamicSpacing = screenHeight * 0.05; // Par exemple, 5% de la hauteur de l'écran

    
    return Scaffold(
      appBar: AppBar(
        title: const Text('TABLEAUX DES TRANSACTIONS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<List<JournalCaisseModel>>(
                valueListenable: _filteredListNotifier,
                builder: (context, filteredList, child) {
                  return FutureBuilder<List<TableRow>>(
                    future: buildTableRows(filteredList),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      } else {
                        return Table(
                          border: TableBorder.all(width: 1.0),
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Colors.grey[200]),
                              children: [
                                TableCell(child: Center(child: Text('Compte'))),
                                TableCell(child: Center(child: Text('Solde Initial'))),
                                TableCell(child: Center(child: Text('Augmentation'))),
                                TableCell(child: Center(child: Text('Diminution'))),
                                TableCell(child: Center(child: Text('Solde Final'))),
                              ],
                            ),
                            ...snapshot.data!,
                          ],
                        );
                      }
                    },
                  );
                },
              ),
            ),



         // Nouveau tableau pour le détail des jours
    //       SizedBox(height: 20), // Espacement entre les deux tableaux
    //       Text(
    //         'DETAILS DE LA JOURNEE',
    //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //       ),
    //       Expanded(
    //         child: ValueListenableBuilder<List<JournalCaisseModel>>(
    //           valueListenable: _filteredListNotifier,
    //           builder: (context, filteredList, child) {
    //             return FutureBuilder<List<TableRow>>(
    //               future: buildDetailRows(filteredList), // Utilisation de la fonction buildDetailRows
    //               builder: (context, snapshot) {
    //                 if (snapshot.connectionState == ConnectionState.waiting) {
    //                   return Center(child: CircularProgressIndicator());
    //                 } else if (snapshot.hasError) {
    //                   return Center(child: Text('Erreur: ${snapshot.error}'));
    //                 } else {
    //                   return Table(
    //                     border: TableBorder.all(width: 1.0),
    //                     children: [
    //                       TableRow(
    //                         decoration: BoxDecoration(color: Colors.grey[200]),
    //                         children: [
    //                           TableCell(child: Center(child: Text('Compte'))),
    //                           TableCell(child: Center(child: Text('Solde Initial'))),
    //                           TableCell(child: Center(child: Text('Augmentation'))),
    //                           TableCell(child: Center(child: Text('Dimission'))),
    //                           TableCell(child: Center(child: Text('Solde Final'))),
    //                         ],
    //                       ),
    //                       ...snapshot.data!,
    //                     ],
    //                   );
    //                 }
    //               },
    //             );
    //           },
    //         ),
    //       ),
        ],
      ),
    ),     



      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCaisssePage(caisseController: _controller),
            ),
          );
          if (result == true) {
            await iniData(); // Réactualise les données après la fermeture de la vue d'ajout
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Ajouter un client',
      ),
    );
  }
}
