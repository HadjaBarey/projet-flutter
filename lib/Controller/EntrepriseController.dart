import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';


class EntrepriseController {
  final formKey = GlobalKey<FormState>();
  late Box<EntrepriseModel> todobos2;

  EntrepriseController() {
    initializeBox();
  }

  TextEditingController idEntrepriseController = TextEditingController();
  TextEditingController NomEntrepriseController = TextEditingController();
  TextEditingController DirecteurEntrepriseController = TextEditingController();
  TextEditingController DateControleController = TextEditingController();


  EntrepriseModel Entreprise = EntrepriseModel(
    idEntreprise: 0,
    NomEntreprise: '',
    DirecteurEntreprise: '',
    DateControle: '',
  );

  void resetFormFields() {
    Entreprise = EntrepriseModel(
      idEntreprise: Entreprise.idEntreprise + 1,
      NomEntreprise: '',
      DirecteurEntreprise: '',
      DateControle: '',
    );
    idEntrepriseController.text = Entreprise.idEntreprise.toString();
    NomEntrepriseController.clear();
    DirecteurEntrepriseController.clear();
    DateControleController.clear();
  }

  void _initializeEntrepriseId() {
    if (todobos2.isNotEmpty) {
      final sortedEntreprise = todobos2.values.toList()
        ..sort((a, b) => a.idEntreprise.compareTo(b.idEntreprise));
      final lastEntreprise = sortedEntreprise.last;
      Entreprise.idEntreprise = lastEntreprise.idEntreprise + 1;
    } else {
      Entreprise.idEntreprise = 1;
    }
    idEntrepriseController.text = Entreprise.idEntreprise.toString();
  }

  Future<void> initializeBox() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(EntrepriseModelAdapter().typeId)) {
      Hive.registerAdapter(EntrepriseModelAdapter());
    }
    todobos2 = await Hive.openBox<EntrepriseModel>("todobos1");
    _initializeEntrepriseId();
  }

  Future<List<EntrepriseModel>> loadData() async {
    if (todobos2.isEmpty) {
      return [];
    }
    return todobos2.values.toList();
  }

void updateEntreprise({
  int? idEntreprise,
  String? NomEntreprise,
  String? DirecteurEntreprise,
  String? DateControle,
}) {
  if (idEntreprise != null) Entreprise.idEntreprise = idEntreprise;
  if (NomEntreprise != null) Entreprise.NomEntreprise = NomEntreprise;
  if (DirecteurEntreprise != null) Entreprise.DirecteurEntreprise = DirecteurEntreprise;
  if (DateControle != null) Entreprise.DateControle = DateControle;
  //if (supprimer != null) client.supprimer = supprimer;
}


  Future<void> saveEntrepriseData() async {
    try {
      await todobos2.put(Entreprise.idEntreprise, Entreprise);
      print("Enregistrement réussi : $Entreprise");
    } catch (e) {
      print("Erreur lors de l'enregistrement : $e");
    }
  }

  Future<void> markAsDeleted(EntrepriseModel Entreprise) async {
    if (todobos2 != null) {
      //client.supprimer = 1;
      await todobos2.put(Entreprise.idEntreprise, Entreprise).then((value) {
        print("Client marqué comme supprimé : $Entreprise");
      }).catchError((error) {
        print("Erreur lors de la mise à jour : $error");
      });
    }
  }
}
