import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final storage = FlutterSecureStorage();

/// 🔍 Vérifie s'il y a une véritable connexion Internet (réseau + accès web)
Future<bool> isConnectedToInternet() async {
  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) return false;

    // Essaye avec plusieurs sites connus
    final List<String> testUrls = [
      'https://clients3.google.com/generate_204',
      'https://www.google.com',
      'https://www.bing.com',
    ];

    for (String url in testUrls) {
      try {
       final response = await http
    .get(Uri.parse('http://216.58.204.174')) // IP de Google
    .timeout(const Duration(seconds: 5));

        if (response.statusCode == 204 || response.statusCode == 200) {
          return true;
        }
      } catch (_) {
        // Ignorer ce test et essayer le suivant
      }
    }
  } catch (_) {}
  return false;
}


/// 🚨 Affiche un message d'alerte dans l'app
void showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("⚠️ Information"),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("OK"))
      ],
    ),
  );
}

/// ✅ Vérifie la connexion avant un appel API, sinon affiche un message
Future<bool> checkInternetBeforeApiCall(BuildContext context) async {
  bool isConnected = await isConnectedToInternet();
  if (!isConnected) {
    showAlertDialog(context, "📶 Pas de connexion Internet détectée.");
    return false;
  }
  return true;
}

/// 🔐 Vérifie si le token est expiré (ou proche de l'être)
Future<bool> isTokenExpire() async {
  String? token = await storage.read(key: 'token');
  if (token == null) return true;

  try {
    if (JwtDecoder.isExpired(token)) return true;
    final expiration = JwtDecoder.getExpirationDate(token);
    return expiration.difference(DateTime.now()).inMinutes < 5;
  } catch (_) {
    return true;
  }
}

/// 🔁 Rafraîchit le token
Future<bool> refreshToken(BuildContext context) async {
  if (!await checkInternetBeforeApiCall(context)) return false;

  try {
    String? refreshToken = await storage.read(key: 'refresh_token');
    if (refreshToken == null) return false;

    final response = await secureHttpPost(
      context: context,
      url: 'http://192.168.100.6:8081/api/v1/auth/refresh-token',
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $refreshToken'},
    );

    if (response?.statusCode == 200) {
      final data = json.decode(response!.body);
      await storage.write(key: 'token', value: data['access_token']);
      if (data['refresh_token'] != null) {
        await storage.write(key: 'refresh_token', value: data['refresh_token']);
      }
      return true;
    }
  } catch (_) {}
  return false;
}

/// 🔑 Récupère un token valide (ou tente un refresh)
Future<String?> getToken(BuildContext context) async {
  if (!await checkInternetBeforeApiCall(context)) return null;

  String? token = await storage.read(key: 'token');
  if (token == null || await isTokenExpire()) {
    if (!await refreshToken(context)) {
      showAlertDialog(context, "🔐 Session expirée. Veuillez vous reconnecter.");
      return null;
    }
    token = await storage.read(key: 'token');
  }
  return token;
}

/// 📤 Appel POST sécurisé avec gestion des erreurs réseau
Future<http.Response?> secureHttpPost({
  required BuildContext context,
  required String url,
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
  Duration timeout = const Duration(seconds: 30),
}) async {
  if (!await checkInternetBeforeApiCall(context)) return null;

  try {
    return await http.post(Uri.parse(url), headers: headers, body: body, encoding: encoding)
        .timeout(timeout);
  } on TimeoutException {
    showAlertDialog(context, "⏳ Le serveur ne répond pas.");
  } on SocketException {
    showAlertDialog(context, "📡 Problème de réseau.");
  } catch (e) {
    showAlertDialog(context, "❌ Erreur lors de l'appel API : $e");
  }
  return null;
}

/// 📥 Appel GET sécurisé avec gestion des erreurs réseau
Future<http.Response?> secureHttpGet({
  required BuildContext context,
  required String url,
  Map<String, String>? headers,
  Duration timeout = const Duration(seconds: 30),
}) async {
  if (!await checkInternetBeforeApiCall(context)) return null;

  try {
    return await http.get(Uri.parse(url), headers: headers).timeout(timeout);
  } on TimeoutException {
    showAlertDialog(context, "⏳ Temps de réponse trop long.");
  } on SocketException {
    showAlertDialog(context, "📡 Pas de réseau.");
  } catch (e) {
    showAlertDialog(context, "❌ Erreur : $e");
  }
  return null;
}

/// 🔐 Connexion manuelle de l'utilisateur
Future<bool> connexionManuelle(BuildContext context, String email, String password) async {
  final response = await secureHttpPost(
    context: context,
    url: 'http://192.168.100.6:8081/api/v1/auth/authenticate',
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response != null && response.statusCode == 200) {
    final data = json.decode(response.body);
    await storage.write(key: 'token', value: data['access_token']);
    if (data['refresh_token'] != null) {
      await storage.write(key: 'refresh_token', value: data['refresh_token']);
    }
    return true;
  } else if (response != null) {
    showAlertDialog(context, "❌ Connexion échouée : ${response.statusCode}");
  }

  return false;
}
// Fonction pour gérer les erreurs HTTP 401 ou 403 (token expiré)
Future<bool> handleAuthError(http.Response response, BuildContext context) async {
  if (response.statusCode == 401 || response.statusCode == 403) {
    print('🔒 Erreur d\'authentification, tentative de renouvellement...');
    await storage.delete(key: 'token');
    String? newToken = await getToken(context);
    return newToken != null;
  }
  return false;
}