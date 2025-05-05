import 'dart:convert';
import 'dart:io';
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/ClientModel.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';
import 'package:kadoustransfert/Model/UsersKeyModel.dart';
import 'package:kadoustransfert/Model/UtilisateurModel.dart';
import 'package:kadoustransfert/Model/OpTransactionModel.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive/hive.dart';

Future<void> exportDataToJson() async {
  try {
    final storageStatus = await Permission.storage.request();
    final manageStorageStatus = await Permission.manageExternalStorage.request();

    if (storageStatus.isGranted && manageStorageStatus.isGranted) {
      final appDir = await getApplicationDocumentsDirectory();
      final tempFilePath = '${appDir.path}/data_export.json';
      final tempFile = File(tempFilePath);

      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      final boxOrangeModel = await Hive.openBox<OrangeModel>('todobos');
      final boxClient = await Hive.openBox<ClientModel>('todobos1');
      final boxEntreprise = await Hive.openBox<EntrepriseModel>('todobos2');
      final boxTransaction = await Hive.openBox<OpTransactionModel>('todobos3');
      final boxUtilisateur = await Hive.openBox<UtilisateurModel>('todobos4');
      final boxAddSim = await Hive.openBox<AddSimModel>('todobos5');
      final boxJournalCaisse = await Hive.openBox<JournalCaisseModel>('todobos6');
      final boxUsersKeyModel = await Hive.openBox<UsersKeyModel>('todobos7');

        Future<List<Map<String, dynamic>>> batchExport(box) async {
          List<Map<String, dynamic>> allData = [];
          final items = box.values.toList();
          for (int i = 0; i < items.length; i += 500) {
            final batch = items.sublist(i, (i + 500 > items.length) ? items.length : i + 500);
            allData.addAll(batch.map((e) => e.toJson()).cast<Map<String, dynamic>>());
            await Future.delayed(Duration(milliseconds: 50));
          }
          return allData;
        }

      final data = {
        'todobos': await batchExport(boxOrangeModel),
        'todobos1': await batchExport(boxClient),
        'todobos2': await batchExport(boxEntreprise),
        'todobos3': await batchExport(boxTransaction),
        'todobos4': await batchExport(boxUtilisateur),
        'todobos5': await batchExport(boxAddSim),
        'todobos6': await batchExport(boxJournalCaisse),
        'todobos7': await batchExport(boxUsersKeyModel),
      };

      await tempFile.writeAsString(jsonEncode(data));
      print('✅ Données exportées vers : $tempFilePath');

      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      final finalPath = '${downloadsDir.path}/data_export.json';
      await tempFile.copy(finalPath);

      print('✅ Fichier copié dans le dossier Téléchargements : $finalPath');
    } else {
      print('❌ Permissions de stockage refusées.');
    }
  } catch (e) {
    print('❌ Erreur lors de l\'exportation : $e');
  }
}
