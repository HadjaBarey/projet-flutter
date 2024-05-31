import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kadoustransfert/homePage.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Nécessaire pour utiliser Hive dans Flutter

  // Initialiser Hive
  await Hive.initFlutter();

  // Ouvrir la boîte (Box)
  await Hive.openBox<OrangeModel>('OrangeModelBox');

  runApp(MyApp());

  // Fermer Hive lorsque vous avez terminé
  await Hive.close();
}


// void main() {
  
//   // Initialiser Hive
//   await Hive.initFlutter();

//   // Ouvrir la boîte (Box)
//   await Hive.openBox<OrangeModel>('OrangeModelBox');

//   runApp(MyApp());

//   // Fermer Hive lorsque vous avez terminé
//   await Hive.close();

//   // WidgetsFlutterBinding.ensureInitialized();
//   // final Document = await getApplicationCacheDirectory();
//   // Hive.init(Document.path);

// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const HomePage(),
    );
  }
}

