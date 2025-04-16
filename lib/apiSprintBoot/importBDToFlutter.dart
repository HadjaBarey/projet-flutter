import 'dart:io'; // Pour SocketException
import 'dart:async'; // Pour TimeoutException
import 'package:hive/hive.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:kadoustransfert/apiSprintBoot/connexionToken.dart';

final storage = FlutterSecureStorage();


Future<void> transfertDataToFlutter(BuildContext context, String selectedDate) async {
  
    try {
      // 1. Récupérer un token valide
      String? token = await getToken(context);
      if (token == null) {
       // print("❌ Impossible d'obtenir un token valide.");
        return;
      }

      // 2. Vérifier et formater la date
      if (selectedDate.isEmpty || selectedDate == "00000000") 
      return;

      DateTime parsedDate;
      try {
        parsedDate = DateFormat('dd/MM/yyyy').parseStrict(selectedDate);
      } catch (_) {
        return;
      }

      final normalizedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

      // 3. Ouvrir la boîte Hive 'todobos2'
      Box<EntrepriseModel>? box2;
      try {
        if (!Hive.isBoxOpen('todobos2')) {
          box2 = await Hive.openBox<EntrepriseModel>('todobos2');
        } else {
          box2 = Hive.box<EntrepriseModel>('todobos2');
        }
      } catch (e) {
        print("🚨 Erreur lors de l'ouverture de 'todobos2' : $e");
        return;
      }

      // 4. Récupérer le numéro de téléphone et le mot de passe( emailentreprise )
      String entrepriseNumero = box2.getAt(0)?.numeroTelEntreprise ?? "";
      if (entrepriseNumero.isEmpty) return;

      String emailentreprise = box2.getAt(0)?.emailEntreprise ?? "";
      if (emailentreprise.isEmpty) return;



      // 5. Ouvrir la boîte 'todobos'
      Box<OrangeModel>? box1;
      try {
        if (!Hive.isBoxOpen('todobos')) {
          box1 = await Hive.openBox<OrangeModel>('todobos');
        } else {
          box1 = Hive.box<OrangeModel>('todobos');
        }
      } catch (e) {
        print("🚨 La boîte 'todobos' n'a pas pu être ouverte : $e");
        return;
      }

      // 6. Supprimer les transactions existantes pour cette date
      final itemsToDelete = box1.values.where((item) => item.dateoperation == normalizedDate).toList();
      for (var item in itemsToDelete) {
        int key = box1.keyAt(box1.values.toList().indexOf(item));
        await box1.delete(key);
      }

      // 7. Construire l'URL
      final apiUrl = 'http://192.168.100.6:8081/transaction/v1/OperationTranslation/listTransaction';
      final fullUrl = '$apiUrl?entrepriseNumero=$entrepriseNumero&dateopera=$normalizedDate&emailEPR=$emailentreprise';

      // 8. Requête HTTP
     final response = await secureHttpGet(
      context: context,
      url: fullUrl,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response != null && response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(responseBody);
      if (data.isEmpty) return;

      for (var item in data) {
        OrangeModel transaction = OrangeModel.fromJSON(item);
        await box1.add(transaction);
      }
    } else if (response != null) {
      showAlertDialog(context, "❌ Erreur serveur : ${response.statusCode}");
    }
  } catch (e) {
    print("🚨 Erreur générale : $e");
    showAlertDialog(context, "❌ Une erreur interne est survenue.");
  }
}

