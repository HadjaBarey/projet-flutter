import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';

class CaisseController {
  final formKey = GlobalKey<FormState>();
  late Box<JournalCaisseModel> todobos6;
  late Box<EntrepriseModel> entrepriseBox;

  CaisseController() {
    initializeData();
  }

  TextEditingController idjournalController = TextEditingController();
  TextEditingController dateJournalController = TextEditingController();
  TextEditingController montantJController = TextEditingController();
  TextEditingController typeCompteController = TextEditingController();
  TextEditingController operateurController = TextEditingController();


    // Méthode pour charger les données depuis la boîte Hive
  Future<List<JournalCaisseModel>> loadData() async {
    List<JournalCaisseModel> lisCaisse = [];
    await initializeBox();
    if (todobos6 != null) {
      lisCaisse = await _loadDeposFromHive();
    }
    return lisCaisse;
  }

    Future<List<JournalCaisseModel>> _loadDeposFromHive() async {
    List<JournalCaisseModel> lisCaisse = [];
    for (var value in todobos6!.values) {
      lisCaisse.add(value);
    }
    return lisCaisse;
  }


  List<Map<String, String>> operateurOptions = [
    {'value': '1', 'label': 'Orange'},
    {'value': '2', 'label': 'Moov'}
  ];
  String selectedOperateur = '1';

  List<Map<String, String>> TypeComptes = [
    {'value': '1', 'label': 'Transfert'},
    {'value': '2', 'label': 'Caisse'},
  ];
  String selectedTypeCpt = '1';

  Future<void> initializeData() async {
    await Hive.initFlutter();
    await initializeBox();
    await DateControleRecupere();
  }

  String getOperateurLabel(String value) {
    final option = operateurOptions.firstWhere((element) => element['value'] == value, orElse: () => {'label': 'Inconnu'});
    return option['label']!;
  }

  String getTypeOperationLabel(String value) {
    final option = TypeComptes.firstWhere((element) => element['value'] == value, orElse: () => {'label': 'Inconnu'});
    return option['label']!;
  }

  void updateSelectedOperateur(String value) {
    selectedOperateur = value;
  }

  void updateSelectedTypeOpe(String value) {
    selectedTypeCpt = value; 
  }

  JournalCaisseModel Caisse = JournalCaisseModel(
    idjournal: 0,
    dateJournal: '',
    montantJ: '',
    typeCompte: '',
    operateur: '',
  );

  void resetFormFields() {
    Caisse = JournalCaisseModel(
      idjournal: Caisse.idjournal + 1,
      dateJournal: '',
      montantJ: '',
      typeCompte: '',
      operateur: '',
    );
    idjournalController.text = Caisse.idjournal.toString();
    dateJournalController.clear();
    montantJController.clear();
    typeCompteController.clear();
    operateurController.clear();
  }

  void _initializeClientId() {
    if (todobos6.isNotEmpty) {
      final sortedClients = todobos6.values.toList()
        ..sort((a, b) => a.idjournal.compareTo(b.idjournal));
      final lastCaisse = sortedClients.last;
      Caisse.idjournal = lastCaisse.idjournal + 1;
    } else {
      Caisse.idjournal = 1;
    }
    idjournalController.text = Caisse.idjournal.toString();
  }

  Future<void> initializeBox() async {
    print('Initializing Hive and opening boxes...');
    if (!Hive.isAdapterRegistered(JournalCaisseModelAdapter().typeId)) {
      Hive.registerAdapter(JournalCaisseModelAdapter());
    }
    if (!Hive.isAdapterRegistered(EntrepriseModelAdapter().typeId)) {
      Hive.registerAdapter(EntrepriseModelAdapter());
    }
    todobos6 = await Hive.openBox<JournalCaisseModel>("todobos6");
    await _initializeEntreprisesBox(); // Assurez-vous d'initialiser entrepriseBox
    print('Hive and boxes initialized.');
  }

  // Future<List<JournalCaisseModel>> loadData() async {
  //   if (todobos6.isEmpty) {
  //     return [];
  //   }
  //   return todobos6.values.toList();
  // }

  void updateAddSim({
    int? idjournal,
    String? dateJournal,
    String? montantJ,
    String? typeCompte,
    String? operateur,
    String? soldeInitial,
  }) {
    if (idjournal != null) Caisse.idjournal = idjournal;
    if (dateJournal != null) Caisse.dateJournal = dateJournal;
    if (montantJ != null) Caisse.montantJ = montantJ;
    if (typeCompte != null) Caisse.typeCompte = typeCompte;
    if (operateur != null) Caisse.operateur = operateur;
  }

  Future<void> saveAddCaisseData() async {
    try {
      await todobos6.put(Caisse.idjournal, Caisse);
      print("Enregistrement réussi : $Caisse");
      //await DateControleRecupere(); // Mettre à jour la date après enregistrement
    } catch (e) {
      print("Erreur lors de l'enregistrement : $e");
    }
  }

  Future<void> markAsDeleted(JournalCaisseModel CaisseJ) async {
    if (todobos6 != null) {
      await todobos6.put(CaisseJ.idjournal, CaisseJ).then((value) {
        print("Client marqué comme supprimé : $CaisseJ");
      }).catchError((error) {
        print("Erreur lors de la mise à jour : $error");
      });
    }
  }

  Future<void> _initializeEntreprisesBox() async {
    if (!Hive.isBoxOpen("todobos2")) {
      await Hive.openBox<EntrepriseModel>("todobos2");
    }
    entrepriseBox = Hive.box<EntrepriseModel>("todobos2");
  }

  Future<void> DateControleRecupere() async {
    print('Appel de DateControleRecupere...');
    await _initializeEntreprisesBox();
    
    if (entrepriseBox.isEmpty) {
      print("Boîte Hive des entreprises non initialisée ou vide");
      dateJournalController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    } else {
      print('La boîte Hive des entreprises contient des données.');
      var entreprise = entrepriseBox.values.last;
      if (entreprise != null) {
        try {
          if (entreprise.DateControle.isNotEmpty) {
            DateFormat dateFormat = DateFormat('dd/MM/yyyy');
            DateTime parsedDate = dateFormat.parseStrict(entreprise.DateControle);
            dateJournalController.text = dateFormat.format(parsedDate);
          } else {
            print("La date de contrôle est vide");
          }
        } catch (e) {
          print("Erreur lors de la conversion de la date : $e");
          dateJournalController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
        }
      } else {
        dateJournalController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
        print('Aucune entreprise trouvée');
      }
    }
  }
}
