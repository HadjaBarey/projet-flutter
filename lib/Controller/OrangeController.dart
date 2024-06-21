// OrangeController.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'call_service.dart'; // Importez le service d'appel


class OrangeController {

  // Clé globale pour le formulaire
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController infoClientController = TextEditingController();
  final TextEditingController montantController = TextEditingController();
  final TextEditingController numeroTelephoneController = TextEditingController();

   // Instance du service d'appel
  final CallService callService = CallService();


  static const platform = MethodChannel('com.example.kadoustransfert/call');

   // Boîte Hive pour stocker les dépôts
  Box<OrangeModel>? todobos;

 //liste des operations
   final List<OrangeModel> _deposList;
   //OrangeController(this._deposList);
//initializeData();

 OrangeController(this._deposList) {
    _initializeBox();
    initializeData();
  }

   // Instance de OrangeModel
  OrangeModel depos = OrangeModel(
    idoperation: 0,
    dateoperation: '',
    montant: '',
    numeroTelephone: '',
    infoClient: '',
    typeOperation: 0,
    operateur: '1',
    supprimer: 0,
    iddette: 0,
  );

 // Contrôleurs pour les champs de saisie
  TextEditingController idOperationController = TextEditingController();
  TextEditingController dateOperationController = TextEditingController();
 // TextEditingController montantController = TextEditingController();
  //TextEditingController numeroTelephoneController = TextEditingController();
  // TextEditingController infoClientController = TextEditingController();
  TextEditingController typeOperationController = TextEditingController(text: '1'); // Valeur par défaut pour le Type Opération orange depos =1
  TextEditingController operateurController = TextEditingController(text: '1'); // Valeur par défaut pour l'Opérateur orange
  TextEditingController supprimerController = TextEditingController(text: '0'); // Valeur par défaut pour pas supprimer par defaut
  TextEditingController iddetteController = TextEditingController(text: '0'); // Valeur par défaut pour pas supprimer par defaut
 
 

    Future<void> _initializeBox() async {
    if (!Hive.isBoxOpen("todobos")) {
      todobos = await Hive.openBox<OrangeModel>("todobos");
    } else {
      todobos = Hive.box<OrangeModel>("todobos");
    }
  }


//Méthode pour charger les données depuis la boîte Hive
  Future<List<OrangeModel>> loadData() async {

    List<OrangeModel> deposits = [];
    if (todobos != null) {
      deposits = await _loadDeposFromHive();
    }
    return deposits;
  }


// Méthode pour initialiser les données
Future<List<OrangeModel>> initializeData() async {
    if (!Hive.isBoxOpen("todobos")) {
      todobos = await Hive.openBox<OrangeModel>("todobos");
    } else {
      todobos = Hive.box<OrangeModel>("todobos");
    }
     await _initializeBox();
    _initializeIdOperation();
    _initializeDateOperation();
    return loadData();
  }



// Initialiser l'ID de l'opération
void _initializeIdOperation() {
  if (todobos != null && todobos!.isNotEmpty) {
    // Trie les valeurs de todobos par idoperation et récupère la dernière
    final sortedDepos = todobos!.values.toList()
      ..sort((a, b) => a.idoperation.compareTo(b.idoperation));
    final lastDepos = sortedDepos.last;
    depos.idoperation = lastDepos.idoperation + 1;
  } else {
    depos.idoperation = 1;
  }
  idOperationController.text = depos.idoperation.toString();
}


// Initialiser la date de l'opération
  void _initializeDateOperation() {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    depos.dateoperation = currentDate;
    dateOperationController.text = currentDate;
  }


 // enregistrer les données de dépôt
  void updateDepos({
    int? idoperation,
    String? dateoperation,
    String? montant,
    String? numeroTelephone,
    String? infoClient,
    int? typeOperation,
    String? operateur,
    int? supprimer,
    int? iddette,
  }) {
    if (idoperation != null) depos.idoperation = idoperation;
    if (dateoperation != null) depos.dateoperation = dateoperation;
    if (montant != null) depos.montant = montant;
    if (numeroTelephone != null) depos.numeroTelephone = numeroTelephone;
    if (infoClient != null) depos.infoClient = infoClient;
    if (typeOperation != null) depos.typeOperation = typeOperation;
    if (operateur != null) depos.operateur = operateur;
    if (supprimer != null) depos.supprimer = supprimer;
    if (iddette != null) depos.iddette = iddette;
  }



