import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService<TableP> {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<void> sendData(TableP model, Map<String, dynamic> Function(TableP) toJson) async {
  print("📤 Envoi des données : ${jsonEncode(toJson(model))}");
  
  var response = await http.post(
    Uri.parse(baseUrl),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(toJson(model)),
  );

  print("📥 Réponse HTTP ${response.statusCode} : ${response.body}");

  if (response.statusCode == 201) {
    print("✅ Données envoyées avec succès.");
  } else {
    print("❌ Erreur d'envoi : ${response.statusCode}");
  }
}

Future<List<TableP>> fetchData(TableP Function(Map<String, dynamic>) fromJson) async {
  print("📤 Récupération des données depuis $baseUrl");

  var response = await http.get(Uri.parse(baseUrl));

  print("📥 Réponse HTTP ${response.statusCode} : ${response.body}");

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => fromJson(item)).toList();
  } else {
    print("❌ Erreur de récupération : ${response.statusCode}");
    return [];
  }
}

}



