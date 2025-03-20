import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';

Future<void> saveDefaultEntrepriseModel() async {
  var box = await Hive.openBox<EntrepriseModel>('todobos2');

  String dateDuJour = DateFormat('dd/MM/yyyy').format(DateTime.now());

  EntrepriseModel defaultEntreprise = EntrepriseModel(
    idEntreprise: 1,
    NomEntreprise: 'KADOUS SOLUTIONS SARL',
    DirecteurEntreprise: 'OUEDRAOGO M.Kader',
    DateControle: dateDuJour,
    numeroTelEntreprise:"00000000",
    emailEntreprise:"entreprise@gmail.com",

  );

  // Vérifiez les valeurs avant la sauvegarde
  // print('Nom Entreprise: ${defaultEntreprise.NomEntreprise}');
  // print('Directeur Entreprise: ${defaultEntreprise.DirecteurEntreprise}');

  await box.put(1, defaultEntreprise);

  // Lire immédiatement après l'écriture
  // var storedData = box.get(1) as EntrepriseModel?;
  // print('ID Entreprise: ${storedData?.idEntreprise}');
  // print('Nom Entreprise: ${storedData?.NomEntreprise}');
  // print('Directeur Entreprise: ${storedData?.DirecteurEntreprise}');
  // print('Date Controle: ${storedData?.DateControle}');

  await box.close(); // Ferme la boîte pour s'assurer que les données sont écrites

 // print('Valeur par défaut enregistrée avec succès.');
}
