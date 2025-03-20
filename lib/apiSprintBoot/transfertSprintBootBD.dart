import 'package:hive/hive.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
// Fonction pour récupérer l'unique entreprise enregistrée dans todobos2
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

// Future<EntrepriseModel?> getDataFromHive2() async {
//   try {
//     if (Hive.isBoxOpen('todobos2')) {
//       await Hive.close();
//     }
//     Box<EntrepriseModel> box = await Hive.openBox<EntrepriseModel>('todobos2');
//     return box.get(0); // Supposant qu'il y a une seule entrée dans 'todobos2'
//   } catch (e) {
//     print('Erreur Hive (todobos2) : $e');
//     return null;
//   }
// }

//Fin Fonction qui permettrons de recuperer les données de mes 2 tables maitresses pour pouvoir combiner mes données pour les cibler dans mes enregistrements


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

// Fonction de connexion manuelle
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
      String? refreshToken = data['refresh_token'];
      
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
    await storage.delete(key: 'token');
    String? newToken = await getToken();
    return newToken != null;
  }
  return false;
}

// FONCTION CORRIGÉE: envoie chaque opération individuellement au format attendu par l'API
Future<void> transfertDataToSpringBoot(List<OrangeModel> operations) async {
  try {
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

    String? token = await getToken();
    if (token == null) {
      print('❌ Impossible d\'obtenir un token valide.');
      return;
    }

    print('🔍 Vérification du token : $token');
    
    String apiUrl = 'http://192.168.100.6:8081/transaction/v1/OperationTranslation/create';
    
    // Compteurs pour les statistiques
    int successCount = 0;
    int failCount = 0;
    
    // Traiter chaque opération individuellement
    for (OrangeModel operation in operations) {
      // Créer un objet conforme au format attendu par l'API
      final Map<String, dynamic> operationJson = {
        "codeoperation": operation.idoperation.toString(), // Ajout de codeoperation si nécessaire
        "idoperation": operation.idoperation,
        "dateoperation": operation.dateoperation,
        "montant": operation.montant,
        "numeroTelephone": operation.numeroTelephone?.trim(),
        "infoClient": operation.infoClient,
        "typeOperation": operation.typeOperation ?? 0,
        "operateur": operation.operateur,
        "supprimer": operation.supprimer ?? 0,
        "iddette": operation.iddette ?? 0,
        "optionCreance": operation.optionCreance ?? false,
        "scanMessage": operation.scanMessage,
        "numeroIndependant": operation.numeroIndependant?.trim() ?? "",
        "idTrans": operation.idTrans,
        "created_at": "",
        "updated_at": "",

        // Ajout des données de l'entreprise
        "numeroTelEntreprise": entreprise.numeroTelEntreprise

        // "idEntreprise": entreprise.idEntreprise,
        // "nomEntreprise": entreprise.NomEntreprise,
        // "directeurEntreprise": entreprise.DirecteurEntreprise,
        // "NumeroTelEntreprise": entreprise.NumeroTelEntreprise,
        // "emailEntreprise": entreprise.emailEntreprise
      };
      
      // Encoder directement l'objet JSON (sans l'envelopper dans "operations")
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
          print('✅ Opération envoyée avec succès: ${operation.idTrans}');
          successCount++;
        } else if (response.statusCode == 400) {
          print('❌ Erreur de format de données (400): ${response.body}');
          failCount++;
        } else if (await handleAuthError(response)) {
          // Récupérer un nouveau token et réessayer
          String? newToken = await getToken();
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
              print('✅ Opération envoyée avec succès après renouvellement: ${operation.idTrans}');
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
        print('🚨 Erreur lors de l\'envoi de l\'opération ${operation.idTrans}: $e');
        failCount++;
      }
    }
    
    // Afficher le résumé
    print('📊 Résumé du transfert: $successCount réussites, $failCount échecs sur ${operations.length} opérations');
    
  } catch (e) {
    print('🚨 Erreur générale lors du transfert des données: $e');
  }
}



// APPROCHE ALTERNATIVE: Essayer d'envoyer l'ensemble des opérations en adaptant le format
Future<void> transfertDataToSpringBootBatch(List<OrangeModel> operations) async {
  try {
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

    String? token = await getToken();
    if (token == null) {
      print('❌ Impossible d\'obtenir un token valide.');
      return;
    }

    print('🔍 Vérification du token : $token');
    
    String apiUrl = 'http://192.168.100.6:8081/transaction/v1/OperationTranslation/batch-create'; // Endpoint modifié
    
    // Conversion des opérations en JSON
    List<Map<String, dynamic>> operationsJson = operations.map((operation) {
      return {
        "codeoperation": operation.idoperation.toString(), // Ajout de codeoperation si nécessaire
        "idoperation": operation.idoperation,
        "dateoperation": operation.dateoperation,
        "montant": operation.montant,
        "numeroTelephone": operation.numeroTelephone?.trim(),
        "infoClient": operation.infoClient,
        "typeOperation": operation.typeOperation ?? 0,
        "operateur": operation.operateur,
        "supprimer": operation.supprimer ?? 0,
        "iddette": operation.iddette ?? 0,
        "optionCreance": operation.optionCreance ?? false,
        "scanMessage": operation.scanMessage,
        "numeroIndependant": operation.numeroIndependant?.trim() ?? "",
        "idTrans": operation.idTrans,
        "created_at": "",
        "updated_at": "",

        // Ajout des données de l'entreprise
        "numeroTelEntreprise": entreprise.numeroTelEntreprise


         // Ajout des données de l'entreprise
        // "idEntreprise": entreprise.idEntreprise,
        // "nomEntreprise": entreprise.NomEntreprise,
        // "directeurEntreprise": entreprise.DirecteurEntreprise,
       // "NumeroTelEntreprise": entreprise.NumeroTelEntreprise
        //"emailEntreprise": entreprise.emailEntreprise
      };
    }).toList();


    
    // Envoi direct de la liste (si le backend a un endpoint qui accepte une liste)
    final jsonPayload = json.encode(operationsJson);
    
    print('📦 Données envoyées en lot: $jsonPayload');

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonPayload,
    ).timeout(Duration(seconds: 30)); // Délai plus long pour les lots

    if (response.statusCode == 200) {
      print('✅ Toutes les données envoyées avec succès en lot.');
    } else {
      print('❌ Erreur lors de l\'envoi des données en lot: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('🚨 Erreur lors de l\'envoi des données en lot: $e');
  }
}