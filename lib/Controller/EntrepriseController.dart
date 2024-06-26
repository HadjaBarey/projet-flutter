import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';

class EntrepriseController {
  final formKey = GlobalKey<FormState>();
  late Box<EntrepriseModel> todobos2;

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

  EntrepriseController() {
    initializeBox();
  }

 void resetFormFields() {
  Entreprise = EntrepriseModel(
    idEntreprise: Entreprise.idEntreprise + 1,
    NomEntreprise: '', // Vous pouvez vider seulement ce champ si nécessaire
    DirecteurEntreprise: '', // Et laisser les autres tels qu'ils sont
    DateControle: '', // Si vous ne voulez pas les vider complètement
  );
 // idEntrepriseController.text = Entreprise.idEntreprise.toString();
}

  void pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      DateControleController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      updateEntreprise(DateControle: DateControleController.text);
    }
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
    todobos2 = await Hive.openBox<EntrepriseModel>("todobos2");
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
    if (DirecteurEntreprise != null)
      Entreprise.DirecteurEntreprise = DirecteurEntreprise;
    if (DateControle != null) Entreprise.DateControle = DateControle;
  }

  Future<void> saveEntrepriseData() async {
    try {
      await todobos2.put(Entreprise.idEntreprise, Entreprise);
      print("Enregistrement réussi : $Entreprise");
    } catch (e) {
      print("Erreur lors de l'enregistrement : $e");
    }
  }


  Future<void> markAsDeleted(EntrepriseModel entreprise) async {
    if (todobos2 != null) {
      await todobos2.put(entreprise.idEntreprise, entreprise).then((value) {
        print("Entreprise marquée comme supprimée : $entreprise");
      }).catchError((error) {
        print("Erreur lors de la mise à jour : $error");
      });
    }
  }

  Future<void> loadEntrepriseData(int idEntreprise) async {
  final entreprise = todobos2.get(idEntreprise);
  if (entreprise != null) {
    Entreprise = entreprise;
    idEntrepriseController.text = entreprise.idEntreprise.toString();
    NomEntrepriseController.text = entreprise.NomEntreprise;
    DirecteurEntrepriseController.text = entreprise.DirecteurEntreprise;
    DateControleController.text = entreprise.DateControle;
  }
}

Future<void> loadMostRecentEntrepriseData() async {
  if (todobos2.isNotEmpty) {
    final lastEntreprise = todobos2.values.last;
    await loadEntrepriseData(lastEntreprise.idEntreprise);
  }
}


}
