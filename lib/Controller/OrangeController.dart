// OrangeController.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:url_launcher/url_launcher.dart';

class OrangeController {

  // Clé globale pour le formulaire
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static const platform = MethodChannel('com.example.kadoustransfert/call');

   // Boîte Hive pour stocker les dépôts
  Box<OrangeModel>? todobos;

 //liste des operations
   final List<OrangeModel> _deposList;
   OrangeController(this._deposList);
 

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
  TextEditingController montantController = TextEditingController();
  TextEditingController numeroTelephoneController = TextEditingController();
  TextEditingController infoClientController = TextEditingController();
  TextEditingController typeOperationController = TextEditingController(text: '1'); // Valeur par défaut pour le Type Opération orange depos =1
  TextEditingController operateurController = TextEditingController(text: '1'); // Valeur par défaut pour l'Opérateur orange
  TextEditingController supprimerController = TextEditingController(text: '0'); // Valeur par défaut pour pas supprimer par defaut
  TextEditingController iddetteController = TextEditingController(text: '0'); // Valeur par défaut pour pas supprimer par defaut
 
 // Image sélectionnée et texte reconnu
  XFile? selectedImage;
  String recognizedText = '';


// Méthode pour initialiser les données
  Future<void> initializeData() async {
    //Hive.registerAdapter(OrangeModelAdapter()); // Enregistrer l'adaptateur
    todobos = await Hive.openBox<OrangeModel>("todobos");
    _initializeIdOperation();
    _initializeDateOperation();
  }

// Initialiser l'ID de l'opération
  void _initializeIdOperation() {
    if (todobos != null && todobos!.isNotEmpty) {
      final lastDepos = todobos!.values.last;
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
    }
    // Implémentez ici la logique de sauvegarde des données mises à jour
  }



// Enregistrer les données dans la boîte Hive
  Future<void> saveData() async {

    if (todobos != null) {
      await todobos!.put(depos.idoperation, depos).then((value) 
      { print("succes");});
    }
    else{
         print("erreur");
    }
  }

 // Réinitialiser les champs du formulaire
  void resetFormFields() {
    selectedImage = null;
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
  if (formKey.currentState!.validate()) {
    String montant = montantController.text;  // Utilisez le TextEditingController pour obtenir la valeur du montant
    String number = numeroTelephoneController.text;  // Utilisez le TextEditingController pour obtenir le numéro de téléphone
    String codeD = "*144*1*4*";

    // Encodage des parties individuellement sans encoder le #
    String encodedCodeD = Uri.encodeComponent(codeD);
    String encodedNumber = Uri.encodeComponent(number);
    String encodedMontant = Uri.encodeComponent(montant);

    // Assembler les composants encodés avec #
    String encodedResultat = "$encodedCodeD$encodedNumber*$encodedMontant%23"; // Utiliser %23 pour le #

    // Utiliser MethodChannel pour lancer l'appel
    const platform = MethodChannel('com.example.kadoustransfert/call');

    try {
      await platform.invokeMethod('callNumber', {'number': encodedResultat});
    } on PlatformException catch (e) {
      print("Failed to make call: '${e.message}'.");
    }
  }
}


// Demander la permission d'appeler
void requestCallPermission() async {
  var status = await Permission.phone.request();
  if (status.isGranted) {
    // La permission est accordée, effectuez l'appel téléphonique
    fonctionDepos();
  } else {
    // La permission n'est pas accordée, affichez un message à l'utilisateur
    print('Permission refusée pour faire un appel téléphonique');
  }
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


//Méthode pour charger les données depuis la boîte Hive
   Future<List<OrangeModel>> loadData() async {
    List<OrangeModel> deposits = [];
    // Vérifier si la boîte Hive a été initialisée
    if (todobos != null) {
      // Charger les données de la boîte Hive
      deposits = await _loadDeposFromHive();
    }
    return deposits;
  }

// Reconnaître le texte à partir de l'image
  Future<void> recognizeText(InputImage inputImage) async {
    final textRecognizer = GoogleMlKit.vision.textRecognizer();

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    if (recognizedText.blocks.isEmpty) {
      print('Aucun texte n\'a été reconnu.');
      this.recognizedText = '';
      updateDepos(infoClient: '');
      return;
    }

    String extractedText = '';

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        extractedText += line.text + '\n';
        print('Texte reconnu : ${line.text}');
      }
    }

    this.recognizedText = extractedText;
    infoClientController.text = extractedText;
    updateDepos(infoClient: extractedText);
  }




}