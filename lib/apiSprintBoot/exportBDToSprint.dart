import 'dart:async'; // Pour TimeoutException
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'connexionToken.dart';

final storage = FlutterSecureStorage();

//Fonction qui permettrons de recuperer les données de mes 2 tables maitresses pour pouvoir combiner mes données pour les cibler dans mes enregistrements

// Fonction pour récupérer les données de Hive concernant la table principal 
Future<List<OrangeModel>> getDataFromHive() async {
  try {
    if (Hive.isBoxOpen('todobos')) {
      await Hive.close();
    }
    Box<OrangeModel> box = await Hive.openBox<OrangeModel>('todobos');
    return box.values.toList();
  } catch (e) {
    print('Erreur Hive : $e');
    return [];
  }
}

// Fonction pour récupérer les données de Hive concernant la table Entreprinse 
Future<EntrepriseModel?> getEntrepriseFromHive() async {
  try {
    if (Hive.isBoxOpen('todobos2')) {
      await Hive.close();
    }
    Box<EntrepriseModel> box = await Hive.openBox<EntrepriseModel>('todobos2');
    if (box.isNotEmpty) {
      return box.values.first; // Récupérer la seule entrée
    }
  } catch (e) {
    print('Erreur Hive (todobos2) : $e');
  }
  return null;
}

//Fin Fonction qui permettrons de recuperer les données de mes 2 tables maitresses pour pouvoir combiner mes données pour les cibler dans mes enregistrements



// Fonction qui envoie chaque opération individuellement au format attendu par l'API
Future<void> transfertDataToSpringBoot(List<OrangeModel> operations, String dateFiltre, BuildContext context) async { 
  try {

     // Vérifie la connexion Internet avant tout
    if (!await isConnectedToInternet()) {
      print("🚫 Aucune connexion Internet, transfert annulé.");
      return;
    }


    if (operations.isEmpty) {
      print('❌ Aucune donnée à envoyer.');
      return;
    }

    // Récupérer les données de l'entreprise
    EntrepriseModel? entreprise = await getEntrepriseFromHive();
    if (entreprise == null) {
      print('❌ Aucune entreprise trouvée.');
      return;
    }

    String? token = await getToken(context);
    if (token == null) {
      print('❌ Impossible d\'obtenir un token valide.');
      return;
    }

    print('🔍 Vérification du token : $token');

    // Supprimer les données existantes sur Spring Boot via l'API
    String deleteApiUrl = 'http://192.168.100.6:8081/transaction/v1/OperationTranslation/supprimer';
    try {
      final deleteResponse = await http.delete(
        Uri.parse('$deleteApiUrl?telEntreprise=${entreprise.numeroTelEntreprise}&dateOp=$dateFiltre&emailEP=${entreprise.emailEntreprise}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 15));

      if (deleteResponse.statusCode == 200) {
        print("🗑️ Données supprimées avec succès pour le numéro : ${entreprise.numeroTelEntreprise} et le mot de passe ${entreprise.emailEntreprise} à la date : $dateFiltre");
      } else {
        print('❌ Échec de la suppression: ${deleteResponse.statusCode} - ${deleteResponse.body}');
        return;
      }
    } catch (e) {
      print('🚨 Erreur lors de la suppression des données : $e');
      return;
    }

    String apiUrl = 'http://192.168.100.6:8081/transaction/v1/OperationTranslation/create';

    // Filtrer les opérations en fonction de la date saisie
    List<OrangeModel> operationsFiltrees = operations.where((operation) => operation.dateoperation == dateFiltre).toList();

    if (operationsFiltrees.isEmpty) {
      print('📆 Aucune opération trouvée pour la date $dateFiltre.');
      return;
    }

    int successCount = 0;
    int failCount = 0;

    // Traiter chaque opération individuellement
    for (OrangeModel operation in operationsFiltrees) {
      final Map<String, dynamic> operationJson = {
        "codeoperation": operation.idoperation.toString(),
        "idoperation": operation.idoperation,
        "dateoperation": operation.dateoperation,
        "montant": operation.montant,
        "numeroTelephone": operation.numero_telephone?.trim(),
        "infoClient": operation.info_client,
        "typeOperation": operation.typeoperation ?? 0,
        "operateur": operation.operateur,
        "supprimer": operation.supprimer ?? 0,
        "iddette": operation.iddette ?? 0,
        "optionCreance": operation.optionCreance ?? false,
        "scanMessage": operation.scanmessage,
        "numeroIndependant": operation.numeroIndependant?.trim() ?? "",
        "idTrans": operation.idtrans,
        "created_at": "",
        "updated_at": "",
        "numeroTelEntreprise": entreprise.numeroTelEntreprise,
        "emailentreprise": entreprise.emailEntreprise
      };

      final jsonPayload = json.encode(operationJson);
      print('📦 Envoi de l\'opération: $jsonPayload');

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonPayload,
        ).timeout(Duration(seconds: 15));

        if (response.statusCode == 200) {
          print('✅ Opération envoyée avec succès: ${operation.idtrans}');
          successCount++;
        } else if (response.statusCode == 400) {
          print('❌ Erreur de format de données (400): ${response.body}');
          failCount++;
        } else if (await handleAuthError(response,context)) {
          String? newToken = await getToken(context);
          if (newToken != null) {
            final retryResponse = await http.post(
              Uri.parse(apiUrl),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $newToken',
              },
              body: jsonPayload,
            ).timeout(Duration(seconds: 15));

            if (retryResponse.statusCode == 200) {
              print('✅ Opération envoyée avec succès après renouvellement: ${operation.idtrans}');
              successCount++;
            } else {
              print('❌ Échec persistant: ${retryResponse.statusCode} - ${retryResponse.body}');
              failCount++;
            }
          } else {
            failCount++;
          }
        } else {
          print('❌ Erreur HTTP ${response.statusCode} : ${response.body}');
          failCount++;
        }
      } catch (e) {
        print('🚨 Erreur lors de l\'envoi de l\'opération ${operation.idtrans}: $e');
        failCount++;
      }
    }

    print('📊 Résumé du transfert: $successCount réussites, $failCount échecs sur ${operationsFiltrees.length} opérations');

  } catch (e) {
    print('🚨 Erreur générale lors du transfert des données: $e');
  }
}


