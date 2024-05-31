import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'homePage.dart';
import 'Model/OrangeModel.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Nécessaire pour utiliser Hive dans Flutter

  await Hive.initFlutter(); // Initialiser Hive

  // Enregistrer l'adaptateur pour OrangeModel
  Hive.registerAdapter(OrangeModelAdapter());

  await Hive.openBox<OrangeModel>('OrangeModelBox'); // Ouvrir la boîte (Box)

  runApp(MyApp());

  // Remarque : Ne pas fermer Hive ici, car l'application pourrait encore avoir besoin de lire/écrire dans la boîte
  // await Hive.close(); // Fermer Hive lorsque vous avez terminé
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
