import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';

Future<void> saveDefaultEntrepriseModel() async {
  var box = await Hive.openBox<EntrepriseModel>('todobos2');

  String dateDuJour = DateFormat('dd/MM/yyyy').format(DateTime.now());

  // Vérifie si l'élément avec la clé 1 existe déjà
  if (!box.containsKey(1)) {
    EntrepriseModel defaultEntreprise = EntrepriseModel(
      idEntreprise: 1,
      NomEntreprise: 'KADOUS SOLUTIONS SARL',
      DirecteurEntreprise: 'OUEDRAOGO M.Kader',
      DateControle: dateDuJour,
      numeroTelEntreprise: "",
      emailEntreprise: "",
    );

    await box.put(1, defaultEntreprise);
   // print('Valeur par défaut enregistrée avec succès.');
  } else {
    //print('Les données existent déjà, pas besoin de les enregistrer.');
  }

  await box.close(); // Ferme la boîte pour s'assurer que les données sont écrites
}
