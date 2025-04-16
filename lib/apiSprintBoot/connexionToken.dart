//verifiction de la connexion au reseau
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final storage = FlutterSecureStorage();


Future<bool> isConnectedToInternet() async {
final connectivityResult = await Connectivity().checkConnectivity();

  // Aucun réseau détecté (Wi-Fi, mobile, etc.)
  if (connectivityResult == ConnectivityResult.none) {
    print("❌ Aucune connexion réseau détectée.");
    return false;
  }

  try {
    // On teste une vraie résolution DNS sur Google
    final result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 3));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print("✅ Connexion internet active");
      return true;
    }
  } on SocketException catch (_) {
    print("📡 SocketException : impossible d'accéder à internet.");
  } on TimeoutException {
    print("⏳ Timeout lors du test DNS");
  }

  return false;
}


Future<bool> checkInternetBeforeApiCall(BuildContext context) async {
  if (!await isConnectedToInternet()) {
    showAlertDialog(context, "📱 Vous n’êtes pas connecté à Internet.");
    return false;
  }
  return true;
}


Future<http.Response?> secureHttpGet({
  required BuildContext context,
  required String url,
  Map<String, String>? headers,
  Duration timeout = const Duration(seconds: 30),
}) async {
  if (!await isConnectedToInternet()) {
   // print("📡 Aucune connexion détectée, GET annulé.");
    showAlertDialog(context, "📡 Vous n’êtes pas connecté à Internet.");
    return null;
  }

  try {
    final response = await http.get(Uri.parse(url), headers: headers).timeout(timeout);
    return response;
  } on TimeoutException {
    print("⏳ Timeout GET");
    showAlertDialog(context, "⏳ Le serveur ne répond pas. Vérifiez votre connexion.");
  } on SocketException {
    print("📡 Pas de connexion réseau GET");
    showAlertDialog(context, "📡 Aucune connexion réseau détectée.");
  } catch (e) {
    print("💥 Erreur GET : $e");
    showAlertDialog(context, "💥 Une erreur est survenue : $e");
  }
  return null;
}


Future<http.Response?> secureHttpPost({
  required BuildContext context,
  required String url,
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
  Duration timeout = const Duration(seconds: 30),
}) async {
  if (!await isConnectedToInternet()) {
  // print("📡 Aucune connexion détectée, POST annulé.");
  //  showAlertDialog(context, "📡 Vous n’êtes pas connecté à Internet.");
    return null;
  }
  try {
    final response = await http
        .post(Uri.parse(url), headers: headers, body: body, encoding: encoding)
        .timeout(timeout);
    return response;
  } on TimeoutException {
     print("⏳ Timeout POST");
    // showAlertDialog(context, "⏳ Le serveur ne répond pas. Vérifiez votre connexion.");
  } on SocketException {
    print("📡 Pas de connexion réseau POST");
    // showAlertDialog(context, "📡 Aucune connexion réseau détectée.");
  } catch (e) {
     print("💥 Erreur POST : $e");
    // showAlertDialog(context, "💥 Une erreur est survenue : $e");
  }
  return null;
}




// Fonction pour vérifier si le token est expiré
Future<bool> isTokenExpire() async {
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
  Future<String?> getToken(BuildContext context) async {

  if (!await isConnectedToInternet()) {
    showAlertDialog(context, "📡 Vous n’êtes pas connecté à Internet.");
    return null;
  }

  if (await isTokenExpire()) {
    print('🔄 Token expiré ou absent, tentative de renouvellement...');
    // Tente de rafraîchir le token
    bool refreshSuccess = await refreshToken(context);
    if (!refreshSuccess) {
      // Ne tente PAS la connexion manuelle
      print('❌ Échec du rafraîchissement du token. Connexion annulée.');
      showAlertDialog(
          context, "❌ Votre session a expiré. Veuillez vous reconnecter manuellement.");
      return null;
    }
  }
    return await storage.read(key: 'token');
  } 


// Fonction pour rafraîchir le token
Future<bool> refreshToken(BuildContext context) async {
  if (!await checkInternetBeforeApiCall(context)) return false;
  try {
    String? refreshTokenValue = await storage.read(key: 'refresh_token');
    if (refreshTokenValue == null) {
      print("⚠️ Aucun refresh token trouvé.");
      return false;
    }

    final response = await secureHttpPost(
      context: context,
      url: 'http://192.168.100.6:8081/api/v1/auth/refresh-token',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshTokenValue',
      },
      timeout: Duration(seconds: 15),
    );

    if (response != null && response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      await storage.write(key: 'token', value: data['access_token']);
      if (data['refresh_token'] != null) {
        await storage.write(key: 'refresh_token', value: data['refresh_token']);
      }
      print('✅ Token rafrâichi avec succès');
      return true;
    }
    return false;
  } catch (e) {
    showAlertDialog(context, "❌ Une erreur est survenue : $e");
    return false;
  }
}


// Fonction de connexion manuelle
Future<bool> connexionManuelle(BuildContext context, String email, String password) async {
  if (!await checkInternetBeforeApiCall(context)) return false;

  final response = await secureHttpPost(
    context: context,
    url: 'http://192.168.100.6:8081/api/v1/auth/authenticate',
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'email': email, 'password': password}),
    timeout: Duration(seconds: 15),
  );

  if (response != null && response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    await storage.write(key: 'token', value: data['access_token']);
    if (data['refresh_token'] != null) {
      await storage.write(key: 'refresh_token', value: data['refresh_token']);
    }
    print('🔑 Connexion réussie et token stocké');
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

void showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("⚠️ Information", style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("OK"),
        ),
      ],
    ),
  );
}
