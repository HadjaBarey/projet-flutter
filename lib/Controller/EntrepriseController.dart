import 'dart:convert'; // ✅ pour jsonEncode, jsonDecode
import 'package:http/http.dart' as http; //

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';


class EntrepriseController {
  final formKey = GlobalKey<FormState>();
  late Box<EntrepriseModel> todobos2;
  String dateControleText = "";

  TextEditingController idEntrepriseController = TextEditingController();
  TextEditingController NomEntrepriseController = TextEditingController();
  TextEditingController DirecteurEntrepriseController = TextEditingController();
  TextEditingController DateControleController = TextEditingController();
  TextEditingController numeroTelEntrepriseController = TextEditingController();
  TextEditingController emailEntrepriseController = TextEditingController();

    // Variables licence (affichées en rouge)
    String? password;
    String? datefin;

  EntrepriseModel Entreprise = EntrepriseModel(
    idEntreprise: 1,
    NomEntreprise: '',
    DirecteurEntreprise: '',
    DateControle: '',
    numeroTelEntreprise:'',
    emailEntreprise:'',
  );

  EntrepriseController() {
    initializeBox();
  }

  void resetFormFields() {
    Entreprise = EntrepriseModel(
      idEntreprise: 1,
      NomEntreprise:  Entreprise.NomEntreprise,
      DirecteurEntreprise: Entreprise.DirecteurEntreprise,
      DateControle: Entreprise.DateControle,
      numeroTelEntreprise: Entreprise.numeroTelEntreprise,
      emailEntreprise: Entreprise.emailEntreprise,
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
  } else if (DateControleController.text.isEmpty) {
    DateControleController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  updateEntreprise(DateControle: DateControleController.text);
}


  Future<void> initializeBox() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(EntrepriseModelAdapter().typeId)) {
      Hive.registerAdapter(EntrepriseModelAdapter());
    }
    todobos2 = await Hive.openBox<EntrepriseModel>("todobos2");

    // Charger ou créer l'entreprise
 // await loadOrCreateEntreprise();

  if (DateControleController.text.isEmpty) {
    DateControleController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    updateEntreprise(DateControle: DateControleController.text);
  }
  // Charger l'entreprise existante ou en créer une nouvelle
  //  await loadOrCreateEntreprise();
  }



  Future<void> loadOrCreateEntreprise() async {
  if (todobos2.isEmpty) {
    // Ajouter une nouvelle entrée si la boîte est vide
    Entreprise = EntrepriseModel(
      idEntreprise: 1,
      NomEntreprise: '',
      DirecteurEntreprise: '',
      DateControle: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      numeroTelEntreprise:'',
      emailEntreprise:'',
    );
    await saveEntrepriseData(null);
  } else {
    // Si la boîte n'est pas vide, supprimer les anciennes données et ajouter la nouvelle entrée
    await deleteAllEntreprises();
    Entreprise = EntrepriseModel(
      idEntreprise: 1,
      NomEntreprise: '',
      DirecteurEntreprise: '',
      DateControle: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      numeroTelEntreprise:'',
      emailEntreprise:'',
    );
    await saveEntrepriseData(null);
  }
}

Future<void> deleteAllEntreprises() async {
  // Supprimer toutes les anciennes entrées de la boîte
  await todobos2.clear();
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
    String? numeroTelEntreprise,
    String? emailEntreprise,
  }) {
    if (idEntreprise != null) Entreprise.idEntreprise = idEntreprise;
    if (NomEntreprise != null) Entreprise.NomEntreprise = NomEntreprise;
    if (DirecteurEntreprise != null) Entreprise.DirecteurEntreprise = DirecteurEntreprise;
    if (DateControle != null) Entreprise.DateControle = DateControle;
    if (numeroTelEntreprise != null) Entreprise.numeroTelEntreprise = numeroTelEntreprise;
    if (emailEntreprise != null) Entreprise.emailEntreprise = emailEntreprise;
  }


Future<void> saveEntrepriseData(BuildContext? context) async {
  try {
    // Supprimer les données existantes si elles existent
    if (todobos2.containsKey(Entreprise.idEntreprise)) {
      await todobos2.delete(Entreprise.idEntreprise);
    }
    
    // Ajouter la nouvelle donnée
    await todobos2.put(Entreprise.idEntreprise, Entreprise);
    
    print("Enregistrement réussi : $Entreprise");
    
    if (context != null) {
      _showDialog(context, "Succès", "Enregistrement réussi !");
    }
  } catch (e) {
    print("Erreur lors de l'enregistrement : $e");
    
    if (context != null) {
      _showDialog(context, "Erreur", "Erreur lors de l'enregistrement");
    }
  }
}



  Future<void> markAsDeleted(EntrepriseModel entreprise) async {
    if (todobos2 != null) {
      await todobos2.put(entreprise.idEntreprise, entreprise).then((value) {
       // print("Entreprise marquée comme supprimée : $entreprise");
      }).catchError((error) {
       // print("Erreur lors de la mise à jour : $error");
      });
    }
  }

  String getDateControle() {
    return dateControleText;
  }


   void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
//---------------------------------------------------------------

  Future<void> RenitialisationOperateur() async {
  // Ouvrir les boîtes Hive
  var boxOperateurs = await Hive.openBox<AddSimModel>('todobos5');
  var boxJournal = await Hive.openBox<JournalCaisseModel>('todobos6');

  // Récupérer les opérateurs depuis Hive
  List<AddSimModel> operateursList = boxOperateurs.values.toList();

  // Parcourir les opérateurs
  for (AddSimModel operateur in operateursList) {
    String operateurKey = operateur.idOperateur.toString();

    // Parcourir les entrées de JournalCaisseModel
    for (int i = 0; i < boxJournal.length; i++) {
      JournalCaisseModel? journal = boxJournal.getAt(i);

      // Comparer idOperateur à operateur
      if (journal != null && journal.operateur == operateurKey) {
        // Affecter 0 à montantJ
        journal.montantJ = '0';
       // await boxJournal.putAt(i, journal); // Mettre à jour l'entrée dans Hive
      }
    }
  }

}

Future<void> loadEntrepriseData() async {
  var box = await Hive.openBox<EntrepriseModel>('todobos2');

  // Imprimer le contenu de la boîte pour débogage
 // print('Contenu de la boîte:');
  for (int i = 0; i < box.length; i++) {
   // print('Index $i: ${box.getAt(i)?.toJson()}');
  }

  if (box.isNotEmpty) {
    EntrepriseModel entreprise = box.getAt(0)!;
    idEntrepriseController.text = entreprise.idEntreprise.toString();
    NomEntrepriseController.text = entreprise.NomEntreprise;
    DirecteurEntrepriseController.text = entreprise.DirecteurEntreprise;
    DateControleController.text = entreprise.DateControle;
    numeroTelEntrepriseController.text = entreprise.numeroTelEntreprise;
    emailEntrepriseController.text = entreprise.emailEntreprise;
    // print("ID Entreprise11111: ${idEntrepriseController.text}");
    // print("Nom Entreprise11111: ${NomEntrepriseController.text}");
    // print("Directeur Entreprise11111: ${DirecteurEntrepriseController.text}");
    // print("Date Controle111111: ${DateControleController.text}");
  } else {
   // print("No data found in the box.");
  }
}





}
