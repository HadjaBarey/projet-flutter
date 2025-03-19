import 'package:hive/hive.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Ajout pour vérifier l'expiration du JWT

final storage = FlutterSecureStorage();

// Fonction pour récupérer les données de Hive
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

// Fonction pour vérifier si le token est expiré ou va expirer bientôt
Future<bool> isTokenExpired() async {
  String? token = await storage.read(key: 'token');
  if (token == null) return true;
  
  try {
    // Vérifie si le token est déjà expiré
    if (JwtDecoder.isExpired(token)) return true;
    
    // Vérifie si le token va expirer dans les 5 minutes
    final decodedToken = JwtDecoder.decode(token);
    final expirationTime = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
    final currentTime = DateTime.now();
    final difference = expirationTime.difference(currentTime).inMinutes;
    
    // Si le token expire dans moins de 5 minutes, on le considère comme expiré
    return difference < 5;
  } catch (e) {
    print('Erreur lors de la vérification du token : $e');
    return true;
  }
}

// Fonction pour récupérer le token (vérifie l'expiration)
Future<String?> getToken() async {
  if (await isTokenExpired()) {
    print('🔄 Token expiré ou absent, renouvellement...');
    bool refreshSuccess = await refreshToken();
    if (!refreshSuccess) {
      print('🔄 Échec du rafraîchissement, tentative de connexion...');
      bool loginSuccess = await connexionManuelle('ouedraogomariam@gmail.com', '000');
      if (!loginSuccess) return null;
    }
  }
  return await storage.read(key: 'token');
}

// Fonction pour rafraîchir le token
Future<bool> refreshToken() async {
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
      String? newAccessToken = data['access_token'];
      String? newRefreshToken = data['refresh_token'];
      
      if (newAccessToken != null) {
        await storage.write(key: 'token', value: newAccessToken);
        if (newRefreshToken != null) {
          await storage.write(key: 'refresh_token', value: newRefreshToken);
        }
        print('🔑 Token rafraîchi avec succès');
        return true;
      }
    }
    return false;
  } catch (e) {
    print('Erreur lors du rafraîchissement du token : $e');
    return false;
  }
}

// Fonction de connexion manuelle améliorée
Future<bool> connexionManuelle(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.100.6:8081/api/v1/auth/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    ).timeout(Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      String? accessToken = data['access_token'];
      String? refreshToken = data['refresh_token']; // Récupère aussi le refresh token
      
      if (accessToken != null) {
        await storage.write(key: 'token', value: accessToken);
        if (refreshToken != null) {
          await storage.write(key: 'refresh_token', value: refreshToken);
        }
        print('🔑 Connexion réussie et token stocké');
        return true;
      }
    } else {
      print('❌ Échec de connexion: ${response.statusCode} - ${response.body}');
    }
    return false;
  } catch (e) {
    print('Erreur connexion : $e');
    return false;
  }
}

// Fonction pour gérer les erreurs HTTP 401 ou 403 (token expiré)
Future<bool> handleAuthError(http.Response response) async {
  if (response.statusCode == 401 || response.statusCode == 403) {
    print('🔒 Erreur d\'authentification, tentative de renouvellement...');
    // Forcer l'expiration du token actuel
    await storage.delete(key: 'token');
    // Tenter un refresh puis une connexion si nécessaire
    String? newToken = await getToken();
    return newToken != null;
  }
  return false;
}

// Fonction pour transférer les données vers Spring Boot avec retry
// Fonction modifiée pour corriger le format des données
Future<void> transfertDataToSpringBoot(List<OrangeModel> operations) async {
  try {
    if (operations.isEmpty) {
      print('❌ Aucune donnée à envoyer.');
      return;
    }

    String? token = await getToken();
    if (token == null) {
      print('❌ Impossible d\'obtenir un token valide.');
      return;
    }

    print('🔍 Vérification du token : $token');
    print('🔑 Token utilisé : $token');
    
    String apiUrl = 'http://192.168.100.6:8081/transaction/v1/OperationTranslation/create';
    
    // Conversion des opérations en JSON
    List<Map<String, dynamic>> operationsJson = operations.map((operation) {
      return {

        
        "idoperation":1,
        "dateoperation":"18/03/2026",
        "montant":"1000000",
        "numeroTelephone":"76365059",
        "infoClient":"kadous",
        "typeOperation":1,
        "operateur":"1",
        "supprimer":0,
        "iddette":0,
        "optionCreance":false,
        "scanMessage":"Message Scanné",
        "numeroIndependant":"",
        "idTrans":"CI240603.1157.97376974",
        "created_at":"2025-03-19T14:42:49.261297",
        "updated_at":"2025-03-19T14:42:49.266591"

        // "idoperation": operation.idoperation,
        // "dateoperation": operation.dateoperation,
        // "montant": operation.montant,
        // "numeroTelephone": operation.numeroTelephone?.trim(),
        // "infoClient": operation.infoClient,
        // "typeOperation": operation.typeOperation ?? 0,
        // "operateur": operation.operateur,
        // "supprimer": operation.supprimer ?? 0,
        // "iddette": operation.iddette ?? 0,
        // "optionCreance": operation.optionCreance ?? false,
        // "scanMessage": operation.scanMessage,
        // "numeroIndependant": operation.numeroIndependant?.trim() ?? "",
        // "idTrans": operation.idTrans,
        // "created_at": "",
        // "updated_at": ""
      };
    }).toList();
    
    // CORRECTION: Envoyer un objet avec une propriété "operations" contenant la liste
    // Le serveur attend un objet OperationTransactionDTO, pas un tableau
    final jsonPayload = json.encode({
      "operations": operationsJson
    });
    
    print('📦 Données envoyées : $jsonPayload');

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonPayload,
    );

    if (response.statusCode == 200) {
      print('✅ Données envoyées avec succès.');
    } else if (response.statusCode == 400) {
      print('❌ Erreur de format de données (400): ${response.body}');
    } else if (await handleAuthError(response)) {
      print('🔄 Réessai après renouvellement du token...');
      String? newToken = await getToken();
      if (newToken != null) {
        final retryResponse = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $newToken',
          },
          body: jsonPayload,
        );
        
        if (retryResponse.statusCode == 200) {
          print('✅ Données envoyées avec succès après renouvellement.');
        } else {
          print('❌ Échec persistant: ${retryResponse.statusCode} - ${retryResponse.body}');
        }
      }
    } else {
      print('❌ Erreur HTTP ${response.statusCode} : ${response.body}');
    }
  } catch (e) {
    print('🚨 Erreur lors de l\'envoi des données : $e');
  }
}