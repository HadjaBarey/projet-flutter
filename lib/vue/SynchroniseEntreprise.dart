import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';

Future<void> saveDefaultEntrepriseModel() async {
  var box = await Hive.openBox<EntrepriseModel>('todobos2');

  String dateDuJour = DateFormat('dd/MM/yyyy').format(DateTime.now());

  // Si la boîte contient déjà des données, on les supprime toutes
  if (box.isNotEmpty) {
    await box.clear();
  }

  // Ensuite on enregistre la valeur par défaut
  EntrepriseModel defaultEntreprise = EntrepriseModel(
    idEntreprise: 1,
    NomEntreprise: 'KADOUS SOLUTIONS SARL',
    DirecteurEntreprise: 'OUEDRAOGO M.Kader',
    DateControle: dateDuJour,
    numeroTelEntreprise: "",
    emailEntreprise: "",
  );

  await box.put(1, defaultEntreprise);

  await box.close(); // Fermer la boîte proprement
}
