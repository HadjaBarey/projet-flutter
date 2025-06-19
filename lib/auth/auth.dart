import 'dart:convert'; // Pour json.encode et jsonDecode
import 'dart:io'; // Pour HttpClient
import 'package:http/io_client.dart'; // Pour IOClient


class AuthKTransfert {
  static Future authBypass(data) async {
    var responsedata;
    try {
      String url = "https://kadoussconnect.com/api/post.php";
      final json_data = json.encode(data);
      final headers = {"Content-Type": "application/json; charset=utf-8"};
      print(json_data);

      // Bypass SSL vérification (temporaire uniquement)
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);

      final response = await ioClient.post(
        Uri.parse(url),
        headers: headers,
        body: json_data,
      );

      if (response.statusCode == 200) {
        responsedata = jsonDecode(response.body);
      } else {
        print("mauvaise requête ${response.statusCode}");
      }
      return responsedata;
    } catch (e) {
      print("Erreur de connexion $e");
    }
  }
}
