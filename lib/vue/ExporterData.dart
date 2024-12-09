import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';  // Pour gérer les horodatages

Future<void> exportDataToWhatsapp() async {
  try {
    await Hive.close();

    // Récupérer le répertoire Documents ou Téléchargements
    Directory? directory = await getExternalStorageDirectory(); // Remplace par getApplicationDocumentsDirectory si nécessaire
    if (directory == null) {
      print('Erreur: Impossible de récupérer le répertoire.');
      return;
    }

    String folderPath = '${directory.path}/WhatsApp_Backup';
    Directory exportDirectory = Directory(folderPath);

    // Crée le répertoire s'il n'existe pas
    if (!(await exportDirectory.exists())) {
      await exportDirectory.create(recursive: true);
    }

    // Nom unique pour le fichier JSON basé sur l'horodatage
    String fileName = 'data_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json';
    File file = File('$folderPath/$fileName');

    // Exportation des données (exemple simplifié)
    Map<String, dynamic> allData = {
      'todobos': [],  // Remplace par tes vraies données Hive
      'todobos1': [],
    };

    String jsonData = jsonEncode(allData);
    await file.writeAsString(jsonData);

    if (await file.exists()) {
      print('Données exportées avec succès dans ${file.path}');
    } else {
      print('Échec de l\'exportation des données.');
    }

    // Réouvrir les boîtes Hive si nécessaire
    await Hive.openBox('todobos');
    print('Boîtes Hive rechargées avec succès.');
  } catch (e) {
    print('Erreur lors de l\'exportation : $e');
  }
}
