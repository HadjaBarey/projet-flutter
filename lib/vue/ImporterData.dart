import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/ClientModel.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';
import 'package:kadoustransfert/Model/OpTransactionModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:kadoustransfert/Model/UtilisateurModel.dart';
import 'package:hive/hive.dart';

Future<void> importDataFromJson() async {
  try {
    // Demander les autorisations de stockage
    if (await Permission.storage.request().isGranted) {
      // Chemin complet du fichier JSON dans le dossier Download
      String sourceFilePath = '/storage/emulated/0/Download/data_export.json';
      print('Chemin du fichier : $sourceFilePath');

      // Vérifier si le fichier source existe
      File file = File(sourceFilePath);
      if (!(await file.exists())) {
        print('Le fichier source $sourceFilePath n\'existe pas.');
        return;
      }

      // Lire le contenu du fichier
      final fileContent = await file.readAsString();
      print('Contenu du fichier JSON : $fileContent');

      final data = jsonDecode(fileContent);

      // Vérifier le contenu des données JSON
      print('Contenu des données JSON : $data');

      final box1 = await Hive.openBox<OrangeModel>('todobos');
      final box2 = await Hive.openBox<ClientModel>('todobos1');
      final box3 = await Hive.openBox<EntrepriseModel>('todobos2');
      final box4 = await Hive.openBox<OpTransactionModel>('todobos3');
      final box5 = await Hive.openBox<UtilisateurModel>('todobos4');
      final box6 = await Hive.openBox<AddSimModel>('todobos5');
      final box7 = await Hive.openBox<JournalCaisseModel>('todobos6');

      if (data.containsKey('todobos')) {
        for (var item in data['todobos']) {
          var orangeModel = OrangeModel.fromJSON(item);
          print('Ajout dans OrangeModel : $orangeModel');
          await box1.add(orangeModel);
        }
      }
      if (data.containsKey('todobos1')) {
        for (var item in data['todobos1']) {
          var clientModel = ClientModel.fromJSON(item);
          print('Ajout dans ClientModel : $clientModel');
          await box2.add(clientModel);
        }
      }
      if (data.containsKey('todobos2')) {
        for (var item in data['todobos2']) {
          var entrepriseModel = EntrepriseModel.fromJSON(item);
          print('Ajout dans EntrepriseModel : $entrepriseModel');
          await box3.add(entrepriseModel);
        }
      }
      if (data.containsKey('todobos3')) {
        for (var item in data['todobos3']) {
          var opTransactionModel = OpTransactionModel.fromJSON(item);
          print('Ajout dans OpTransactionModel : $opTransactionModel');
          await box4.add(opTransactionModel);
        }
      }
      if (data.containsKey('todobos4')) {
        for (var item in data['todobos4']) {
          var utilisateurModel = UtilisateurModel.fromJSON(item);
          print('Ajout dans UtilisateurModel : $utilisateurModel');
          await box5.add(utilisateurModel);
        }
      }
      if (data.containsKey('todobos5')) {
        for (var item in data['todobos5']) {
          var addSimModel = AddSimModel.fromJSON(item);
          print('Ajout dans AddSimModel : $addSimModel');
          await box6.add(addSimModel);
        }
      }
      if (data.containsKey('todobos6')) {
        for (var item in data['todobos6']) {
          var journalCaisseModel = JournalCaisseModel.fromJSON(item);
          print('Ajout dans JournalCaisseModel : $journalCaisseModel');
          await box7.add(journalCaisseModel);
        }
      }

      print('Importation des données réussie');
    } else {
      print('Les autorisations de stockage ont été refusées.');
    }
  } catch (e) {
    print('Erreur lors de l\'importation des données : $e');
  }
}
