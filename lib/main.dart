import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/OpTransactionModel.dart';
import 'Model/EntrepriseModel.dart';
import 'Model/ClientModel.dart';
import 'homePage.dart';
import 'Model/OrangeModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Nécessaire pour utiliser Hive dans Flutter
  await Hive.initFlutter(); // Initialiser Hive
  

  // Enregistrer l'adaptateur pour OrangeModel
  Hive.registerAdapter(OrangeModelAdapter());
  
  // Enregistrer l'adaptateur pour ClientModel
  Hive.registerAdapter(ClientModelAdapter());

  // Enregistrer l'adaptateur pour EntrepriseModel
  Hive.registerAdapter(EntrepriseModelAdapter());

  // Enregistrer l'adaptateur pour AddSimModel
  Hive.registerAdapter(OpTransactionModelAdapter());



  // Ouvrir la boîte pour OrangeModel
  await Hive.openBox<OrangeModel>('todobos');
  
  // Ouvrir la boîte pour ClientModel
  await Hive.openBox<ClientModel>('todobos1');

  // Ouvrir la boîte pour EntrepriseModel
  await Hive.openBox<EntrepriseModel>('todobos2');

  // Ouvrir la boîte pour EntrepriseModel
  await Hive.openBox<OpTransactionModel>('todobos3');

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
