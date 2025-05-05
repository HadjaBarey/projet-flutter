import 'dart:convert';
import 'package:http/http.dart' as http;
class AuthKTransfert{
  static Future authBypass(data) async{
    var responsedata;
    try{
      String url="https://kadoussconnect.com/api/post.php";
      final json_data = json.encode(data);
      final heade1r={"Content-Type": "application/json; charset=utf-8"};
      print(json_data);
      final response = await http.post(Uri.parse((url)),headers:heade1r,body:json_data);
      if(response.statusCode==200){
        responsedata= jsonDecode(response.body);
      }else{
        print("mauvaise reques ${response.statusCode}");
      }
      return responsedata;
    }catch(e){
      print("Erreur de connexion $e");
    }
    //!return null;
  }
}

