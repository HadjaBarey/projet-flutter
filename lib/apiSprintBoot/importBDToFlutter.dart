import 'dart:async'; 
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:kadoustransfert/Model/UsersKeyModel.dart';
import 'package:kadoustransfert/apiSprintBoot/connexionToken.dart';

final storage = FlutterSecureStorage();


// Fonction pour récupérer les données de Hive concernant la table userskey 
Future<UsersKeyModel?> getUserKeyFromHive() async {
  try {
    if (Hive.isBoxOpen('todobos7')) {
      await Hive.close();
    }
    Box<UsersKeyModel> box = await Hive.openBox<UsersKeyModel>('todobos7');
    if (box.isNotEmpty) {
      return box.values.first; // Récupérer la seule entrée
    }
  } catch (e) {
    print('Erreur Hive (todobos7) : $e');
  }
  return null;
}


Future<void> transfertDataToFlutter(BuildContext context, String selectedDate) async {
  //print("📦 Début du transfert des données...");

  // 0. Récupérer les données de usersKey (todobos7)
  UsersKeyModel? userskey = await getUserKeyFromHive();
  if (userskey == null) {
   // print('❌ Aucune entreprise trouvée dans usersKey.');
    return;
  }

  // 0bis. Récupérer le numéro aléatoire
  String numeroAleatoire = userskey.numeroaleatoire ?? "";
  if (numeroAleatoire.isEmpty) {
   // print("❌ Le numéro aléatoire est vide.");
    return;
  }

  try {
    // 1. Récupérer un token valide
    String? token = await getToken(context);
    if (token == null) {
     // print("❌ Impossible d'obtenir un token valide.");
      return;
    }

    // 2. Vérifier et formater la date
    if (selectedDate.isEmpty || selectedDate == "00000000") {
    //  print("❌ Date sélectionnée invalide.");
      return;
    }

    DateTime parsedDate;
    try {
      parsedDate = DateFormat('dd/MM/yyyy').parseStrict(selectedDate);
    } catch (e) {
     // print("❌ Erreur lors du parsing de la date : $e");
      return;
    }

    final normalizedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    //print("📅 Date normalisée : $normalizedDate");

    // 3. Ouvrir la boîte Hive 'todobos2' (Entreprise)
    Box<EntrepriseModel>? box2;
    try {
      if (!Hive.isBoxOpen('todobos2')) {
        box2 = await Hive.openBox<EntrepriseModel>('todobos2');
      } else {
        box2 = Hive.box<EntrepriseModel>('todobos2');
      }
    } catch (e) {
    //  print("🚨 Erreur lors de l'ouverture de 'todobos2' : $e");
      return;
    }

    // 4. Récupérer les infos entreprise

  // 🔁 Comparer avec la date dans EntrepriseModel
      String? dateEnregistrement = box2.getAt(0)?.DateControle;
      if (dateEnregistrement != null && dateEnregistrement.isNotEmpty) {
        try {
          DateTime dateSaisie = DateFormat('dd/MM/yyyy').parseStrict(selectedDate);
          DateTime dateEntreprise = DateFormat('dd/MM/yyyy').parseStrict(dateEnregistrement);

          if (!dateSaisie.isBefore(dateEntreprise)) {
            showAlertDialog(context, "❌ La date sélectionnée est égale ou postérieure à la date d’enregistrement de l’entreprise.");
            return;
          }
        } catch (e) {
         // print("❌ Erreur lors de la comparaison des dates : $e");
          showAlertDialog(context, "❌ Erreur de format de date.");
          return;
        }
      }

      // Remplacer les champs vides par %%
      String entrepriseNumero = box2.getAt(0)?.numeroTelEntreprise ?? "";
      String emailentreprise = box2.getAt(0)?.emailEntreprise ?? "";

      entrepriseNumero = entrepriseNumero.isEmpty ? '%%' : entrepriseNumero;
      emailentreprise = emailentreprise.isEmpty ? '%%' : emailentreprise;

      // print("📨 Numéro entreprise : $entrepriseNumero");
      // print("📧 Email entreprise : $emailentreprise");
      // print("🔐 Numéro aléatoire : $numeroAleatoire");


    // 5. Ouvrir la boîte Hive 'todobos' (OrangeModel)
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
  //  print("🗑️ ${itemsToDelete.length} transaction(s) supprimée(s) pour la date $normalizedDate");

    // 7. Construire l'URL de l'API
    final apiUrl = 'http://192.168.100.6:8081/transaction/v1/OperationTranslation/listTransaction';
   // Si les champs sont vides, on met %%
      entrepriseNumero = entrepriseNumero.isEmpty ? '%%' : entrepriseNumero;
      emailentreprise = emailentreprise.isEmpty ? '%%' : emailentreprise;
      final fullUrl = '$apiUrl'
      '?entrepriseNumero=${Uri.encodeComponent(entrepriseNumero)}'
      '&dateopera=$normalizedDate'
      '&emailEPR=${Uri.encodeComponent(emailentreprise)}'
      '&numalea=${Uri.encodeComponent(numeroAleatoire)}';


    print("🌐 URL appelée : $fullUrl");

    // 8. Requête HTTP
    final response = await secureHttpGet(
      context: context,
      url: fullUrl,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response != null) {
      print("✅ Status code reçu : ${response.statusCode}");
    }

    if (response != null && response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
     // print("📥 Réponse brute : $responseBody");

      List<dynamic> data = json.decode(responseBody);
      //print("📦 Nombre de données reçues : ${data.length}");

      if (data.isEmpty) {
        //print("⚠️ Aucune donnée à importer.");
        return;
      }

      for (var item in data) {
        try {
          OrangeModel transaction = OrangeModel.fromJSON(item);
          await box1.add(transaction);
          //print("✅ Transaction ajoutée : ${transaction.toString()}");
        } catch (e) {
          //print("❌ Erreur de parsing ou ajout Hive : $e");
        }
      }

     // print("🎉 Données importées avec succès !");
      //print("📦 Total dans la boîte 'todobos' : ${box1.length}");

    } else if (response != null) {
      showAlertDialog(context, "❌ Erreur serveur : ${response.statusCode}");
    }
  } catch (e) {
   // print("🚨 Erreur générale : $e");
    showAlertDialog(context, "❌ Une erreur interne est survenue.");
  }
}
