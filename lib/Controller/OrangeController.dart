import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'call_service.dart'; // Importez le service d'appel
import 'package:kadoustransfert/Controller/OpTransactionController.dart';
import 'package:kadoustransfert/Controller/AddSimController.dart';
import 'package:kadoustransfert/Model/ClientModel.dart';
import 'package:collection/collection.dart'; // Importez le package collection

class OrangeController {
  // Clé globale pour le formulaire
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController infoClientController = TextEditingController();
  final TextEditingController montantController = TextEditingController();
  final TextEditingController numeroTelephoneController = TextEditingController();

  // Instance du service d'appel
  final CallService callService = CallService();
  final OpTransactionController opTransactionController = OpTransactionController(); // Initialisez votre OpTransactionController
  final AddSimController LibOperateurController = AddSimController(); // Initialisez votre AddSimController

  static const platform = MethodChannel('com.example.kadoustransfert/call');

  // Boîte Hive pour stocker les dépôts
  Box<OrangeModel>? todobos;

  // Boîte Hive pour stocker les clients
  late Box<ClientModel> clientsBox;

  // Liste des opérations
  final List<OrangeModel> _deposList;

  OrangeController(this._deposList) {
    _initializeBox();
    initializeData();
    _initializeClientsBox();
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

  // Méthode pour charger les données depuis la boîte Hive
  Future<List<OrangeModel>> loadData() async {
    List<OrangeModel> deposits = [];
    if (todobos != null) {
      deposits = await _loadDeposFromHive();
    }
    return deposits;
  }

  // Méthode pour initialiser les données
  Future<List<OrangeModel>> initializeData() async {
    await _initializeBox();
    _initializeIdOperation();
    _initializeDateOperation();
    return loadData();
  }

  // Initialiser l'ID de l'opération
  void _initializeIdOperation() {
    if (todobos != null && todobos!.isNotEmpty) {
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

  // Mettre à jour les données de dépôt
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
        print("Mise à jour réussie : $updatedDepos");
      }).catchError((error) {
        print("Erreur lors de la mise à jour : $error");
      });
    } else {
      print("Boîte Hive non initialisée");
    }
  }

  // Mettre à jour les données d'un dépôt
  void updateDeposData({
    required OrangeModel depos,
    required String montant,
    required String numeroTelephone,
    required String infoClient,
  }) {
    int index = _deposList.indexWhere((element) => element.idoperation == depos.idoperation);
    if (index != -1) {
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
      updateDeposInHive(_deposList[index]);
    }
  }

  // Enregistrer les données dans la boîte Hive
  Future<void> saveData() async {
    await _initializeBox(); // S'assurer que la boîte est ouverte
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

  // Marquer comme supprimé
  Future<void> markAsDeleted(OrangeModel depos) async {
    await _initializeBox(); // S'assurer que la boîte est ouverte
    if (todobos != null) {
      depos.supprimer = 1;
      await todobos!.put(depos.idoperation, depos).then((value) {
        print("Dépôt marqué comme supprimé : $depos");
      }).catchError((error) {
        print("Erreur lors de la mise à jour : $error");
      });
    } else {
      print("Boîte Hive non initialisée");
    }
  }

  // Image sélectionnée et texte reconnu
  late XFile selectedImage;
  String recognizedText = '';

  // Réinitialiser les champs du formulaire
  void resetFormFields() {
    selectedImage = XFile('');
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

      String? codeD = opTransactionController.getCodeTransaction('1', '1');
      if (codeD == null) {
        print("CodeTransaction non trouvé pour Operateur=1 et TypeOperation=1");
        return;
      }

      String? CodeAg = LibOperateurController.getCodeAgent('Orange');
      if (CodeAg == null) {
        print("Libelle operateur non trouvé ");
        return;
      }

      String resultat = "$codeD*$number*$montant*$CodeAg#";
      print('RESULTAT AVANT ENCODAGE: $resultat');

      String encodedResultat = Uri.encodeComponent(resultat).replaceAll('%23', '#');
      print('RESULTAT ENCODÉ: $encodedResultat');

      try {
        await platform.invokeMethod('initiateCall', {'number': encodedResultat});
        await saveData(); // Enregistrer les données après le dépôt
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

  // void _onPermissionGranted() {
  //   saveData();
  //   resetFormFields();
  // }

  // Sélectionner une image à partir de la caméra
  Future<void> pickImageCamera() async {
    try {
      var returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if (returnedImage == null) return;
      selectedImage = XFile(returnedImage.path);
      final inputImage = InputImage.fromFilePath(returnedImage.path);
      await recognizeText(inputImage);
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Méthode privée pour charger tous les dépôts à partir de la boîte Hive
  Future<List<OrangeModel>> _loadDeposFromHive() async {
    List<OrangeModel> deposits = [];
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

    String nom = extractInfo(extractedText, r'Nom:\s*(.*)');
    String prenoms = extractInfo(extractedText, r'Prénoms:\s*(.*)');
    String delivreeLe = extractInfo(extractedText, r'Délivrée le:\s*(.*)');
    String reference = extractInfo(extractedText, r'\bB\d{5}\s\d{2}\b');

    print('Nom: $nom');
    print('Prénoms: $prenoms');
    print('Délivrée le: $delivreeLe');
    print('Référence: $reference');

    if (nom.isEmpty || prenoms.isEmpty || delivreeLe.isEmpty || reference.isEmpty) {
      this.recognizedText = '';
      updateDepos(infoClient: 'Erreur: veuillez reprendre votre photo car une ou plusieurs informations sont manquantes.');
      return;
    }

    if (!isValidDate(delivreeLe)) {
      this.recognizedText = '';
      updateDepos(infoClient: 'Erreur: La date de délivrance n\'est pas valide.');
      return;
    }

    String infoClient = '$nom $prenoms / CNIB N° $reference du $delivreeLe';
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


// Initialisez la boîte Hive pour les clients

Future<void> _initializeClientsBox() async {
  if (!Hive.isBoxOpen("todobos1")) {
    await Hive.openBox<ClientModel>("todobos1");
  }
  clientsBox = Hive.box<ClientModel>("todobos1");
}


  // Mettre à jour infoClientController en fonction du numéro de téléphone entré
  void updateInfoClientController() {
    String phoneNumber = numeroTelephoneController.text.trim();

    // Vérifiez si la boîte Hive des clients est initialisée
    if (clientsBox != null && clientsBox.isNotEmpty) {
      // Recherchez le client correspondant dans la boîte Hive
      var client = clientsBox.values.firstWhereOrNull(
        (client) => client.numeroTelephone == phoneNumber && client.supprimer==0
      );


       print('Numro verification: $phoneNumber');
       print('Numro verification: $client');

      // Si le client est trouvé, mettez à jour infoClientController avec l'identité du client
      if (client != null) {
        infoClientController.text = client.Identite;
      } else {
        infoClientController.text = ''; // Sinon, laissez le champ infoClientController vide
      }
    } else {
      print("Boîte Hive des clients non initialisée ou vide");
      // Vous pouvez gérer le cas où la boîte Hive n'est pas initialisée ou vide ici
    }
  }

}