   Future<void> updateDeposInHive(OrangeModel updatedDepos) async {
    await _initializeBox(); // S'assurer que la boîte est ouverte
    if (todobos != null) {
      await todobos!.put(updatedDepos.idoperation, updatedDepos).then((value) {
       // print("Mise à jour réussie : $updatedDepos");
      }).catchError((error) {
       // print("Erreur lors de la mise à jour : $error");
      });
    } else {
    //  print("Boîte Hive non initialisée");
    }
  }


// Mettre à jour les données d'un dépôt
  void updateDeposData({
    required OrangeModel depos,
    required String montant,
    required String numeroTelephone,
    required String infoClient,
  }) {
    // Recherchez le dépôt à mettre à jour dans la liste
    int index = _deposList.indexWhere((element) => element.idoperation == depos.idoperation);
    if (index != -1) {
      // Si le dépôt est trouvé, mettez à jour ses données
      _deposList[index] = OrangeModel(
        idoperation: depos.idoperation,
        dateoperation: depos.dateoperation,
        montant: montant,
        numeroTelephone: numeroTelephone,
        infoClient: infoClient,
        typeOperation: depos.typeOperation,
        operateur: depos.operateur,
        supprimer: depos.supprimer,
        iddette: depos.iddette,
      );
        // Sauvegarder les modifications dans Hive
        updateDeposInHive(_deposList[index]);
    }
    // Implémentez ici la logique de sauvegarde des données mises à jour
  }



// Enregistrer les données dans la boîte Hive
Future<void> saveData() async {
 // await _initializeBox(); // S'assurer que la boîte est ouverte
  if (todobos != null) {
    await todobos!.put(depos.idoperation, depos).then((value) {
      print("Enregistrement réussi : $depos");
    }).catchError((error) {
      print("Erreur lors de l'enregistrement : $error");
    });
  } else {
    print("Boîte Hive non initialisée");
  }
}


 // Ajoutez cette méthode pour mettre à jour l'état "supprimer" dans Hive
  Future<void> markAsDeleted(OrangeModel depos) async {
    await _initializeBox(); // S'assurer que la boîte est ouverte
    if (todobos != null) {
      depos.supprimer = 1;
      await todobos!.put(depos.idoperation, depos).then((value) {
       // print("Dépôt marqué comme supprimé : $depos");
      }).catchError((error) {
      //  print("Erreur lors de la mise à jour : $error");
      });
    } else {
     // print("Boîte Hive non initialisée");
    }
  }

// Image sélectionnée et texte reconnu
  late XFile selectedImage;
  String recognizedText = '';

 // Réinitialiser les champs du formulaire
  void resetFormFields() {
    selectedImage ;
    recognizedText = '';
    formKey.currentState?.reset();
    depos = OrangeModel(
      idoperation: depos.idoperation + 1,
      dateoperation: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      montant: '',
      numeroTelephone: '',
      infoClient: '',
      typeOperation: 0,
      operateur: '',
      supprimer: 0,
      iddette: 0,
    );
    idOperationController.text = depos.idoperation.toString();
    dateOperationController.text = depos.dateoperation;
  }




// Fonction pour traiter le dépôt
void fonctionDepos() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
        String montant = montantController.text;
        String number = numeroTelephoneController.text;
        String codeD = "*144*1*4*";

        String encodedCodeD = Uri.encodeComponent(codeD);
        String encodedNumber = Uri.encodeComponent(number);
        String encodedMontant = Uri.encodeComponent(montant);

        String encodedResultat = "$encodedCodeD$encodedNumber*$encodedMontant%23";

