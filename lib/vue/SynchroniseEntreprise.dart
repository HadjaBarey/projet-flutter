import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';

Future<void> saveDefaultEntrepriseModel() async {
  var box = await Hive.openBox<EntrepriseModel>('todobos2');
  String dateDuJour = DateFormat('dd/MM/yyyy').format(DateTime.now());

  if (box.isEmpty) {
    // Première exécution : insérer la valeur par défaut
    EntrepriseModel defaultEntreprise = EntrepriseModel(
      idEntreprise: 1,
      NomEntreprise: 'KADOUS SOLUTIONS SARL',
      DirecteurEntreprise: 'OUEDRAOGO M.Kader',
      DateControle: dateDuJour,
      numeroTelEntreprise: "",
      emailEntreprise: "",
    );

    await box.put(1, defaultEntreprise);
  } else {
    // Trouver la donnée avec la DateControle la plus récente
    EntrepriseModel mostRecent = box.values.first;

    for (var entreprise in box.values) {
      DateTime currentDate = DateFormat('dd/MM/yyyy').parse(entreprise.DateControle);
      DateTime mostRecentDate = DateFormat('dd/MM/yyyy').parse(mostRecent.DateControle);

      if (currentDate.isAfter(mostRecentDate)) {
        mostRecent = entreprise;
      }
    }

    await box.clear(); // Supprimer tout
    await box.put(1, mostRecent); // Réinsérer uniquement la plus récente
  }

  await box.close();
}


//A activer  la fin -------------------------------------------------------------------------------------------------------
// // Fonction pour sauvegarder le modèle d'entreprise par défaut avec une date spécifique

// Future<void> saveDefaultEntrepriseModel(DateTime dateDeb) async {
//   var box = await Hive.openBox<EntrepriseModel>('todobos2');
//   String dateDuJour = DateFormat('dd/MM/yyyy').format(dateDeb); // utilise la date passée

//   if (box.isEmpty) {
//     EntrepriseModel defaultEntreprise = EntrepriseModel(
//       idEntreprise: 1,
//       NomEntreprise: 'KADOUS SOLUTIONS SARL',
//       DirecteurEntreprise: 'OUEDRAOGO M.Kader',
//       DateControle: dateDuJour,
//       numeroTelEntreprise: "",
//       emailEntreprise: "",
//     );

//     await box.put(1, defaultEntreprise);
//   } else {
//     EntrepriseModel mostRecent = box.values.first;

//     for (var entreprise in box.values) {
//       DateTime currentDate = DateFormat('dd/MM/yyyy').parse(entreprise.DateControle);
//       DateTime mostRecentDate = DateFormat('dd/MM/yyyy').parse(mostRecent.DateControle);

//       if (currentDate.isAfter(mostRecentDate)) {
//         mostRecent = entreprise;
//       }
//     }

//     await box.clear();
//     await box.put(1, mostRecent);
//   }

//   await box.close();
// }
