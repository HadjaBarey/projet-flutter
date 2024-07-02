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

  void resetFormFields() {
    Operateur = AddSimModel(
      idOperateur: Operateur.idOperateur + 1,
      LibOperateur: '',
      NumPhone: '',
      CodeAgent: '',
      supprimer: 0,
    );
    idOperateurController.text = Operateur.idOperateur.toString();
    CodeAgentController.clear();
    LibOperateurController.clear();
    NumPhoneController.clear();
    supprimerController.clear();
  }

  void _initializeClientId() {
    if (todobos5.isNotEmpty) {
      final sortedClients = todobos5.values.toList()
        ..sort((a, b) => a.idOperateur.compareTo(b.idOperateur));
      final lastClient = sortedClients.last;
      Operateur.idOperateur = lastClient.idOperateur + 1;
    } else {
      Operateur.idOperateur = 1;
    }
    idOperateurController.text = Operateur.idOperateur.toString();
  }

  Future<void> initializeBox() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(AddSimModelAdapter().typeId)) {
      Hive.registerAdapter(AddSimModelAdapter());
    }
    todobos5 = await Hive.openBox<AddSimModel>("todobos5");
    _initializeClientId();
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
 // print('UpdateClient called with: $idClient, $identite, $refCNIB, $numeroTelephone, $supprimer');
  if (idOperateur != null) Operateur.idOperateur = idOperateur;
  if (NumPhone != null) Operateur.NumPhone = NumPhone;
  if (LibOperateur != null) Operateur.LibOperateur = LibOperateur;
  if (CodeAgent != null) Operateur.CodeAgent = CodeAgent;
  //if (supprimer != null) client.supprimer = supprimer;
}


  Future<void> saveAddSimData() async {
    try {
      await todobos5.put(Operateur.idOperateur, Operateur);
      print("Enregistrement réussi : $Operateur");
    } catch (e) {
      print("Erreur lors de l'enregistrement : $e");
    }
  }

  Future<void> markAsDeleted(AddSimModel OpeSim) async {
    if (todobos5 != null) {
      //client.supprimer = 1;
      await todobos5.put(OpeSim.idOperateur, OpeSim).then((value) {
        print("Client marqué comme supprimé : $OpeSim");
      }).catchError((error) {
        print("Erreur lors de la mise à jour : $error");
      });
    }
  }


  // Méthode pour obtenir le CodeTransaction en fonction de l'Operateur et du TypeOperation
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
