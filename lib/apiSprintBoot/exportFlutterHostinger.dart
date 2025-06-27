import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';
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


Future<List<AddSimModel>> getOperateursFromHive() async {
  final box = await openBoxSafe<AddSimModel>('todobos5');
  final allOperateurs = box.values.toList();
  return allOperateurs;
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

Future<List<JournalCaisseModel>> getJournalCaissesFromHive(String dateControle) async {
  final box = await openBoxSafe<JournalCaisseModel>('todobos6');
  final allJournalCaisse = box.values.toList();
  return allJournalCaisse.where((journal) => journal.dateJournal == dateControle).toList();
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


Future<void> exportVersBackend({
  required BuildContext context,
  required bool isCaisse, // true = caisse, false = orange
}) async {
  if (!await checkInternetBeforeApiCall(context)) return;

  final entreprise = await getEntrepriseFromHiveHos();
  if (entreprise == null ||
      entreprise.numeroTelEntreprise.isEmpty ||
      entreprise.DateControle.isEmpty) {
    showAlertDialog(context, "❗ Le numéro ou la date de contrôle est manquant.");
    return;
  }

  final dateSQL = convertirDateFormat(entreprise.DateControle);
  final userKey = await getUserKeyFromHiveHos();
  final userKeyValue = userKey?.numeroaleatoire ?? '';

  // 🔗 URLs backend
  final deleteUrl = isCaisse
      ? 'https://kadoussconnect.com/transfertflutter/backend/deleteCaisse.php'
      : 'https://kadoussconnect.com/transfertflutter/backend/delete_data.php';

  final postUrl = isCaisse
      ? 'https://kadoussconnect.com/transfertflutter/backend/saveCaisse.php'
      : 'https://kadoussconnect.com/transfertflutter/backend/save_data.php';

  // 🔗 URLs opérateurs
  final deleteOperateurUrl = 'https://kadoussconnect.com/transfertflutter/backend/deleteOperateur.php';
  final saveOperateurUrl = 'https://kadoussconnect.com/transfertflutter/backend/saveOperateur.php';

  // 🔄 Suppression des données anciennes pour Orange ou Caisse
  final fullDeleteUrl =
      '$deleteUrl?telEntreprise=${entreprise.numeroTelEntreprise}&dateOp=$dateSQL&emailEP=${entreprise.emailEntreprise}';

  final deleteResponse = await secureHttpGet(context: context, url: fullDeleteUrl);
  if (deleteResponse != null && deleteResponse.statusCode == 200) {
    final result = jsonDecode(deleteResponse.body);
    if (result['status'] != 'success') {
      print("⚠️ Suppression partielle : ${result['message']}");
    }
  }

  // 🔄 Suppression opérateurs (aucun paramètre requis)
  await secureHttpGet(context: context, url: deleteOperateurUrl);

  // 📦 Données à exporter (Caisse ou Orange)
  final filteredData = isCaisse
      ? await openBoxSafe<JournalCaisseModel>('todobos6').then((box) =>
          box.values.where((op) => op.dateJournal == entreprise.DateControle).toList())
      : await openBoxSafe<OrangeModel>('todobos').then((box) =>
          box.values.where((op) => op.dateoperation == entreprise.DateControle).toList());

  final List<Map<String, dynamic>> jsonToSend = [];

  for (var op in filteredData) {
    final map = (isCaisse ? (op as JournalCaisseModel).toJson() : (op as OrangeModel).toJson());
    map['numeroTelEntreprise'] = entreprise.numeroTelEntreprise;
    map['emailEntreprise'] = entreprise.emailEntreprise;
    map['DateControle'] = entreprise.DateControle;
    map['numeroaleatoire'] = userKeyValue;
    jsonToSend.add(map);
  }

  // 📤 Envoi des données Caisse ou Orange
  final postResponse = await secureHttpPost(
    context: context,
    url: postUrl,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(jsonToSend),
  );

  // 📦 Récupération opérateurs (aucun filtre)
  final operateurs = await getOperateursFromHive();
  final List<Map<String, dynamic>> jsonOperateurs = operateurs.map((op) {
    final map = op.toJson();
    map['numeroTelEntreprise'] = entreprise.numeroTelEntreprise;
    map['emailEntreprise'] = entreprise.emailEntreprise;
    map['DateControle'] = entreprise.DateControle;
    map['numeroaleatoire'] = userKeyValue;
    return map;
  }).toList();

  // 📤 Envoi des opérateurs
  final postOperateur = await secureHttpPost(
    context: context,
    url: saveOperateurUrl,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(jsonOperateurs),
  );

  // ✅ Résultat
  if ((postResponse != null && postResponse.statusCode == 200) &&
      (postOperateur != null && postOperateur.statusCode == 200)) {
    showAlertDialog(context, "✅ Données exportées avec succès.");
  } else {
    showAlertDialog(context, "❌ Échec de l'envoi des données.");
  }
}



// Future<void> exportVersBackend({
//   required BuildContext context,
//   required bool isCaisse, // true = caisse, false = orange
// }) async {
//   if (!await checkInternetBeforeApiCall(context)) return;

//   final entreprise = await getEntrepriseFromHiveHos();
//   if (entreprise == null ||
//       entreprise.numeroTelEntreprise.isEmpty ||
//       entreprise.DateControle.isEmpty) {
//     showAlertDialog(context, "❗ Le numéro ou la date de contrôle est manquant.");
//     return;
//   }

//   final dateSQL = convertirDateFormat(entreprise.DateControle);

//   final userKey = await getUserKeyFromHiveHos();
//   final userKeyValue = userKey?.numeroaleatoire ?? '';

//   final deleteUrl = isCaisse
//       ? 'https://kadoussconnect.com/transfertflutter/backend/deleteCaisse.php'
//       : 'https://kadoussconnect.com/transfertflutter/backend/delete_data.php';

//   final postUrl = isCaisse
//       ? 'https://kadoussconnect.com/transfertflutter/backend/saveCaisse.php'
//       : 'https://kadoussconnect.com/transfertflutter/backend/save_data.php';

//   final filteredData = isCaisse
//       ? await openBoxSafe<JournalCaisseModel>('todobos6').then((box) =>
//           box.values.where((op) => op.dateJournal == entreprise.DateControle).toList())
//       : await openBoxSafe<OrangeModel>('todobos').then((box) =>
//           box.values.where((op) => op.dateoperation == entreprise.DateControle).toList());

//   final fullDeleteUrl =
//       '$deleteUrl?telEntreprise=${entreprise.numeroTelEntreprise}&dateOp=$dateSQL&emailEP=${entreprise.emailEntreprise}';

//   final deleteResponse = await secureHttpGet(context: context, url: fullDeleteUrl);

//   if (deleteResponse != null && deleteResponse.statusCode == 200) {
//     final result = jsonDecode(deleteResponse.body);
//     if (result['status'] != 'success') {
//       print("⚠️ Suppression partielle : ${result['message']}");
//     }
//   }

//   // Construction des données à envoyer
//   final List<Map<String, dynamic>> jsonToSend = [];

//   for (var op in filteredData) {
//     final map = (isCaisse ? (op as JournalCaisseModel).toJson() : (op as OrangeModel).toJson());
//     map['numeroTelEntreprise'] = entreprise.numeroTelEntreprise;
//     map['emailEntreprise'] = entreprise.emailEntreprise;
//     map['DateControle'] = entreprise.DateControle;
//     map['numeroaleatoire'] = userKeyValue;
//     jsonToSend.add(map);
//   }

//   final postResponse = await secureHttpPost(
//     context: context,
//     url: postUrl,
//     headers: {'Content-Type': 'application/json'},
//     body: json.encode(jsonToSend),
//   );

//   if (postResponse != null && postResponse.statusCode == 200) {
//     showAlertDialog(context, "✅ Données exportées avec succès pour la date : ${entreprise.DateControle}");
//   } else {
//     showAlertDialog(context, "❌ Échec de l'envoi des données.");
//   }
// }
