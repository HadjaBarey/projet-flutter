import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/UsersKeyModel.dart';
import 'exportFlutterHostinger.dart';

String convertirDatePourMySQL(String dateFr) {
  final parts = dateFr.split('/');
  if (parts.length != 3) return dateFr;
  return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
}

String convertirDatePourFR(String dateMySQL) {
  final parts = dateMySQL.split('-');
  if (parts.length != 3) return dateMySQL;
  return '${parts[2].padLeft(2, '0')}/${parts[1].padLeft(2, '0')}/${parts[0]}';
}

Future<void> fetchAndSaveFromBackend({
  required BuildContext context,
  required String numeroEntreprise,
  required String dateOperation, // attendu au format dd/MM/yyyy
  required String emailEntreprise,
  required String numeroAleatoire,
}) async {
  // Convertir la date en format MySQL pour requête et comparaison
  final dateMySQL = convertirDatePourMySQL(dateOperation);

  final url = Uri.parse(
    'https://kadoussconnect.com/transfertflutter/backend/listTransaction.php'
    '?entrepriseNumero=$numeroEntreprise'
    '&dateopera=$dateMySQL'
    '&emailEPR=$emailEntreprise'
    '&numalea=$numeroAleatoire',
  );

  final response = await secureHttpGet(context: context, url: url.toString());

  print("🔗 URL: $url");
  print("📦 Response: ${response?.body}");

  if (response == null || response.statusCode != 200) {
    showAlertDialog(context, "❌ Erreur lors de la récupération des données.");
    return;
  }

  final decoded = jsonDecode(response.body);
  if (!(decoded['success'] ?? false)) {
    showAlertDialog(context, "❌ ${decoded['message'] ?? "Erreur inconnue"}");
    return;
  }

  final List<dynamic> data = decoded['data'];
  if (data.isEmpty) {
    showAlertDialog(context, "ℹ️ Aucune donnée à insérer.");
    return;
  }

  final boxOps = await openBoxSafe<OrangeModel>('todobos');
  final boxEnt = await openBoxSafe<EntrepriseModel>('todobos2');
  final boxUser = await openBoxSafe<UsersKeyModel>('todobos7');

  // 🔁 Supprimer les opérations pour cette date uniquement (en comparant en format MySQL)
  final dateFR = convertirDatePourFR(dateMySQL);

  final keysToDelete = boxOps.keys.where((key) {
    final item = boxOps.get(key);
    return item != null && item.dateoperation == dateFR;
  }).toList();

  await boxOps.deleteAll(keysToDelete);

 for (var item in data) {
  final itemClean = Map<String, dynamic>.from(item);

  // Renommage camelCase => snake_case (nom des propriétés du modèle)
  if (itemClean.containsKey('numeroTelephone')) {
    itemClean['numero_telephone'] = itemClean['numeroTelephone']?.toString() ?? '';
    itemClean.remove('numeroTelephone');
  }
  if (itemClean.containsKey('infoClient')) {
    itemClean['info_client'] = itemClean['infoClient']?.toString() ?? '';
    itemClean.remove('infoClient');
  }
  if (itemClean.containsKey('scanMessage')) {
    itemClean['scanmessage'] = itemClean['scanMessage']?.toString() ?? '';
    itemClean.remove('scanMessage');
  }
  if (itemClean.containsKey('idTrans')) {
    itemClean['idtrans'] = itemClean['idTrans']?.toString() ?? '';
    itemClean.remove('idTrans');
  }
  if (itemClean.containsKey('numeroIndependant')) {
    itemClean['numeroIndependant'] = itemClean['numeroIndependant']?.toString() ?? '';
    // Pas besoin de remove ici si nom identique
  }
  if (itemClean.containsKey('operateur')) {
    itemClean['operateur'] = itemClean['operateur']?.toString() ?? '';
    // Pas besoin de remove ici si nom identique
  }

  // Convertir les entiers
  itemClean['idoperation'] = (itemClean['idoperation'] is int)
      ? itemClean['idoperation']
      : int.tryParse(itemClean['idoperation']?.toString() ?? '0') ?? 0;

 if (itemClean.containsKey('typeOperation')) {
  itemClean['typeoperation'] = itemClean['typeOperation'] ?? 0;
  itemClean.remove('typeOperation');
}


  itemClean['supprimer'] = (itemClean['supprimer'] is int)
      ? itemClean['supprimer']
      : int.tryParse(itemClean['supprimer']?.toString() ?? '0') ?? 0;

  itemClean['iddette'] = (itemClean['iddette'] is int)
      ? itemClean['iddette']
      : int.tryParse(itemClean['iddette']?.toString() ?? '0') ?? 0;

  // Convertir optionCreance en bool
  itemClean['optionCreance'] = (itemClean['optionCreance'] == null)
      ? false
      : (itemClean['optionCreance'] is bool)
          ? itemClean['optionCreance']
          : (itemClean['optionCreance'] == 1 || itemClean['optionCreance'] == '1');

  // Convertir dateoperation au format dd/MM/yyyy si besoin
  if (itemClean['dateoperation'] != null) {
    final dateOpStr = itemClean['dateoperation'].toString();
    if (dateOpStr.contains('-')) {
      itemClean['dateoperation'] = convertirDatePourFR(dateOpStr);
    }
  }

  final op = OrangeModel.fromJSON(itemClean);
  await boxOps.add(op);
}


  // 🔍 Debug : Afficher le contenu de todobos2
  print("📦 Entreprises Hive:");
  boxEnt.values.forEach((e) {
    print(" • ${e.numeroTelEntreprise}, ${e.emailEntreprise}");
  });

  // 🔍 Debug : Afficher le contenu de todobos7
  print("📦 Utilisateurs Hive:");
  boxUser.values.forEach((u) {
    print(" • ${u.numeroaleatoire}, ${u.numauto}");
  });

  // 🔁 Debug valeurs reçues de l’API
  final apiNumeroTel = data.first['numeroTelEntreprise']?.toString().trim().toLowerCase() ?? '';
  final apiEmail = data.first['emailEntreprise']?.toString().trim().toLowerCase() ?? '';
  final apiNumeroAlea = data.first['numeroaleatoire']?.toString().trim().toLowerCase() ?? '';

  print("🔁 API Entreprise: $apiNumeroTel, $apiEmail");
  print("🔁 API Utilisateur: $apiNumeroAlea");

  // ✅ Vérifie si l’entreprise existe déjà
  final entrepriseExiste = boxEnt.values.any((e) =>
    e.numeroTelEntreprise.trim().toLowerCase() == apiNumeroTel &&
    e.emailEntreprise.trim().toLowerCase() == apiEmail
  );

  if (!entrepriseExiste) {
    final entreprise = EntrepriseModel(
      idEntreprise: data.first['idEntreprise'] is int
          ? data.first['idEntreprise']
          : int.tryParse(data.first['idEntreprise'].toString()) ?? 0,
      NomEntreprise: data.first['NomEntreprise']?.toString() ?? '',
      DirecteurEntreprise: data.first['DirecteurEntreprise']?.toString() ?? '',
      DateControle: convertirDatePourFR(data.first['dateoperation'].toString()), // format dd/MM/yyyy pour affichage
      numeroTelEntreprise: data.first['numeroTelEntreprise']?.toString() ?? '',
      emailEntreprise: data.first['emailEntreprise']?.toString() ?? '',
    );
    await boxEnt.add(entreprise);
    print("✅ Entreprise ajoutée !");
  } else {
    print("✅ Entreprise déjà existante.");
  }

  // ✅ Vérifie si l’utilisateur existe déjà
  final userExiste = boxUser.values.any((u) =>
    u.numeroaleatoire.trim().toLowerCase() == apiNumeroAlea
  );

  if (!userExiste) {
    final user = UsersKeyModel(
      numauto: data.first['numauto'] is int
          ? data.first['numauto']
          : int.tryParse(data.first['numauto'].toString()) ?? 0,
      numeroaleatoire: data.first['numeroaleatoire']?.toString() ?? '',
    );
    await boxUser.add(user);
    print("✅ Utilisateur ajouté !");
  } else {
    print("✅ Utilisateur déjà existant.");
  }

  showAlertDialog(context, "✅ Données importées avec succès.");
}
