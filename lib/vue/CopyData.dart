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

      // Fonction générique pour supprimer les doublons
      Future<List<Map<String, dynamic>>> batchExport(Box box, String Function(Map<String, dynamic>) getKey) async {
        final items = box.values.toList();
        final uniqueMap = <String, Map<String, dynamic>>{};
        for (final item in items) {
          final json = item.toJson();
          final key = getKey(json);
          uniqueMap[key] = json; // Remplace les doublons
        }
        return uniqueMap.values.toList();
      }

      final data = {
        'todobos': await batchExport(boxOrangeModel, (json) => json['idoperation'].toString()),
        'todobos1': await batchExport(boxClient, (json) => json['idclient'].toString()),
        'todobos2': await batchExport(boxEntreprise, (json) => json['identte'].toString()),
        'todobos3': await batchExport(boxTransaction, (json) => json['idtrans'].toString()),
        'todobos4': await batchExport(boxUtilisateur, (json) => json['iduser'].toString()),
        'todobos5': await batchExport(boxAddSim, (json) => json['idOperateur'].toString()),
        'todobos6': await batchExport(boxJournalCaisse, (json) => json['idjournal'].toString()),
        'todobos7': await batchExport(boxUsersKeyModel, (json) => json['email'].toString()), // ou autre champ unique
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
