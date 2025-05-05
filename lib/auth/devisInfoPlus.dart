import 'package:device_info_plus/device_info_plus.dart';

Future<String> getDeviceUUID() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  return androidInfo.id; // Ou un autre identifiant unique stable
}
