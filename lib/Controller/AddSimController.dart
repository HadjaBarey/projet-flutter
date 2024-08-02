import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kadoustransfert/Model/AddSimModel.dart';

class AddSimController {
  final formKey = GlobalKey<FormState>();
  late Box<AddSimModel> todobos5;

  AddSimController() {
    initializeBox();
  }

  TextEditingController idOperateurController = TextEditingController();
  TextEditingController LibOperateurController = TextEditingController();
  TextEditingController NumPhoneController = TextEditingController();
  TextEditingController CodeAgentController = TextEditingController();
  TextEditingController supprimerController = TextEditingController(text: '0');

  AddSimModel Operateur = AddSimModel(
    idOperateur: 0,
    LibOperateur: '',
    NumPhone: '',
    CodeAgent: '',
    supprimer: 0,
  );

  Future<void> initializeBox() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(AddSimModelAdapter().typeId)) {
      Hive.registerAdapter(AddSimModelAdapter());
    }
    todobos5 = await Hive.openBox<AddSimModel>("todobos5");
    _initializeClientId();
  }

  Future<void> _initializeClientId() async {
    // Attendre que la boîte Hive soit complètement prête
    await Future.delayed(Duration(milliseconds: 500)); // Optionnel : attendre un court instant pour la synchronisation
    final existingIds = todobos5.values.map((e) => e.idOperateur).toSet();
   // print("ID existants : $existingIds"); // Débogage
    int nextId = 1;

    while (existingIds.contains(nextId)) {
      nextId++;
    }

    //print("Prochain ID disponible : $nextId"); // Débogage
    Operateur.idOperateur = nextId;
    idOperateurController.text = Operateur.idOperateur.toString();
    // print("ID après initialisation : ${Operateur.idOperateur}");
    // print("Valeur du contrôleur après initialisation : ${idOperateurController.text}");
  }

  void resetFormFields() {
    // Réinitialiser les champs du formulaire
    LibOperateurController.clear();
    NumPhoneController.clear();
    CodeAgentController.clear();
    supprimerController.clear();

    // Recalculer l'idOperateur pour le prochain ajout
    _initializeClientId();

    // Réinitialiser l'objet Operateur avec le nouvel idOperateur
    Operateur = AddSimModel(
      idOperateur: int.parse(idOperateurController.text), // Utiliser le nouvel idOperateur
      LibOperateur: '',
      NumPhone: '',
      CodeAgent: '',
      supprimer: 0,
    );
  }

  Future<List<AddSimModel>> loadData() async {
    if (todobos5.isEmpty) {
      return [];
    }
    return todobos5.values.toList();
  }

  void updateAddSim({
    int? idOperateur,
    String? LibOperateur,
    String? NumPhone,
    String? CodeAgent,
    int? supprimer,
  }) {
    if (idOperateur != null) Operateur.idOperateur = idOperateur;
    if (NumPhone != null) Operateur.NumPhone = NumPhone;
    if (LibOperateur != null) Operateur.LibOperateur = LibOperateur;
    if (CodeAgent != null) Operateur.CodeAgent = CodeAgent;
  }

  Future<void> saveAddSimData() async {
    try {
      await todobos5.put(Operateur.idOperateur, Operateur);
     // print("Enregistrement réussi : $Operateur");
    } catch (e) {
      //print("Erreur lors de l'enregistrement : $e");
    }
  }

  Future<void> markAsDeleted(AddSimModel OpeSim) async {
    if (todobos5 != null) {
      await todobos5.put(OpeSim.idOperateur, OpeSim).then((value) {
        print("Client marqué comme supprimé : $OpeSim");
      }).catchError((error) {
        print("Erreur lors de la mise à jour : $error");
      });
    }
  }

  String? getCodeAgent(String operateur) {
    try {
      AddSimModel? simOpe;
      for (var sim in todobos5.values) {
        if (sim.LibOperateur == operateur && sim.supprimer == 0) {
          simOpe = sim;
          break;
        }
      }
      return simOpe?.CodeAgent;
    } catch (e) {
      print("Erreur lors de la récupération du CodeAgent : $e");
      return null;
    }
  }
}
