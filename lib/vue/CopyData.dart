import 'dart:convert';
import 'dart:io';
import 'package:kadoustransfert/Model/AddSimModel.dart';
import 'package:kadoustransfert/Model/ClientModel.dart';
import 'package:kadoustransfert/Model/JournalCaisseModel.dart';
import 'package:kadoustransfert/Model/UtilisateurModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive/hive.dart';
import 'package:kadoustransfert/Model/OpTransactionModel.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
// Importez également les autres modèles comme ClientModel, etc.

Future<void> exportDataToJson() async {
  try {
    // Demander les autorisations de stockage
    if (await Permission.storage.request().isGranted) {

      // Supprimer le fichier existant (optionnel)
      File sourceFile = File('${(await getApplicationDocumentsDirectory()).path}/data_export.json');
      if (await sourceFile.exists()) {
        await sourceFile.delete();
      }
      
      // Ouvrir les différentes boîtes Hive
      final boxOrangeModel = await Hive.openBox<OrangeModel>('todobos');
      final boxClient = await Hive.openBox<ClientModel>('todobos1');
      final boxEntreprise = await Hive.openBox<EntrepriseModel>('todobos2');
      final boxTransaction = await Hive.openBox<OpTransactionModel>('todobos3');
      final boxUtilisateur = await Hive.openBox<UtilisateurModel>('todobos4');
      final boxAddSim = await Hive.openBox<AddSimModel>('todobos5');
      final boxJournalCaisse = await Hive.openBox<JournalCaisseModel>('todobos6');
      // Ouvrez les autres boîtes Hive ici pour les autres modèles

      // Récupérer toutes les données des boîtes Hive (par exemple, OpTransaction)
      List<Map<String, dynamic>> opOrangeData = boxOrangeModel.values.map((e) => e.toJson()).toList();
      List<Map<String, dynamic>> opClientData = boxClient.values.map((e) => e.toJson()).toList();
      List<Map<String, dynamic>> opentrepriseData = boxEntreprise.values.map((e) => e.toJson()).toList();
      List<Map<String, dynamic>> OpTransactionData = boxTransaction.values.map((e) => e.toJson()).toList();
      List<Map<String, dynamic>> OpUtilisateurtData = boxUtilisateur.values.map((e) => e.toJson()).toList();
      List<Map<String, dynamic>> OpAddSimData = boxAddSim.values.map((e) => e.toJson()).toList();
      List<Map<String, dynamic>> OpJournalCaisseData = boxJournalCaisse.values.map((e) => e.toJson()).toList();

      // Créer un objet JSON pour le fichier avec différentes sections (tables)
      Map<String, dynamic> data = {
        'todobos': opOrangeData,      
        'todobos1':opClientData,
        'todobos2': opentrepriseData,       
        'todobos3': OpTransactionData,    
        'todobos4': OpUtilisateurtData, 
        'todobos5': OpAddSimData,  
        'todobos6': OpJournalCaisseData, 
       
      };

      // Récupérer le répertoire des documents de l'application
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String sourceFilePath = '${appDocDir.path}/data_export.json';

      // Créer le fichier et y écrire les données JSON
      File newSourceFile = File(sourceFilePath);
      await newSourceFile.writeAsString(jsonEncode(data));
      print('Données exportées vers : $sourceFilePath');

      // Déplacer le fichier vers le répertoire de téléchargement
      Directory downloadsDir = Directory('/storage/emulated/0/Download');
      if (!(await downloadsDir.exists())) {
        await downloadsDir.create(recursive: true);
      }

      // Chemin complet de destination
      String destinationFilePath = '${downloadsDir.path}/data_export.json';

      // Copier le fichier vers le répertoire de téléchargement
      await newSourceFile.copy(destinationFilePath);
      print('Fichier copié vers : $destinationFilePath');
      
    } else {
      print('Les autorisations de stockage ont été refusées.');
    }
  } catch (e) {
    print('Erreur lors de l\'exportation des données : $e');
  }
}
