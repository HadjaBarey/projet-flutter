import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/UsersKeyModel.dart';

// 🔁 Fonction de conversion de date pour la base MySQL
String convertirDateFormat(String dateFR) {
  final parts = dateFR.split('/');
  if (parts.length != 3) return dateFR;
  return '${parts[2]}-${parts[1]}-${parts[0]}';
}

Future<Box<T>> openBoxSafe<T>(String boxName) async {
  if (Hive.isBoxOpen(boxName)) {
    return Hive.box<T>(boxName);
  }
  return await Hive.openBox<T>(boxName);
}

Future<List<OrangeModel>> getFilteredOperationsFromHive(String dateControle) async {
  final box = await openBoxSafe<OrangeModel>('todobos');
  final allOperations = box.values.toList();
  return allOperations.where((op) => op.dateoperation == dateControle).toList();
}

Future<EntrepriseModel?> getEntrepriseFromHiveHos() async {
  final box = await openBoxSafe<EntrepriseModel>('todobos2');
  if (box.isNotEmpty) {
    final keys = box.keys.whereType<int>().toList();
    if (keys.isNotEmpty) {
      keys.sort();
      return box.get(keys.last);
    }
  }
  return null;
}

Future<UsersKeyModel?> getUserKeyFromHiveHos() async {
  final box = await openBoxSafe<UsersKeyModel>('todobos7');
  if (box.isNotEmpty) {
    final keys = box.keys.whereType<int>().toList();
    if (keys.isNotEmpty) {
      keys.sort();
      return box.get(keys.last);
    }
  }
  return null;
}

Future<bool> deleteDataBeforeImport({
  required BuildContext context,
  required String telEntreprise,
  required String dateOp,
  required String emailEP,
}) async {
  final deleteUrl = 'https://kadoussconnect.com/transfertflutter/backend/delete_data.php';
  final fullUrl = '$deleteUrl?telEntreprise=$telEntreprise&dateOp=$dateOp&emailEP=$emailEP';

  final response = await secureHttpGet(context: context, url: fullUrl);

  if (response != null && response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      return true;
    } else {
      print("❌ Message backend : ${data['message']}");
      return false;
    }
  } else {
    print("❌ Erreur HTTP : ${response?.statusCode}");
    return true; // On continue même si la suppression échoue
  }
}

Future<bool> saveDataToPhp({
  required BuildContext context,
  required List<OrangeModel> operations,
  required EntrepriseModel entreprise,
}) async {
  final postUrl = 'https://kadoussconnect.com/transfertflutter/backend/save_data.php';

  final userKey = await getUserKeyFromHiveHos();
  final userKeyValue = userKey?.numeroaleatoire ?? '';

  final jsonToSend = operations.map((op) {
    final map = op.toJson();
    map['numeroTelEntreprise'] = entreprise.numeroTelEntreprise;
    map['emailEntreprise'] = entreprise.emailEntreprise;
    map['DateControle'] = entreprise.DateControle;
    map['numeroaleatoire'] = userKeyValue;
    return map;
  }).toList();

  print("📤 Données à envoyer (JSON encodé) :");
  print(json.encode(jsonToSend));

  final response = await secureHttpPost(
    context: context,
    url: postUrl,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(jsonToSend),
  );

  if (response != null && response.statusCode == 200) {
    print("✅ Données envoyées avec succès : ${response.body}");
    return true;
  } else {
    print("❌ Échec envoi : ${response?.statusCode}");
    return false;
  }
}

Future<void> exportData(BuildContext context) async {
  if (!await checkInternetBeforeApiCall(context)) return;

  final entreprise = await getEntrepriseFromHiveHos();
  if (entreprise == null || entreprise.numeroTelEntreprise.isEmpty || entreprise.DateControle.isEmpty) {
    showAlertDialog(context, "❗ Le numéro ou la date de contrôle de l'entreprise est manquant.");
    return;
  }

  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Confirmation'),
      content: Text('Voulez-vous vraiment exporter les données pour la date : ${entreprise.DateControle} ?'),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Non')),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Oui')),
      ],
    ),
  );

  if (confirm != true) return;

  final operationsFiltrees = await getFilteredOperationsFromHive(entreprise.DateControle);
  if (operationsFiltrees.isEmpty) {
    showAlertDialog(context, "❗ Aucune donnée trouvée pour la date ${entreprise.DateControle}");
    return;
  }

  // 🔄 Conversion de la date pour la requête SQL
  final dateSQL = convertirDateFormat(entreprise.DateControle);

  print("📌 Avant suppression :");
  print("telEntreprise = ${entreprise.numeroTelEntreprise}");
  print("date = ${entreprise.DateControle}");
  print("email = ${entreprise.emailEntreprise}");

  final deleted = await deleteDataBeforeImport(
    context: context,
    telEntreprise: entreprise.numeroTelEntreprise,
    dateOp: dateSQL,
    emailEP: entreprise.emailEntreprise,
  );

  // if (!deleted) {
  //   showAlertDialog(context, "❌ Échec suppression des anciennes données.");
  //   return;
  // }

  final saved = await saveDataToPhp(
    context: context,
    operations: operationsFiltrees,
    entreprise: entreprise,
  );

  if (saved) {
    showAlertDialog(context, "✅ Données exportées avec succès pour la date : ${entreprise.DateControle}");
  } else {
    showAlertDialog(context, "❌ Échec de l'envoi des données.");
  }
}

void showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("⚠️ Information", style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

// --- Fonctions complémentaires ---

// Vérifie la connexion internet avant un appel API
Future<bool> checkInternetBeforeApiCall(BuildContext context) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    showAlertDialog(context, "❌ Pas de connexion Internet. Veuillez vérifier votre connexion.");
    return false;
  }
  // Optionnel: vérifier la connexion réelle (ex: ping Google)
  try {
    final result = await http.get(Uri.parse('https://clients3.google.com/generate_204')).timeout(const Duration(seconds: 5));
    if (result.statusCode == 204) {
      return true;
    } else {
      showAlertDialog(context, "❌ Pas de connexion Internet réelle.");
      return false;
    }
  } catch (e) {
    showAlertDialog(context, "❌ Impossible de vérifier la connexion Internet.");
    return false;
  }
}

// Requête HTTP GET sécurisée
Future<http.Response?> secureHttpGet({
  required BuildContext context,
  required String url,
  Map<String, String>? headers,
}) async {
  try {
    final response = await http.get(Uri.parse(url), headers: headers);
    return response;
  } catch (e) {
    showAlertDialog(context, "❌ Erreur lors de la requête GET : $e");
    return null;
  }
}

// Requête HTTP POST sécurisée
Future<http.Response?> secureHttpPost({
  required BuildContext context,
  required String url,
  Map<String, String>? headers,
  Object? body,
}) async {
  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: body);
    return response;
  } catch (e) {
    showAlertDialog(context, "❌ Erreur lors de la requête POST : $e");
    return null;
  }
}
