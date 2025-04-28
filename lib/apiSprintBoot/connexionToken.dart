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
  try {
    final connectivityResult = await Connectivity()
        .checkConnectivity()
        .timeout(const Duration(seconds: 2));
    
    if (connectivityResult == ConnectivityResult.none) {
      print("❌ Aucun réseau détecté");
      return false;
    }
  } on TimeoutException catch (_) {
    print("⏳ Timeout lors de checkConnectivity()");
    return false;
  } catch (e) {
    print("💥 Erreur inconnue checkConnectivity() : $e");
    return false;
  }

  // Si réseau détecté, on teste Google
  try {
    final response = await http
        .get(Uri.parse('https://clients3.google.com/generate_204'))
        .timeout(const Duration(seconds: 3));
    if (response.statusCode == 204) {
      print("✅ Connexion internet confirmée");
      return true;
    } else {
      print("⚠️ Réponse inattendue du test Google");
    }
  } on TimeoutException catch (_) {
    print("⏳ Timeout lors du test Google");
  } on SocketException catch (_) {
    print("📡 SocketException Google test");
  } catch (e) {
    print("💥 Erreur inconnue test Google : $e");
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

Future<bool> hasWorkingDNS() async {
  try {
    final result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 2));
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (e) {
    print("❌ DNS inaccessible : $e");
    return false;
  }
}


Future<http.Response?> secureHttpGet({
  required BuildContext context,
  required String url,
  Map<String, String>? headers,
  Duration timeout = const Duration(seconds: 30),
}) async {
bool isConnected = await isConnectedToInternet();
if (!isConnected || !(await hasWorkingDNS())) {
  showAlertDialog(context, "📡 Pas de connexion internet détectée.");
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
  try {
    final isConnected = await isConnectedToInternet();
    if (!isConnected) {
      showAlertDialog(context, "📡 Vous n’êtes pas connecté à Internet.");
      return null;
    }

    print("📤 Envoi POST vers $url...");
    final response = await http
        .post(Uri.parse(url), headers: headers, body: body, encoding: encoding)
        .timeout(timeout);

    return response;
  } on TimeoutException catch (_) {
    print("⏳ Timeout POST vers $url");
    showAlertDialog(context, "⏳ Le serveur ne répond pas. Vérifiez votre connexion.");
  } on SocketException catch (_) {
    print("📡 Erreur réseau lors du POST");
    showAlertDialog(context, "📡 Aucune connexion au serveur détectée.");
  } catch (e) {
    print("💥 Erreur imprévue POST : $e");
    showAlertDialog(context, "💥 Une erreur inattendue est survenue : $e");
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
  // Future<String?> getToken(BuildContext context) async {

  // if (!await isConnectedToInternet()) {
  //   showAlertDialog(context, "📡 Vous n’êtes pas connecté à Internet.");
  //   return null;
  // }

  // if (await isTokenExpire()) {
  //   print('🔄 Token expiré ou absent, tentative de renouvellement...');
  //   // Tente de rafraîchir le token
  //   bool refreshSuccess = await refreshToken(context);
  //   if (!refreshSuccess) {
  //     // Ne tente PAS la connexion manuelle
  //     print('❌ Échec du rafraîchissement du token. Connexion annulée.');
  //     showAlertDialog(
  //         context, "❌ Votre session a expiré. Veuillez vous reconnecter manuellement.");
  //     return null;
  //   }
  // }
  //   return await storage.read(key: 'token');
  // } 

  Future<String?> getToken(BuildContext context) async {
  if (!await isConnectedToInternet()) {
    showAlertDialog(context, "📡 Vous n’êtes pas connecté à Internet.");
    return null;
  }

  String? token = await storage.read(key: 'token');

  if (token == null) {
    print("⚠️ Aucun token trouvé. Demande de connexion manuelle.");
    showAlertDialog(
      context,
      "🔐 Vous n’êtes pas connecté. Veuillez vous connecter pour continuer."
    );
    return null;
  }

  // Si le token existe mais est expiré ou proche de l'expiration
  if (JwtDecoder.isExpired(token)) {
    print('🔄 Token expiré, tentative de renouvellement...');
    bool refreshSuccess = await refreshToken(context);
    if (!refreshSuccess) {
      print('❌ Échec du rafraîchissement du token. Connexion annulée.');
      showAlertDialog(
        context,
        "❌ Votre session a expiré. Veuillez vous reconnecter manuellement."
      );
      return null;
    }
    // On récupère le nouveau token après le refresh
    return await storage.read(key: 'token');
  }

  return token;
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

