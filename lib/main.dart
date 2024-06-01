import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'homePage.dart';
import 'Model/OrangeModel.dart';


void main() async {


  WidgetsFlutterBinding.ensureInitialized();// Nécessaire pour utiliser Hive dans Flutter
  await Hive.initFlutter();// Initialiser Hive
  Hive.registerAdapter(OrangeModelAdapter()); // Enregistrer l'adaptateur pour OrangeModel
  await Hive.openBox<OrangeModel>('todobos'); // Ouvrir la boîte (Box)
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
