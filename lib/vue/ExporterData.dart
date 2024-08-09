import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/ClientModel.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/OpTransactionModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:kadoustransfert/Model/UtilisateurModel.dart';

Future<void> exportDataToLocalStorage() async {
  try {
    // Fermer toutes les boîtes Hive ouvertes
    await Hive.close();

    // Récupérer le répertoire de stockage local
    Directory? directory = await getExternalStorageDirectory();
    if (directory == null) {
      print('Erreur: Impossible de récupérer le répertoire de stockage externe.');
      return;
    }

    File file = File('${directory.path}/data_export.json');

    // Ouvrir toutes les boîtes Hive nécessaires
    var todobosBox = await Hive.openBox<OrangeModel>('todobos');
    var todobos1Box = await Hive.openBox<ClientModel>('todobos1');
    var todobos2Box = await Hive.openBox<EntrepriseModel>('todobos2');
    var todobos3Box = await Hive.openBox<OpTransactionModel>('todobos3');
    var todobos4Box = await Hive.openBox<UtilisateurModel>('todobos4');
    var todobos5Box = await Hive.openBox<AddSimModel>('todobos5');
    var todobos6Box = await Hive.openBox<JournalCaisseModel>('todobos6');

    // Créer une map pour stocker toutes les données
    Map<String, dynamic> allData = {};

    // Récupérer les données depuis les boîtes Hive
    List<OrangeModel> todobos = todobosBox.values.toList();
    List<ClientModel> todobos1 = todobos1Box.values.toList();
    List<EntrepriseModel> todobos2 = todobos2Box.values.toList();
    List<OpTransactionModel> todobos3 = todobos3Box.values.toList();
    List<UtilisateurModel> todobos4 = todobos4Box.values.toList();
    List<AddSimModel> todobos5 = todobos5Box.values.toList();
    List<JournalCaisseModel> todobos6 = todobos6Box.values.toList();

    // Déboguer les longueurs et les premiers éléments
    print('Nombre de données dans todobos: ${todobos.length}');
    if (todobos.isNotEmpty) print('Premier élément de todobos: ${todobos.first.toJson()}');

    print('Nombre de données dans todobos1: ${todobos1.length}');
    if (todobos1.isNotEmpty) print('Premier élément de todobos1: ${todobos1.first.toJson()}');

    print('Nombre de données dans todobos2: ${todobos2.length}');
    if (todobos2.isNotEmpty) print('Premier élément de todobos2: ${todobos2.first.toJson()}');

    print('Nombre de données dans todobos3: ${todobos3.length}');
    if (todobos3.isNotEmpty) print('Premier élément de todobos3: ${todobos3.first.toJson()}');

    print('Nombre de données dans todobos4: ${todobos4.length}');
    if (todobos4.isNotEmpty) print('Premier élément de todobos4: ${todobos4.first.toJson()}');

    print('Nombre de données dans todobos5: ${todobos5.length}');
    if (todobos5.isNotEmpty) print('Premier élément de todobos5: ${todobos5.first.toJson()}');
    else print('Aucune donnée dans todobos5.');

    print('Nombre de données dans todobos6: ${todobos6.length}');
    if (todobos6.isNotEmpty) print('Premier élément de todobos6: ${todobos6.first.toJson()}');

    // Ajouter les données à la map
    try {
      allData['todobos'] = todobos.map((e) => e.toJson()).toList();
      allData['todobos1'] = todobos1.map((e) => e.toJson()).toList();
      allData['todobos2'] = todobos2.map((e) => e.toJson()).toList();
      allData['todobos3'] = todobos3.map((e) => e.toJson()).toList();
      allData['todobos4'] = todobos4.map((e) => e.toJson()).toList();
      allData['todobos5'] = todobos5.map((e) => e.toJson()).toList();
      allData['todobos6'] = todobos6.map((e) => e.toJson()).toList();
    } catch (e) {
      print('Erreur lors de la conversion des données en JSON: $e');
      return;
    }

    // Convertir les données en JSON
    String jsonData = jsonEncode(allData);

    // Écrire les données dans le fichier
    await file.writeAsString(jsonData);

    // Vérifier si l'écriture a réussi
    bool fileExists = await file.exists();
    if (fileExists) {
      print('Données exportées avec succès dans ${file.path}');
    } else {
      print('Échec de l\'exportation des données.');
    }

    // Réouvrir les boîtes Hive après l'exportation
    await Hive.openBox<OrangeModel>('todobos');
    await Hive.openBox<ClientModel>('todobos1');
    await Hive.openBox<EntrepriseModel>('todobos2');
    await Hive.openBox<OpTransactionModel>('todobos3');
    await Hive.openBox<UtilisateurModel>('todobos4');
    await Hive.openBox<AddSimModel>('todobos5');
    await Hive.openBox<JournalCaisseModel>('todobos6');

    print('Boîtes Hive rechargées avec les dernières données.');
  } catch (e) {
    print('Erreur lors de l\'exportation et du rechargement des données : $e');
  }
}
