import 'dart:convert';
import 'dart:io';
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/ClientModel.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';
import 'package:kadoustransfert/Model/UtilisateurModel.dart';
import 'package:kadoustransfert/Model/OpTransactionModel.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive/hive.dart';

Future<void> exportDataToJson() async {
  try {
    // Demander les permissions de stockage et de gestion du stockage
    final storageStatus = await Permission.storage.request();
    final manageStorageStatus = await Permission.manageExternalStorage.request();

    if (storageStatus.isGranted && manageStorageStatus.isGranted) {
      // Supprimer le fichier existant (optionnel)
      final appDir = await getApplicationDocumentsDirectory();
      final sourceFile = File('${appDir.path}/data_export.json');
      if (await sourceFile.exists()) {
        await sourceFile.delete();
      }

      // Ouvrir les boîtes Hive
      final boxOrangeModel = await Hive.openBox<OrangeModel>('todobos');
      final boxClient = await Hive.openBox<ClientModel>('todobos1');
      final boxEntreprise = await Hive.openBox<EntrepriseModel>('todobos2');
      final boxTransaction = await Hive.openBox<OpTransactionModel>('todobos3');
      final boxUtilisateur = await Hive.openBox<UtilisateurModel>('todobos4');
      final boxAddSim = await Hive.openBox<AddSimModel>('todobos5');
      final boxJournalCaisse = await Hive.openBox<JournalCaisseModel>('todobos6');

      // Transformer les données en JSON
      final data = {
        'todobos': boxOrangeModel.values.map((e) => e.toJson()).toList(),
        'todobos1': boxClient.values.map((e) => e.toJson()).toList(),
        'todobos2': boxEntreprise.values.map((e) => e.toJson()).toList(),
        'todobos3': boxTransaction.values.map((e) => e.toJson()).toList(),
        'todobos4': boxUtilisateur.values.map((e) => e.toJson()).toList(),
        'todobos5': boxAddSim.values.map((e) => e.toJson()).toList(),
        'todobos6': boxJournalCaisse.values.map((e) => e.toJson()).toList(),
      };

      // Créer et écrire le fichier dans le répertoire de l'app
      final newSourceFile = File('${appDir.path}/data_export.json');
      await newSourceFile.writeAsString(jsonEncode(data));
      print('✅ Données exportées vers : ${newSourceFile.path}');

      // Copier le fichier vers le répertoire Téléchargements
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      final destinationFilePath = '${downloadsDir.path}/data_export.json';
      await newSourceFile.copy(destinationFilePath);

      print('✅ Fichier copié dans le dossier Téléchargements : $destinationFilePath');
    } else {
      print('❌ Permissions de stockage refusées. Impossible d\'exporter les données.');
    }
  } catch (e) {
    print('❌ Erreur lors de l\'exportation des données : $e');
  }
}
