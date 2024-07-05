import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:kadoustransfert/Model/EntrepriseModel.dart';
import 'package:kadoustransfert/Model/OrangeModel.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'call_service.dart'; // Importez le service d'appel
import 'package:kadoustransfert/Controller/OpTransactionController.dart';
import 'package:kadoustransfert/Controller/AddSimController.dart';
import 'package:kadoustransfert/Model/ClientModel.dart';
import 'package:collection/collection.dart'; // Importez le package collection
import 'package:kadoustransfert/Controller/EntrepriseController.dart';

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

  EntrepriseController entrepriseController = EntrepriseController();

  static const platform = MethodChannel('com.example.kadoustransfert/call');

  // Boîte Hive pour stocker les dépôts
  Box<OrangeModel>? todobos;

  // Boîte Hive pour stocker les clients
  late Box<ClientModel> clientsBox;

    //Boîte Hive pour stocker EntrepriseModel
  late Box<EntrepriseModel> EntrepriseBox;

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
    optionCreance : false,
  );

  // Contrôleurs pour les champs de saisie
  TextEditingController idOperationController = TextEditingController();
  TextEditingController dateOperationController = TextEditingController();
  TextEditingController typeOperationController = TextEditingController();  
  TextEditingController operateurController = TextEditingController(text: '1'); // Valeur par défaut pour l'Opérateur orange
  TextEditingController supprimerController = TextEditingController(text: '0'); // Valeur par défaut pour pas supprimer par defaut
  TextEditingController iddetteController = TextEditingController(text: '0'); // Valeur par défaut pour pas supprimer par defaut
  TextEditingController optionCreanceController = TextEditingController(text: 'false'); // Valeur par défaut pour pas supprimer par defaut
  

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
    _initializeEntreprisesBox();
    DateControleRecupere();
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


 // Initialisez la boîte Hive pour entreprise

Future<void> _initializeEntreprisesBox() async {
  if (!Hive.isBoxOpen("todobos2")) {
    await Hive.openBox<EntrepriseModel>("todobos2");
  }
  EntrepriseBox = Hive.box<EntrepriseModel>("todobos2");
}


