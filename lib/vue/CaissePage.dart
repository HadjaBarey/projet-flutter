import 'package:flutter/material.dart';
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

  // Remplacer opérateur par '100' pour typeCompte == 2
  for (var item in filteredList) {
    if (item.typeCompte == '2') {
      item.operateur = '100'; // Caisse virtuelle
    }
  }

  // Récupérer dynamiquement les opérateurs actifs
  List<Map<String, String>> allOperateurs = await _controller.getAllOperateursActifs();

  // Ajouter manuellement l'opérateur virtuel '100'
  allOperateurs.add({'operateur': '100', 'typeCompte': '2'});

  // Trier la liste filtrée
  filteredList.sort((a, b) {
    int operateurComparison = a.operateur.compareTo(b.operateur);
    if (operateurComparison != 0) return operateurComparison;
    return a.typeCompte.compareTo(b.typeCompte);
  });

  // Regrouper les montants par clé opérateur et typeCompte
  Map<String, double> sumMap = {};
  for (var item in filteredList) {
    String key = '${item.operateur}_${item.typeCompte}';
    double montant = double.tryParse(item.montantJ) ?? 0.0;
    sumMap[key] = (sumMap[key] ?? 0.0) + montant;
  }

  // Calculer augmentation et diminution
  final sumResult = await _orangeController.calculateSum(DateFormat('dd/MM/yyyy'));
  final augmentation = sumResult['augmentation'] ?? {};
  final diminution = sumResult['diminution'] ?? {};

  double totalSoldeInitial = 0.0;
  double totalSoldeFinal = 0.0;
  List<TableRow> rows = [];

  // Générer les lignes du tableau pour chaque opérateur
  for (var op in allOperateurs) {
    String operateur = op['operateur']!;
    String typeCompte = op['typeCompte']!;
    String key = '${operateur}_${typeCompte}';

    // Calculer le montant total pour cet opérateur et type de compte
    double montant = sumMap[key] ?? 0.0;
    String formattedMontant = _formatMontant(montant, formatter);

    double aug = augmentation[operateur] ?? 0.0;
    double dim = diminution[operateur] ?? 0.0;

    // Calculer le solde final
    double soldeFinal = montant + aug - dim;
    String formattedSoldeFinal = _formatMontant(soldeFinal, formatter);

    totalSoldeInitial += montant;
    totalSoldeFinal += soldeFinal;

    // Ajouter une ligne au tableau
    rows.add(
      TableRow(
        children: [
          TableCell(
            child: Align(
              alignment: Alignment.topLeft,
              child: operateur == '100'
                  ? Text('Caisse') // Libellé spécifique pour caisse virtuelle
                  : FutureBuilder<String>(
                      future: _controller.getLibOperateur(operateur),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError || !snapshot.hasData) {
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
              child: Text(formattedMontant),
            ),
          ),
          TableCell(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(_formatMontant(aug, formatter)),
            ),
          ),
          TableCell(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(_formatMontant(dim, formatter)),
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
  }

  // Ajouter la ligne des totaux
  rows.add(
    TableRow(
      children: [
        TableCell(child: Center(child: Text('Totaux'))),
        TableCell(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(_formatMontant(totalSoldeInitial, formatter)),
          ),
        ),
        TableCell(child: Text('')),
        TableCell(child: Text('')),
        TableCell(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(_formatMontant(totalSoldeFinal, formatter)),
          ),
        ),
      ],
    ),
  );

  return rows;
}

// Helper function pour formater les montants
String _formatMontant(double montant, NumberFormat formatter) {
  return formatter.format(montant).replaceAll(',', ' ');
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
