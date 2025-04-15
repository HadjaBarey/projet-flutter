import 'package:hive/hive.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';

Future<void> IntialiseCaisse() async {
  var box = await Hive.openBox<JournalCaisseModel>('todobos6');

  print('Taille de la boîte: ${box.length}');
  
  List<JournalCaisseModel> defaultCaisseEntries = [
    JournalCaisseModel(
      idjournal: 100,
      dateJournal: '16/04/2025',
      montantJ: '0',
      typeCompte: 'TRANSFERT',
      operateur: 'Orange BF',
    ),
    JournalCaisseModel(
      idjournal: 101,
      dateJournal: '16/04/2025',
      montantJ: '02020202',
      typeCompte: 'TRANSFERT',
      operateur: 'Moov SA',
    ),
  ];

  for (var entry in defaultCaisseEntries) {
    await box.add(entry);
  }

  print('Données ajoutées même si la boîte contenait déjà des éléments.');
}