Future<void> DateControleRecupere() async {
  // Vérifiez si la boîte Hive des entreprises est initialisée
  if (EntrepriseBox != null && EntrepriseBox.isNotEmpty) {
    // Recherchez l'entreprise correspondante dans la boîte Hive
    var entreprise = EntrepriseBox.values.firstWhereOrNull(
      (entreprise) => entreprise.idEntreprise == 1);
    
    // Affichez les détails de l'entreprise
    //print('Entreprise trouvée : ${entreprise.toString()}');

    if (entreprise != null) {
      dateOperationController.text = entreprise.DateControle;
      //print('Date de contrôle récupérée : ${dateOperationController.text}');
    } else {
      dateOperationController.text = '';
      //print('Aucune entreprise trouvée avec l\'ID 1');
    }
  } else {
    print("Boîte Hive des entreprises non initialisée ou vide");
    // Vous pouvez gérer le cas où la boîte Hive n'est pas initialisée ou vide ici
  }
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
    bool? optionCreance, // Définissez 'optionCreance' comme un paramètre nommé
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
    if (optionCreance != null) {depos.optionCreance = optionCreance;
  }
  }

  void updateOptionCreance(bool value) {
  depos.optionCreance = value;
  optionCreanceController.text = value.toString();
  updateDepos(optionCreance: value);
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
     // print("Boîte Hive non initialisée");
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
        optionCreance :depos.optionCreance,
      );
      updateDeposInHive(_deposList[index]);
    }
  }

  // Enregistrer les données dans la boîte Hive
  Future<void> saveData(BuildContext context) async {
  await _initializeBox(); // S'assurer que la boîte est ouverte
  if (todobos != null) {
    await todobos!.put(depos.idoperation, depos).then((value) {
      // Affichez le SnackBar en cas de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('opération enregistré avec Succès'),
          duration: Duration(seconds: 3),
        ),
      );
    }).catchError((error) {
      // Affichez le SnackBar en cas d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'enregistrement : $error'),
          duration: Duration(seconds: 3),
        ),
      );
    });
  } else {
    // Affichez le SnackBar si la boîte Hive n'est pas initialisée
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Boîte Hive non initialisée'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

  // Marquer comme supprimé
  Future<void> markAsDeleted(OrangeModel depos) async {
    await _initializeBox(); // S'assurer que la boîte est ouverte
    if (todobos != null) {
      depos.supprimer = 1;
      await todobos!.put(depos.idoperation, depos).then((value) {
        //print("Dépôt marqué comme supprimé : $depos");
      }).catchError((error) {
        //print("Erreur lors de la mise à jour : $error");
      });
    } else {
      //print("Boîte Hive non initialisée");
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
      optionCreance: false,
    );
    idOperationController.text = depos.idoperation.toString();
    dateOperationController.text = depos.dateoperation;
  }

  // Fonction pour traiter le dépôt
  void fonctionDepos(BuildContext context) async {
  if (formKey.currentState != null && formKey.currentState!.validate()) {
    String montant = montantController.text;
    String number = numeroTelephoneController.text;

    String? codeD = opTransactionController.getCodeTransaction('1', '1');
    if (codeD == null) {
      // CodeTransaction non trouvé
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CodeTransaction non trouvé pour Operateur=1 et TypeOperation=1'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    String? CodeAg = LibOperateurController.getCodeAgent('Orange');
    if (CodeAg == null) {
      // Libelle operateur non trouvé
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Libelle operateur non trouvé'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    String resultat = "$codeD*$number*$montant*$CodeAg#";
    // Encode le résultat
    String encodedResultat = Uri.encodeComponent(resultat).replaceAll('%23', '#');

    try {
      await platform.invokeMethod('initiateCall', {'number': encodedResultat});
      await saveData(context); // Enregistrer les données après le dépôt
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opération réussie'),
          duration: Duration(seconds: 3),
        ),
      );
    } on PlatformException catch (e) {
      // Échec de la sélection de la SIM
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Échec de la sélection de la SIM: '${e.message}'"),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Erreur inattendue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur inattendue lors de la sélection de la SIM: $e"),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}


  // Demander la permission d'appeler
 void requestCallPermission(BuildContext context) async {
  try {
    var status = await Permission.phone.request();
    if (status.isGranted) {
      fonctionDepos(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permission refusée pour faire un appel téléphonique'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur lors de la demande de permission: $e'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}


  // Sélectionner une image à partir de la caméra
  Future<void> pickImageCamera(BuildContext context) async {
  try {
    var returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    selectedImage = XFile(returnedImage.path);
    final inputImage = InputImage.fromFilePath(returnedImage.path);
    await recognizeText(context, inputImage);
  } catch (e) {
    // Gestion des erreurs
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
  Future<void> recognizeText(BuildContext context, InputImage inputImage) async {
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

  if (nom.isEmpty || prenoms.isEmpty || delivreeLe.isEmpty || reference.isEmpty) {
    this.recognizedText = '';
    updateDepos(infoClient: 'Erreur: veuillez reprendre votre photo car une ou plusieurs informations sont manquantes.');

    // Affichez le SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur: veuillez reprendre votre photo car une ou plusieurs informations sont manquantes.'),
        duration: Duration(seconds: 3), // Durée pendant laquelle le SnackBar est affiché
      ),
    );

    return;
  }

  if (!isValidDate(delivreeLe)) {
    this.recognizedText = '';
    updateDepos(infoClient: 'Erreur: La date de délivrance n\'est pas valide.');

    // Affichez le SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur: La date de délivrance n\'est pas valide.'),
        duration: Duration(seconds: 3), // Durée pendant laquelle le SnackBar est affiché
      ),
    );

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

    // Vérifiez si le numéro de téléphone est vide
      if (phoneNumber.isEmpty) {
        infoClientController.text = ''; // Vide infoClientController
        return; // Sortir de la méthode si le numéro est vide
      }


    // Vérifiez si la boîte Hive des clients est initialisée
    if (clientsBox != null && clientsBox.isNotEmpty) {
      // Recherchez le client correspondant dans la boîte Hive
      var client = clientsBox.values.firstWhereOrNull(
        (client) => client.numeroTelephone == phoneNumber && client.supprimer==0
      );

      // Si le client est trouvé, mettez à jour infoClientController avec l'identité du client
      if (client != null) {
        infoClientController.text = client.Identite;
      } else {
        infoClientController.text = ''; // Sinon, laissez le champ infoClientController vide
      }
    } else {
     // print("Boîte Hive des clients non initialisée ou vide");
      // Vous pouvez gérer le cas où la boîte Hive n'est pas initialisée ou vide ici
    }
  }


}
