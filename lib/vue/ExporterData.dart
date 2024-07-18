import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

    // Récupérer les données depuis les différentes boîtes Hive
    var todobosBox = await Hive.openBox<OrangeModel>('todobos');
    var todobos1Box = await Hive.openBox<ClientModel>('todobos1');
    var todobos2Box = await Hive.openBox<EntrepriseModel>('todobos2');
    var todobos3Box = await Hive.openBox<OpTransactionModel>('todobos3');
    var todobos4Box = await Hive.openBox<UtilisateurModel>('todobos4');
    var todobos5Box = await Hive.openBox<AddSimModel>('todobos5');

    // Créer une map pour stocker toutes les données
    Map<String, dynamic> allData = {
      'todobos': todobosBox.values.toList(),
      'todobos1': todobos1Box.values.toList(),
      'todobos2': todobos2Box.values.toList(),
      'todobos3': todobos3Box.values.toList(),
      'todobos4': todobos4Box.values.toList(),
      'todobos5': todobos5Box.values.toList(),
    };

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
      return;
    }

    // Réouvrir les boîtes Hive après l'exportation
    await Hive.openBox<OrangeModel>('todobos');
    await Hive.openBox<ClientModel>('todobos1');
    await Hive.openBox<EntrepriseModel>('todobos2');
    await Hive.openBox<OpTransactionModel>('todobos3');
    await Hive.openBox<UtilisateurModel>('todobos4');
    await Hive.openBox<AddSimModel>('todobos5');

    print('Boîtes Hive rechargées avec les dernières données.');
  } catch (e) {
    print('Erreur lors de l\'exportation et du rechargement des données : $e');
  }
}
