import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> copyFileToDownloadDirectory() async {
  try {
    // Demander les autorisations
    if (await Permission.storage.request().isGranted) {
      // Récupérer le répertoire de stockage externe
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        print('Impossible de récupérer le répertoire de stockage externe.');
        return;
      }

      // Chemin complet du fichier source (data_export.json)
      String sourceFilePath = '${externalDir.path}/data_export.json';

      // Vérifier si le fichier source existe
      File sourceFile = File(sourceFilePath);
      if (!(await sourceFile.exists())) {
        print('Le fichier source $sourceFilePath n\'existe pas.');
        return;
      }

      // Répertoire de téléchargement de l'émulateur Android
      Directory downloadsDir = Directory('/storage/emulated/0/Download');

      // Vérifier et créer le répertoire de destination s'il n'existe pas
      if (!(await downloadsDir.exists())) {
        await downloadsDir.create(recursive: true);
      }

      // Chemin complet de destination
      String destinationFilePath = '${downloadsDir.path}/data_export.json';

      // Copier le fichier
      await sourceFile.copy(destinationFilePath);
      print('Fichier copié avec succès vers : $destinationFilePath');
    } else {
      print('Les autorisations de stockage ont été refusées.');
    }
  } catch (e) {
    print('Erreur lors de la copie du fichier : $e');
  }
}
