import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kadoustransfert/Model/OpTransactionModel.dart';

class OpTransactionController {
  final formKey = GlobalKey<FormState>();
  late Box<OpTransactionModel> todobos3;

  OpTransactionController() {
    initializeBox();
  }

  TextEditingController idOpTransactionController = TextEditingController();
  TextEditingController CodeTransactionController = TextEditingController();
  TextEditingController TypeOperationController = TextEditingController();
  TextEditingController OperateurController = TextEditingController();
  TextEditingController supprimerController = TextEditingController(text: '0');

  List<Map<String, String>> operateurOptions = [
    {'value': '1', 'label': 'Orange'},
    {'value': '2', 'label': 'Moov'}
  ];
  String selectedOperateur = '1'; // Définir la valeur par défaut ici

  List<Map<String, String>> TypeOperationOptions = [
    {'value': '1', 'label': 'Depos Orange'},
    {'value': '2', 'label': 'Retrait orange'},
    {'value': '3', 'label': 'Retrait Sans Compte orange'},
    {'value': '4', 'label': 'Depos Moov'},
    {'value': '5', 'label': 'Retrait Moov'},
    {'value': '6', 'label': 'Retrait Sans Compte Moov'}
  ];
  String selectedTypeOpe = '1'; // Définir la valeur par défaut ici

  String getOperateurLabel(String value) {
    final option = operateurOptions.firstWhere((element) => element['value'] == value, orElse: () => {'label': 'Inconnu'});
    return option['label']!;
  }

  String getTypeOperationLabel(String value) {
    final option = TypeOperationOptions.firstWhere((element) => element['value'] == value, orElse: () => {'label': 'Inconnu'});
    return option['label']!;
  }

  void updateSelectedOperateur(String value) {
  selectedOperateur = value;
   }

  void updateSelectedTypeOpe(String value) {
    selectedTypeOpe = value; 
  }


  OpTransactionModel OpTransaction = OpTransactionModel(
    idOpTransaction: 0,
    CodeTransaction: '',
    TypeOperation: '',
    Operateur: '',
    supprimer: 0,
  );

  void resetFormFields() {
    OpTransaction = OpTransactionModel(
      idOpTransaction: OpTransaction.idOpTransaction + 1,
      CodeTransaction: '',
      TypeOperation: '',
      Operateur: '',
      supprimer: 0,
    );
    idOpTransactionController.text = OpTransaction.idOpTransaction.toString();
    CodeTransactionController.clear();
    TypeOperationController.clear();
    supprimerController.clear();
  }

  void _initializeClientId() {
    if (todobos3.isNotEmpty) {
      final sortedClients = todobos3.values.toList()
        ..sort((a, b) => a.idOpTransaction.compareTo(b.idOpTransaction));
      final lastClient = sortedClients.last;
      OpTransaction.idOpTransaction = lastClient.idOpTransaction + 1;
    } else {
      OpTransaction.idOpTransaction = 1;
    }
    idOpTransactionController.text = OpTransaction.idOpTransaction.toString();
  }

  Future<void> initializeBox() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(OpTransactionModelAdapter().typeId)) {
      Hive.registerAdapter(OpTransactionModelAdapter());
    }
    todobos3 = await Hive.openBox<OpTransactionModel>("todobos3");
    _initializeClientId();
  }

  Future<List<OpTransactionModel>> loadData() async {
    if (todobos3.isEmpty) {
      return [];
    }
    return todobos3.values.toList();
  }

  void updateOpTransaction({
    int? idOpTransaction,
    String? CodeTransaction,
    String? TypeOperation,
    String? Operateur,
    int? supprimer,
  }) {
    if (idOpTransaction != null) OpTransaction.idOpTransaction = idOpTransaction;
    if (CodeTransaction != null) OpTransaction.CodeTransaction = CodeTransaction;
    if (TypeOperation != null) OpTransaction.TypeOperation = TypeOperation;
    if (Operateur != null) OpTransaction.Operateur = Operateur;
  }



  Future<void> saveOpTransactionData() async {
    try {
      await todobos3.put(OpTransaction.idOpTransaction, OpTransaction);
      print("Enregistrement réussi : $OpTransaction");
    } catch (e) {
      print("Erreur lors de l'enregistrement : $e");
      throw Exception("Erreur lors de l'enregistrement : $e");
    }
  }

  Future<void> markAsDeleted(OpTransactionModel OpTransact) async {
    if (todobos3 != null) {
      await todobos3.put(OpTransact.idOpTransaction, OpTransact).then((value) {
        print("Client marqué comme supprimé : $OpTransact");
      }).catchError((error) {
        print("Erreur lors de la mise à jour : $error");
        throw Exception("Erreur lors de la mise à jour : $error");
      });
    }
  }
}
