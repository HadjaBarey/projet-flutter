import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';

class CaisseController {
  final formKey = GlobalKey<FormState>();
  late Box<JournalCaisseModel> todobos6;
  late Box<EntrepriseModel> entrepriseBox;
  late Box<AddSimModel> todobos5;

  CaisseController() {
    initializeData();
  }

  TextEditingController idjournalController = TextEditingController();
  TextEditingController dateJournalController = TextEditingController();
  TextEditingController montantJController = TextEditingController();
  TextEditingController typeCompteController = TextEditingController();
  TextEditingController operateurController = TextEditingController();
  ValueNotifier<List<Map<String, String>>> operateurOptionsNotifier = ValueNotifier([]);
 
  // Liste des opérateurs
  List<AddSimModel> operateurList = [];
  List<Map<String, String>> operateurOptions = [];



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
    for (var value in todobos6.values) {
      lisCaisse.add(value);
    }
    return lisCaisse;
  }

  List<Map<String, String>> TypeComptes = [
    {'value': '1', 'label': 'Transfert'},
    {'value': '2', 'label': 'Caisse'},
    {'value': '3', 'label': 'unité'},
  ];
  String selectedTypeCpt = '1';
  

  Future<void> initializeData() async {
    await Hive.initFlutter();
    await initializeBox();
    await DateControleRecupere();
    await loadOperateurs(); // Assurez-vous que operateurList est remplie ici
   // print('Operateur List après chargement: $operateurList');
    CaisseOperateursController();
  }

  Future<void> loadOperateurs() async {
    try {
      operateurList = await fetchOperateursFromDatabase();
     // print('Operateur List chargée: $operateurList');
      _updateOperateurOptions();
      CaisseOperateursController(); // Assurez-vous de mettre à jour les options après le chargement
    } catch (e) {
   // print('Erreur lors du chargement des opérateurs: $e');
    }
  }


   void _updateOperateurOptions() {
    final options = operateurList
        .map((item) => {'value': item.idOperateur.toString(), 'label': item.LibOperateur})
        .toList();
    operateurOptionsNotifier.value = options;
  }


  Future<List<AddSimModel>> fetchOperateursFromDatabase() async {
    await initializeBox(); // Assurez-vous que la boîte est initialisée
    
    List<AddSimModel> operateurs = [];
    
    // Vérifiez si la boîte n'est pas vide et récupérez les valeurs
    if (todobos5.isNotEmpty) {
      // Filtrer les valeurs en utilisant 'where' pour vérifier le type et les convertir
      operateurs = todobos5.values
          .where((value) => value is AddSimModel) // Filtrer les objets de type AddSimModel
          .cast<AddSimModel>() // Convertir en List<AddSimModel>
          .toList();
    }
    
    return operateurs;
  }


  String getTypeOperationLabel(String value) {
    final option = TypeComptes.firstWhere((element) => element['value'] == value, orElse: () => {'label': 'Inconnu'});
    return option['label']!;
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
    selectedTypeCpt = '1';
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
    //print('Initializing Hive and opening boxes...');
    if (!Hive.isAdapterRegistered(JournalCaisseModelAdapter().typeId)) {
      Hive.registerAdapter(JournalCaisseModelAdapter());
    }
    if (!Hive.isAdapterRegistered(EntrepriseModelAdapter().typeId)) {
      Hive.registerAdapter(EntrepriseModelAdapter());
    }
    if (!Hive.isAdapterRegistered(AddSimModelAdapter().typeId)) {
      Hive.registerAdapter(AddSimModelAdapter());
    }
    todobos6 = await Hive.openBox<JournalCaisseModel>("todobos6");
     todobos5 = await Hive.openBox<AddSimModel>("todobos5");
    await _initializeEntreprisesBox();
    // Écouteur pour surveiller les changements sur la boîte todobos5
    todobos5.listenable().addListener(() {
      loadOperateurs();  // Recharge les opérateurs automatiquement en cas de modification
    });
    //await _initializeEntreprisesBox(); // Assurez-vous d'initialiser entrepriseBox
   // print('Hive and boxes initialized.');
  }


  Future<void> saveAddCaisseData() async {
    try {
      // Générer un nouvel ID unique pour la nouvelle entrée
      _initializeClientId(); // Assure que l'ID est bien initialisé

      // Mettre à jour le modèle avec les valeurs des contrôleurs
      Caisse.dateJournal = dateJournalController.text;
      Caisse.montantJ = montantJController.text;
      Caisse.typeCompte = selectedTypeCpt;
      Caisse.operateur = operateurController.text;

      // Enregistrer dans la boîte Hive
      await todobos6.put(Caisse.idjournal, Caisse);
     // print("Enregistrement réussi : $Caisse");

      // Réinitialiser le formulaire après enregistrement
      resetFormFields();
    } catch (e) {
   //   print("Erreur lors de l'enregistrement : $e");
    }
  }

  Future<void> _initializeEntreprisesBox() async {
    if (!Hive.isBoxOpen("todobos2")) {
      await Hive.openBox<EntrepriseModel>("todobos2");
    }
    entrepriseBox = Hive.box<EntrepriseModel>("todobos2");
  }

  Future<void> DateControleRecupere() async {
    await _initializeEntreprisesBox();

    if (entrepriseBox.isEmpty) {
      //print("Boîte Hive des entreprises non initialisée ou vide");
      dateJournalController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    } else {
      var entreprise = entrepriseBox.values.last;
      if (entreprise != null) {
        try {
          if (entreprise.DateControle.isNotEmpty) {
            DateFormat dateFormat = DateFormat('dd/MM/yyyy');
            DateTime parsedDate = dateFormat.parseStrict(entreprise.DateControle);
            dateJournalController.text = dateFormat.format(parsedDate);
          } else {
            dateJournalController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
          }
        } catch (e) {
         // print("Erreur lors de la conversion de la date : $e");
          dateJournalController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
        }
      } else {
        dateJournalController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      }
    }

  //  print('Valeur de dateJournalController.text: ${dateJournalController.text}');
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(''),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void CaisseOperateursController() {
    operateurOptions = operateurList
        .map((item) => {'value': item.idOperateur.toString(), 'label': item.LibOperateur})
        .toList();

    //print("Operateur Options: $operateurOptions");
  }



Future<String> getLibOperateur(String operateur) async {
  // Ouvrir la boîte Hive
  var addSimBox = await Hive.openBox<AddSimModel>('todobos5');

  // Déboguer le contenu de la boîte pour s'assurer qu'elle contient des données
  //print('Contenu de addSimBox: ${addSimBox.values.toList()}');

  // Rechercher le modèle correspondant
  AddSimModel? correspondingAddSimModel = addSimBox.values.firstWhere(
    (addSim) => addSim.idOperateur.toString() == operateur,
    orElse:  () => AddSimModel(
          idOperateur: 0,
          LibOperateur: '',
          NumPhone: '',
          CodeAgent: '',
          supprimer: 0,
        ), // Retourner null si aucune correspondance n'est trouvée
  );

  // Déboguer le résultat de la recherche
  if (correspondingAddSimModel != null) {
   // print('Modèle trouvé: ${correspondingAddSimModel.LibOperateur}');
  } else {
   // print('Aucun modèle trouvé pour l\'opérateur $operateur');
  }

  // Retourner le libellé ou 'Caisse' si aucune correspondance n'est trouvée
  return correspondingAddSimModel?.LibOperateur.isNotEmpty == true
      ? correspondingAddSimModel.LibOperateur
      : 'Caisse';
}




Future<List<JournalCaisseModel>> getAllCaisseData(DateTime dateFilter) async {
  List<JournalCaisseModel> allCaisseData = [];
  
  try {
    // Assurez-vous que la boîte est initialisée
    await initializeBox();

    // Vérifiez si la boîte contient des éléments
    if (todobos6.isNotEmpty) {
      // Itérez à travers toutes les valeurs de la boîte
      allCaisseData = todobos6.values.toList();

      // Filtrer les données en fonction de la date
      allCaisseData = allCaisseData.where((data) {
        // Convertir la date stockée en DateTime pour la comparaison
        DateTime dataDate = DateTime.parse(data.dateJournal); // Assurez-vous que dateJournal est au format ISO 8601
        return dataDate.year == dateFilter.year &&
               dataDate.month == dateFilter.month &&
               dataDate.day == dateFilter.day;
      }).toList();
    } 
  } catch (e) {
    // Gérer les erreurs
   // print('Erreur lors de la récupération des données : $e');
  }

  return allCaisseData;
}



}
