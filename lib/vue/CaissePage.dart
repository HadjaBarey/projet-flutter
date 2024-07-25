import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Controller/CaisseController.dart';
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

  String getTypeCompteLabel(String operateur, String typeCompte) {
    if (operateur == '1') {
      if (typeCompte == '1') {
        return 'Transfert Orange';
      } else if (typeCompte == '3') {
        return 'Unité Orange';
      }
    } else if (operateur == '2') {
      if (typeCompte == '1') {
        return 'Transfert Moov';
      } else if (typeCompte == '3') {
        return 'Unité Moov';
      }
    }
    return 'Caisse';
  }

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
        filterListByDate();
      });
      
    });
   
    
  }


  void filterListByDate() {
    // print("ma date ");
    if (dateControle != null) {
      _filteredListNotifier.value = listCaiss.where((item) => item.dateJournal == dateControle).toList();
    } else {
      _filteredListNotifier.value = listCaiss;
    }
  }

  Future<List<TableRow>> buildTableRows(List<JournalCaisseModel> filteredList) async {
    final formatter = NumberFormat('###,###', 'fr_FR');

    // Remplacez temporairement les valeurs de 'operateur'
    for (var item in filteredList) {
      if (item.typeCompte == '2') {
        item.operateur = '9';
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
    sumMap['9_2'] = 0.0;

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
                child: Text(getTypeCompteLabel(operateur, typeCompte)),
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
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // DateControleRecupere(); // Appel de la fonction pour récupérer la date
    iniData();
  }

  @override
  Widget build(BuildContext context) {
    double totalMontantJ = getSumMontantJ();
     _filteredListNotifier.value = listCaiss.where((item) => item.dateJournal == _controller.dateJournalController.text).toList();
    final formattedTotalMontantJ = NumberFormat('###,###', 'fr_FR').format(totalMontantJ).replaceAll(',', ' ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('TABLEAUX DES TRANSACTIONS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Date de contrôle',
              ),
              onChanged: (value) {
                setState(() {
                  dateControle = value;
                });
                filterListByDate();
              },
            ),
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
