// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:hive/hive.dart';
// //import 'package:share_plus/share_plus.dart';
// import 'package:kadoustransfert/Model/JournalCaisseModel.dart';
// import 'package:kadoustransfert/Model/AddSimModel.dart';
// import 'package:kadoustransfert/Model/ClientModel.dart';
// import 'package:kadoustransfert/Model/EntrepriseModel.dart';
// import 'package:kadoustransfert/Model/OpTransactionModel.dart';
// import 'package:kadoustransfert/Model/OrangeModel.dart';
// import 'package:kadoustransfert/Model/UtilisateurModel.dart';

// Future<void> exportDataToLocalStorage() async {
//   try {
//     // Fermer toutes les boîtes Hive ouvertes
//     await Hive.close();

//     // Récupérer le répertoire de stockage local
//     Directory? directory = await getExternalStorageDirectory();
//     if (directory == null) {
//       print('Erreur: Impossible de récupérer le répertoire de stockage externe.');
//       return;
//     }

//     File file = File('${directory.path}/data_export.json');

//     // Ouvrir toutes les boîtes Hive nécessaires
//     var todobosBox = await Hive.openBox<OrangeModel>('todobos');
//     var todobos1Box = await Hive.openBox<ClientModel>('todobos1');
//     var todobos2Box = await Hive.openBox<EntrepriseModel>('todobos2');
//     var todobos3Box = await Hive.openBox<OpTransactionModel>('todobos3');
//     var todobos4Box = await Hive.openBox<UtilisateurModel>('todobos4');
//     var todobos5Box = await Hive.openBox<AddSimModel>('todobos5');
//     var todobos6Box = await Hive.openBox<JournalCaisseModel>('todobos6');

//     // Créer une map pour stocker toutes les données
//     Map<String, dynamic> allData = {};

//     // Récupérer les données depuis les boîtes Hive
//     allData['todobos'] = todobosBox.values.map((e) => e.toJson()).toList();
//     allData['todobos1'] = todobos1Box.values.map((e) => e.toJson()).toList();
//     allData['todobos2'] = todobos2Box.values.map((e) => e.toJson()).toList();
//     allData['todobos3'] = todobos3Box.values.map((e) => e.toJson()).toList();
//     allData['todobos4'] = todobos4Box.values.map((e) => e.toJson()).toList();
//     allData['todobos5'] = todobos5Box.values.map((e) => e.toJson()).toList();
//     allData['todobos6'] = todobos6Box.values.map((e) => e.toJson()).toList();

//     // Convertir les données en JSON
//     String jsonData = jsonEncode(allData);

//     // Écrire les données dans le fichier
//     await file.writeAsString(jsonData);

//     // Vérification et partage
//     bool fileExists = await file.exists();
//     if (fileExists) {
//       print('Données exportées avec succès dans ${file.path}');
//      // await Share.shareFiles([file.path], text: 'Voici les données exportées.');
//     } else {
//       print('Échec de l\'exportation des données.');
//     }

//     // Réouvrir les boîtes Hive après l'exportation
//     await Hive.openBox<OrangeModel>('todobos');
//     await Hive.openBox<ClientModel>('todobos1');
//     await Hive.openBox<EntrepriseModel>('todobos2');
//     await Hive.openBox<OpTransactionModel>('todobos3');
//     await Hive.openBox<UtilisateurModel>('todobos4');
//     await Hive.openBox<AddSimModel>('todobos5');
//     await Hive.openBox<JournalCaisseModel>('todobos6');

//     print('Boîtes Hive rechargées avec les dernières données.');
//   } catch (e) {
//     print('Erreur lors de l\'exportation et du partage des données : $e');
//   }
// }
