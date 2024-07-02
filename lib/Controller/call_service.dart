import 'package:flutter/services.dart';

class CallService {
  static const platform = MethodChannel('com.example.kadoustransfert/calls');

  Future<void> initiateCall(String number) async {
    try {
      await platform.invokeMethod('initiateCall', {'number': number});
    } on PlatformException catch (e) {
      print("Failed to initiate call: '${e.message}'.");
    }
  }
}
