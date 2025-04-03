import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';

final storage = FlutterSecureStorage();

// Fonction pour vérifier si le token est expiré
Future<bool> isTokenExpired() async {
  String? token = await storage.read(key: 'token');
  if (token == null) return true;

  try {
    if (JwtDecoder.isExpired(token)) return true;

    final decodedToken = JwtDecoder.decode(token);
    final expirationTime = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
    final currentTime = DateTime.now();
    return expirationTime.difference(currentTime).inMinutes < 5;
  } catch (e) {
    print('Erreur lors de la vérification du token : $e');
    return true;
  }
}

// Fonction pour récupérer un token valide
Future<String?> getTokenDataFlutter() async {
  if (await isTokenExpired()) {
    print('🔄 Token expiré ou absent, tentative de renouvellement...');
    bool refreshSuccess = await refreshTokenDataFlutter();
    if (!refreshSuccess) {
      print('🔄 Échec du rafraîchissement, tentative de connexion...');
      bool loginSuccess = await connexionManuelleDataFlutter('ouedraogomariam@gmail.com', '000');
      if (!loginSuccess) return null;
    }
  }
  return await storage.read(key: 'token');
}

// Fonction pour rafraîchir le token
Future<bool> refreshTokenDataFlutter() async {
  try {
    String? refreshTokenValue = await storage.read(key: 'refresh_token');
    if (refreshTokenValue == null) return false;

    final response = await http.post(
      Uri.parse('http://192.168.100.6:8081/api/v1/auth/refresh-token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshTokenValue',
      },
    ).timeout(Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      await storage.write(key: 'token', value: data['access_token']);
      if (data['refresh_token'] != null) {
        await storage.write(key: 'refresh_token', value: data['refresh_token']);
      }
      print('🔑 Token rafraîchi avec succès');
      return true;
    }
    return false;
  } catch (e) {
    print('Erreur lors du rafraîchissement du token : $e');
    return false;
  }
}

// Fonction de connexion manuelle
Future<bool> connexionManuelleDataFlutter(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.100.6:8081/api/v1/auth/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    ).timeout(Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      await storage.write(key: 'token', value: data['access_token']);
      if (data['refresh_token'] != null) {
        await storage.write(key: 'refresh_token', value: data['refresh_token']);
      }
      print('🔑 Connexion réussie et token stocké');
      return true;
    }
    print('❌ Échec de connexion: ${response.statusCode} - ${response.body}');
    return false;
  } catch (e) {
    print('Erreur connexion : $e');
    return false;
  }
}

Future<void> transfertDataToFlutter(BuildContext context, String selectedDate) async {
  try {
    // 🛑 1. Récupérer un token valide
    String? token = await getTokenDataFlutter();
    if (token == null) {
      print("❌ Impossible d'obtenir un token valide.");
      return;
    }

    // 🛑 2. Vérifier et formater la date
    if (selectedDate.isEmpty || selectedDate == "00000000") {
      print("🚨 Date invalide : $selectedDate");
      return;
    }

    DateTime parsedDate;
    try {
      parsedDate = DateFormat('dd/MM/yyyy').parseStrict(selectedDate);
    } catch (e) {
      print("🚨 Erreur lors de la conversion de la date : $e");
      return;
    }

    final normalizedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    print("📅 Date normalisée : $normalizedDate");

    // 🛑 3. Ouvrir la boîte Hive 'todobos2' pour récupérer le numéro de téléphone
    Box<EntrepriseModel>? box2;
      try {
        if (!Hive.isBoxOpen('todobos2')) {
          box2 = await Hive.openBox<EntrepriseModel>('todobos2'); // ✅ Spécifie EntrepriseModel
        } else {
          box2 = Hive.box<EntrepriseModel>('todobos2'); // ✅ Utilise EntrepriseModel
        }
      } catch (e) {
        print("🚨 Erreur lors de l'ouverture de 'todobos2' : $e");
        return;
      }


    // 🛑 4. Récupérer le numéro de téléphone de l'entreprise
    String entrepriseNumero = box2.getAt(0)?.numeroTelEntreprise ?? ""; // Prends le premier enregistrement
    if (entrepriseNumero.isEmpty) {
      print("⚠️ Numéro de téléphone introuvable.");
      return;
    }
    print("📞 Numéro de l'entreprise récupéré : $entrepriseNumero");

    // 🛑 5. Ouvrir 'todobos' pour gérer les transactions
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

    // 🛑 6. Supprimer les transactions existantes pour cette date
    final itemsToDelete = box1.values.where((item) => item.dateoperation == normalizedDate).toList();
    if (itemsToDelete.isNotEmpty) {
      for (var item in itemsToDelete) {
        int key = box1.keyAt(box1.values.toList().indexOf(item)); 
        await box1.delete(key);
      }
      print("🗑️ Données supprimées pour la date : $normalizedDate");
    }

    // 🛑 7. Construire l'URL avec le numéro et la date
    final apiUrl = 'http://192.168.100.6:8081/transaction/v1/OperationTranslation/listTransaction';
    final fullUrl = '$apiUrl?entrepriseNumero=$entrepriseNumero&dateopera=$normalizedDate';
    print("🔗 URL appelée : $fullUrl");

    // 🛑 8. Récupérer les nouvelles données depuis Spring Boot
    final response = await http.get(
      Uri.parse(fullUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      if (data.isEmpty) {
        print("ℹ️ Aucune nouvelle donnée à importer.");
        return;
      }

      // 🛑 9. Ajouter les nouvelles données dans Hive
// Récupérer la réponse en forçant l'encodage UTF-8
final responseBody = utf8.decode(response.bodyBytes); // 🔥 Important : Utiliser `bodyBytes` au lieu de `body`

print("📜 Réponse brute après décodage UTF-8 : $responseBody");

// Décoder le JSON après correction de l'encodage
List<dynamic> data1 = json.decode(responseBody);

for (var item in data1) {
  print("🛠️ Données après suppression des clés inutiles : $item");

  // Convertir en OrangeModel et ajouter à Hive
  OrangeModel transaction = OrangeModel.fromJSON(item);
  await box1.add(transaction);
}


      print("✅ Données importées avec succès : ${data.length} opérations ajoutées.");
    } else {
      print("❌ Échec de l'importation : ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("🚨 Erreur lors du transfert des données : $e");
  }
}