        try {
           await callService.initiateCall(encodedResultat);
            //await platform.invokeMethod('chooseSim', {'number': encodedResultat});
        } on PlatformException catch (e) {
            print("Échec de la sélection de la SIM: '${e.message}'.");
        } catch (e) {
            print("Erreur inattendue lors de la sélection de la SIM: $e");
        }
    }
}




// Demander la permission d'appeler
void requestCallPermission() async {
    try {
        var status = await Permission.phone.request();
        if (status.isGranted) {
            fonctionDepos();
        } else {
            print('Permission refusée pour faire un appel téléphonique');
        }
    } catch (e) {
        print('Erreur lors de la demande de permission: $e');
    }
}


void _onPermissionGranted() {
  saveData();
  resetFormFields();
}


 // Sélectionner une image à partir de la caméra
  Future<void> pickImageCamera() async {
    var returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    selectedImage = XFile(returnedImage.path);
    final inputImage = InputImage.fromFilePath(returnedImage.path);
    await recognizeText(inputImage);
  }

// Méthode privée pour charger tous les dépôts à partir de la boîte Hive
   Future<List<OrangeModel>> _loadDeposFromHive() async {
    List<OrangeModel> deposits = [];
    // Parcourir tous les éléments de la boîte Hive
    for (var value in todobos!.values) {
      deposits.add(value);
    }
    return deposits;
  }


// Reconnaître le texte à partir de l'image

Future<void> recognizeText(InputImage inputImage) async {
  final textRecognizer = GoogleMlKit.vision.textRecognizer();

  final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

  if (recognizedText.blocks.isEmpty) {
    //print('Aucun texte n\'a été reconnu.');
    this.recognizedText = '';
    updateDepos(infoClient: '');
    return;
  }

  String extractedText = '';

  for (TextBlock block in recognizedText.blocks) {
    for (TextLine line in block.lines) {
      extractedText += line.text + '\n';
    }
  }

  // Extraction des informations spécifiques
  String nom = extractInfo(extractedText, r'Nom:\s*(.*)');
  String prenoms = extractInfo(extractedText, r'Prénoms:\s*(.*)');
  String delivreeLe = extractInfo(extractedText, r'Délivrée le:\s*(.*)');
  String reference = extractInfo(extractedText, r'\bB\d{5}\s\d{2}\b');

  // print('Nom: $nom');
  // print('Prénoms: $prenoms');
  // print('Délivrée le: $delivreeLe');
  // print('Référence: $reference');

  // Vérifiez si l'une des variables est vide et affichez un message d'erreur
  if (nom.isEmpty || prenoms.isEmpty || delivreeLe.isEmpty || reference.isEmpty) {
   // print('Erreur: Une ou plusieurs informations sont manquantes.');
    this.recognizedText = '';
    updateDepos(infoClient: 'Erreur: veuillez reprendre votre photo car une ou plusieurs informations sont manquantes.');
    return;
  }

    // Vérifiez si delivreeLe est une date valide
  if (!isValidDate(delivreeLe)) {
    //print('Erreur: La date de délivrance n\'est pas valide.');
    this.recognizedText = '';
    updateDepos(infoClient: 'Erreur: La date de délivrance n\'est pas valide.');
    return;
  }

  // Mettre à jour avec les informations spécifiques dans infoClient
  String infoClient = '$nom $prenoms / CNIB N° $reference du $delivreeLe';
  //print('TTT: $infoClient');
  // Mettre à jour les variables et appeler updateDepos
  this.recognizedText = extractedText;
  infoClientController.text = infoClient;
  updateDepos(infoClient: infoClient);
}

String extractInfo(String text, String pattern) {
  final regExp = RegExp(pattern, multiLine: true);
  final match = regExp.firstMatch(text);
  if (match != null) {
    return match.groupCount >= 1 ? match.group(1)?.trim() ?? '' : match.group(0)?.trim() ?? '';
  }
  return '';
}

bool isValidDate(String dateStr) {
  try {
    final dateFormat = DateFormat('dd/MM/yyyy'); // Assuming the date format is 'dd/MM/yyyy'
    dateFormat.parseStrict(dateStr);
    return true;
  } catch (e) {
    return false;
  }
}
   

}
