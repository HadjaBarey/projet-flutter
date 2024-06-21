import 'package:flutter/services.dart';

class CallService {
  static const platform = MethodChannel('com.example.kadoustransfert/call');

  Future<void> initiateCall(String number) async {
    try {
      await platform.invokeMethod('initiateCall', {'number': number});
    } on PlatformException catch (e) {
      print("Échec de l'initialisation de l'appel: '${e.message}'.");
    }
  }
}
