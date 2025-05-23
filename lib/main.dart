import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kadoustransfert/Model/UsersKeyModel.dart';
import 'package:kadoustransfert/vue/Connexion.dart';
import 'Model/JournalCaisseModel.dart';
import 'Model/AddSimModel.dart';
import 'Model/OpTransactionModel.dart';
import 'Model/UtilisateurModel.dart';
import 'Model/EntrepriseModel.dart';
import 'Model/ClientModel.dart';
import 'Model/OrangeModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Enregistrer vos adaptateurs Hive ici
  Hive.registerAdapter(OrangeModelAdapter());
  Hive.registerAdapter(ClientModelAdapter());
  Hive.registerAdapter(EntrepriseModelAdapter());
  Hive.registerAdapter(OpTransactionModelAdapter());
  Hive.registerAdapter(UtilisateurModelAdapter());
  Hive.registerAdapter(AddSimModelAdapter());
  Hive.registerAdapter(JournalCaisseModelAdapter());
  Hive.registerAdapter(UsersKeyModelAdapter());

  // Ouvrir les boîtes Hive nécessaires
  await Hive.openBox<OrangeModel>('todobos');
  await Hive.openBox<ClientModel>('todobos1');
  await Hive.openBox<EntrepriseModel>('todobos2');
  await Hive.openBox<OpTransactionModel>('todobos3');
  await Hive.openBox<UtilisateurModel>('todobos4');
  await Hive.openBox<AddSimModel>('todobos5');
  await Hive.openBox<JournalCaisseModel>('todobos6');
  await Hive.openBox<UsersKeyModel>('todobos7');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kadous Transfert',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Définir les locales prises en charge
      supportedLocales: [
        const Locale('fr', 'FR'), // Ajouter d'autres locales si nécessaire
      ],
      // Définir les délégués de localisation
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // Ajouter ce délégué
      ],
      home: LoginPage(),
    );
  }
}