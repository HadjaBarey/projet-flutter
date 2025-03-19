// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// // Initialisation du stockage sécurisé
// final storage = FlutterSecureStorage();

// //--------------------------------------------------------------
// // Fonction de connexion manuelle
// //--------------------------------------------------------------
// Future<bool> connexionManuelle(String email, String password) async {
//   try {
//     print('📱 Tentative de connexion à: http://192.168.100.6:8081/api/v1/auth/authenticate');
//     final response = await http.post(
//       Uri.parse('http://192.168.100.6:8081/api/v1/auth/authenticate'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({
//         'email': email,
//         'password': password,
//       }),
//     ).timeout(Duration(seconds: 15));

//     print('📱 Statut de la réponse: ${response.statusCode}');
//     print('📱 Réponse complète: ${response.body}'); // Afficher la réponse complète pour le débogage

//     if (response.statusCode == 200) {
//       // Décoder la réponse JSON
//       final Map<String, dynamic> data = json.decode(response.body);

//       // Extraire le token d'accès
//       String? accessToken = data['access_token']; // Utilisez la clé correcte
//       if (accessToken != null) {
//         await storage.write(key: 'token', value: accessToken); // Sauvegarder le token
//         print('✅ Token sauvegardé : $accessToken');
//         return true;
//       } else {
//         print('❌ Aucun token reçu dans la réponse.');
//         return false;
//       }
//     } else {
//       print('📱 Erreur HTTP: ${response.statusCode}');
//       print('📱 Réponse: ${response.body}');
//       return false;
//     }
//   } catch (e) {
//     print('📱 Détails de l\'erreur: $e');
//     return false;
//   }
// }