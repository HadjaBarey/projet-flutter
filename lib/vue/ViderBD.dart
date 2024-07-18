import 'package:hive/hive.dart';
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/ClientModel.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';
import 'package:kadoustransfert/Model/OpTransactionModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
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

    await box1.clear();
    await box2.clear();
    await box3.clear();
    await box4.clear();
    await box5.clear();
    await box6.clear();
    await box7.clear();

    print('Toutes les boîtes Hive ont été vidées avec succès.');
  } catch (e) {
    print('Erreur lors du vidage des boîtes Hive : $e');
  }
}