// APPROCHE ALTERNATIVE: Essayer d'envoyer l'ensemble des opérations en adaptant le format

Future<void> transfertDataToSpringBootBatch(List<OperationModel> operationsFiltrees) async {
  final operationTransactionService = OperationTransactionService();

  if (operationsFiltrees.isEmpty) {
    print("Aucune opération à transférer.");
    return;
  }

  // Récupération du numéro de téléphone de l'entreprise
  String numeroTelEntreprise = operationsFiltrees.first.numeroTelEntreprise;

  // Utiliser la date sélectionnée au format 'dd/MM/yyyy'
  DateTime selectedDate = operationsFiltrees.first.dateOperation; // Suppose que tu utilises cette date
  String formattedSelectedDate = DateFormat('dd/MM/yyyy').format(selectedDate);

  try {
    // Étape 1 : Supprimer les données existantes sur Spring Boot
    await operationTransactionService.deleteByNumeroAndDate(numeroTelEntreprise, formattedSelectedDate);

    print("Données supprimées pour le numéro : $numeroTelEntreprise à la date : $formattedSelectedDate");

    // Étape 2 : Envoyer les nouvelles données
    for (var operation in operationsFiltrees) {
      // Convertir la date si elle est au format 'dd/MM/yyyy'
      DateTime date = operation.dateOperation;
      operation.dateOperationFormatted = DateFormat('yyyy-MM-dd').format(date);

      await operationTransactionService.sendOperation(operation);
      print("Opération envoyée : ${operation.toJson()}");
    }

    print("Transfert terminé avec succès.");
  } catch (e) {
    print("Erreur lors du transfert des données : $e");
  }
}

class OperationModel {
  DateTime dateOperation;
  String numeroTelEntreprise;
  String dateOperationFormatted = '';

  OperationModel({
    required this.dateOperation,
    required this.numeroTelEntreprise,
  });

  Map<String, dynamic> toJson() => {
        'dateOperation': dateOperationFormatted,
        'numeroTelEntreprise': numeroTelEntreprise,
      };
}

class OperationTransactionService {
  Future<void> deleteByNumeroAndDate(String numeroTel, String date) async {
    //print("Suppression des données pour $numeroTel à la date $date");
  }
  Future<void> sendOperation(OperationModel operation) async {
   // print("Envoi de l'opération : ${operation.toJson()}");
  }
}





