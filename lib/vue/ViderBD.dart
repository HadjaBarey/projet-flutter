import 'package:hive/hive.dart';
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/ClientModel.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';
import 'package:kadoustransfert/Model/OpTransactionModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:kadoustransfert/Model/UsersKeyModel.dart';
import 'package:kadoustransfert/Model/UtilisateurModel.dart';

Future<void> ViderBDPage() async {
  try {
    final box1 = await Hive.openBox<OrangeModel>('todobos');
    final box2 = await Hive.openBox<ClientModel>('todobos1');
    final box3 = await Hive.openBox<EntrepriseModel>('todobos2');
    final box4 = await Hive.openBox<OpTransactionModel>('todobos3');
    final box5 = await Hive.openBox<UtilisateurModel>('todobos4');
    final box6 = await Hive.openBox<AddSimModel>('todobos5');
    final box7 = await Hive.openBox<JournalCaisseModel>('todobos6');
    final box8 = await Hive.openBox<UsersKeyModel>('todobos7');

    print('Ouverture des boîtes réussie.');

    // Vérification avant vidage
    // print('Contenu de todobos avant vidage: ${box1.values}');
    // print('Contenu de todobos1 avant vidage: ${box2.values}');
    // print('Contenu de todobos2 avant vidage: ${box3.values}');
    // print('Contenu de todobos3 avant vidage: ${box4.values}');
    // print('Contenu de todobos4 avant vidage: ${box5.values}');
    // print('Contenu de todobos5 avant vidage: ${box6.values}');
    // print('Contenu de todobos6 avant vidage: ${box7.values}');
      print('Contenu de todobos6 avant vidage: ${box8.values}');

    await box1.clear();
   // print('Boîte todobos vidée.');

    await box2.clear();
  //  print('Boîte todobos1 vidée.');

    await box3.clear();
   // print('Boîte todobos2 vidée.');

    await box4.clear();
  //  print('Boîte todobos3 vidée.');

    await box5.clear();
   // print('Boîte todobos4 vidée.');

    await box6.clear();
   // print('Boîte todobos5 vidée.');

    await box7.clear();
   // print('Boîte todobos6 vidée.');

    await box8.clear();
   // print('Boîte todobos7 vidée.');

    // Vérification après vidage
    // print('Contenu de todobos après vidage: ${box1.values}');
    // print('Contenu de todobos1 après vidage: ${box2.values}');
    // print('Contenu de todobos2 après vidage: ${box3.values}');
    // print('Contenu de todobos3 après vidage: ${box4.values}');
    // print('Contenu de todobos4 après vidage: ${box5.values}');
    // print('Contenu de todobos5 après vidage: ${box6.values}');
    // print('Contenu de todobos6 après vidage: ${box7.values}');

 //   print('Toutes les boîtes Hive ont été vidées avec succès.');
  } catch (e) {
  //  print('Erreur lors du vidage des boîtes Hive : $e');
  }
}
