import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive/hive.dart';
// Importation de tes modèles...
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/ClientModel.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';
import 'package:kadoustransfert/Model/OpTransactionModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:kadoustransfert/Model/UtilisateurModel.dart';

Future<void> importDataFromJson() async {
  try {
    // Demander les bonnes autorisations pour Android 11+ (API 30+)
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.request().isGranted ||
          await Permission.storage.request().isGranted) {
        print("Autorisations de stockage accordées");
      } else {
        print("Autorisations refusées");
        return;
      }
    }

    String sourceFilePath = '/storage/emulated/0/Download/data_export.json';
    File file = File(sourceFilePath);

    if (!await file.exists()) {
      print("Le fichier $sourceFilePath n'existe pas.");
      return;
    }

    final fileContent = await file.readAsString();
    final data = jsonDecode(fileContent);

    final box1 = await Hive.openBox<OrangeModel>('todobos');
    final box2 = await Hive.openBox<ClientModel>('todobos1');
    final box3 = await Hive.openBox<EntrepriseModel>('todobos2');
    final box4 = await Hive.openBox<OpTransactionModel>('todobos3');
    final box5 = await Hive.openBox<UtilisateurModel>('todobos4');
    final box6 = await Hive.openBox<AddSimModel>('todobos5');
    final box7 = await Hive.openBox<JournalCaisseModel>('todobos6');

    Future<void> insertBatch<T>(Box<T> box, List<T> list) async {
      for (var i = 0; i < list.length; i += 100) {
        final batch = list.sublist(i, (i + 100 > list.length) ? list.length : i + 100);
        await box.addAll(batch);
        await Future.delayed(Duration(milliseconds: 50));
      }
    }

    if (data.containsKey('todobos')) {
      final list = (data['todobos'] as List).map((e) => OrangeModel.fromJSON(e)).toList();
      await insertBatch(box1, list);
    }
    if (data.containsKey('todobos1')) {
      final list = (data['todobos1'] as List).map((e) => ClientModel.fromJSON(e)).toList();
      await insertBatch(box2, list);
    }
    if (data.containsKey('todobos2')) {
      final list = (data['todobos2'] as List).map((e) => EntrepriseModel.fromJSON(e)).toList();
      await insertBatch(box3, list);
    }
    if (data.containsKey('todobos3')) {
      final list = (data['todobos3'] as List).map((e) => OpTransactionModel.fromJSON(e)).toList();
      await insertBatch(box4, list);
    }
    if (data.containsKey('todobos4')) {
      final list = (data['todobos4'] as List).map((e) => UtilisateurModel.fromJSON(e)).toList();
      await insertBatch(box5, list);
    }
    if (data.containsKey('todobos5')) {
      final list = (data['todobos5'] as List).map((e) => AddSimModel.fromJSON(e)).toList();
      await insertBatch(box6, list);
    }
    if (data.containsKey('todobos6')) {
      final list = (data['todobos6'] as List).map((e) => JournalCaisseModel.fromJSON(e)).toList();
      await insertBatch(box7, list);
    }

    print('✅ Importation réussie !');
  } catch (e) {
    print('❌ Erreur lors de l\'importation : $e');
  }
}
