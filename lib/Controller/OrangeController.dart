import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:kadoustransfert/Model/AddSimModel.dart';
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
import 'package:telephony/telephony.dart'; // Ajoute en haut avec les autres imports




class OrangeController {
  // Clé globale pour le formulaire
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController infoClientController = TextEditingController();
  final TextEditingController montantController = TextEditingController();
  final TextEditingController numeroTelephoneController = TextEditingController();
  final TextEditingController scanMessageController = TextEditingController();
  final TextEditingController idTransController = TextEditingController();
  final Telephony telephony = Telephony.instance;

  // Instance du service d'appel
  final CallService callService = CallService();
  final OpTransactionController opTransactionController = OpTransactionController(); // Initialisez votre OpTransactionController
  final AddSimController LibOperateurController = AddSimController(); // Initialisez votre AddSimController

  EntrepriseController entrepriseController = EntrepriseController();

  static const platform = MethodChannel('apps.kadous.kadoustransfert/call');

  // Boîte Hive pour stocker les dépôts
  Box<OrangeModel>? todobos;
  late Box<ClientModel> clientsBox;
  late Box<EntrepriseModel> EntrepriseBox;
  late Box<AddSimModel>  OperateurBox;

  int scan = 0;
  double diminution = 0.0;
  double augmentation = 0.0;

  // Setter pour la variable scan
  void setScan(int value) {
    scan = value;
  }


  int selectedOption = 1;
  

  // Contrôleurs pour les champs de saisie
  TextEditingController idOperationController = TextEditingController();
  TextEditingController dateOperationController = TextEditingController();
  TextEditingController typeOperationController = TextEditingController(text: '1');  
  TextEditingController operateurController = TextEditingController(text: '1'); // Valeur par défaut pour l'Opérateur orange
  TextEditingController supprimerController = TextEditingController(text: '0'); // Valeur par défaut pour pas supprimer par defaut
  TextEditingController iddetteController = TextEditingController(text: '0'); // Valeur par défaut pour pas supprimer par defaut
  TextEditingController numeroIndependantController = TextEditingController(); 

  // Assurez-vous que optionCreanceController est un ValueNotifier<bool>
  ValueNotifier<bool> optionCreanceController = ValueNotifier<bool>(false); // Utiliser ValueNotifier<bool>

 // Liste des opérateurs
   List<AddSimModel> operateurList = [];
   List<Map<String, String>> operateurOptions = [];


 // Liste des opérationsl 
  List<OrangeModel> _deposList;

  OrangeController(this._deposList, {bool isDepos = false}) {
    _initializeBox();
     initializeData();
    _initializeClientsBox();
  }

  // Instance de OrangeModel
  OrangeModel depos = OrangeModel(
    idoperation: 0,
    dateoperation: '',
    montant: '',
    numero_telephone: '',
    info_client: '',
    typeoperation: 0,
    operateur: '1',
    supprimer: 0,
    iddette: 0,
    optionCreance : false,
    scanmessage: '',
    numeroIndependant: '',
    idtrans: '',
  );

  
  

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
    await _initializeEntreprisesBox(); // Assurez-vous que la boîte EntrepriseBox est initialisée
    await entrepriseController.initializeBox(); // Initialisez également la boîte EntrepriseController
    await _initializeOperateursBox();
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

//gestion des option a cocher//////////
void updateSelectedOption(int value) {
  selectedOption = value;
  if (selectedOption == 1) {
    typeOperationController.text = '1';
    scanMessageController.text = '';
    numeroIndependantController.text = '';
    infoClientController.text = '';
    montantController.text = '';
    numeroTelephoneController.text = '';
    idTransController.text = '';
    optionCreanceController.value = false; // Mettez à jour la valeur directement
  } else if (selectedOption == 2) {
    typeOperationController.text = '2';
    scanMessageController.text = '';
    numeroIndependantController.text = '';
    infoClientController.text = '';
    montantController.text = '';
    numeroTelephoneController.text = '';
    idTransController.text = '';
    optionCreanceController.value = false; // Mettez à jour la valeur directement
  } else if (selectedOption == 3) {
    typeOperationController.text = '2';
    scanMessageController.text = 'Message Scanné';
    numeroIndependantController.text = '';
    infoClientController.text = '';
    montantController.text = '';
    numeroTelephoneController.text = '';
    idTransController.text = '';
    optionCreanceController.value = false; // Mettez à jour la valeur directement
  }
}


//////controle de la date /////////////
Future<void> DateControleRecupere() async {
  try {
    // Vérifier si la boîte est déjà ouverte
    if (!Hive.isBoxOpen("todobos2")) {
      await Hive.openBox<EntrepriseModel>("todobos2");
    }
    
    var EntrepriseBox = Hive.box<EntrepriseModel>("todobos2");
    
    if (EntrepriseBox.isEmpty) {
      dateOperationController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    } else {
      var entreprise = EntrepriseBox.values.last;
      
      if (entreprise != null) {
        try {
          if (entreprise.DateControle.isNotEmpty) {
            DateFormat dateFormat = DateFormat('dd/MM/yyyy');
            dateFormat.parseStrict(entreprise.DateControle);
            dateOperationController.text = entreprise.DateControle;
          } else {
            dateOperationController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
          }
        } catch (e) {
          //print("Erreur lors de la conversion de la date : $e");
          dateOperationController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
        }
      } else {
        dateOperationController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      }
    }
  } catch (e) {
    //print("Erreur dans DateControleRecupere: $e");
    dateOperationController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
  bool? optionCreance,
  String? scanMessage,
  String? numeroIndependant,
  String? idTrans,
}) {
  
  if (idoperation != null) depos.idoperation = idoperation;
  if (dateoperation != null) depos.dateoperation = dateoperation;
  if (montant != null) depos.montant = montant;
  if (numeroTelephone != null) depos.numero_telephone = numeroTelephone;
  if (infoClient != null) depos.info_client = infoClient;
  if (typeOperation != null) depos.typeoperation = typeOperation;
  if (operateur != null) depos.operateur = operateur;
  if (supprimer != null) depos.supprimer = supprimer;
  if (iddette != null) depos.iddette = iddette;
  if (optionCreance != null) depos.optionCreance = optionCreance;
  if (scanMessage != null) depos.scanmessage = scanMessage;
  if (numeroIndependant != null) depos.numeroIndependant = numeroIndependant;
  if (idTrans != null) depos.idtrans = idTrans;

}



 void updateOptionCreance(bool value) {
  depos.optionCreance = value;
  optionCreanceController.value = value; // Mettez à jour directement la valeur
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
    required String scanMessage,
    required String numeroIndependant,
    required String idTrans,
    required bool optionCreance,
    //required int typeOperation,

  }) {
    int index = _deposList.indexWhere((element) => element.idoperation == depos.idoperation);
    if (index != -1) {
      _deposList[index] = OrangeModel(
        idoperation: depos.idoperation,
        dateoperation: depos.dateoperation,
        montant: montant,
        numero_telephone: numeroTelephone,
        info_client: infoClient,
        typeoperation: depos.typeoperation,
        operateur: depos.operateur,
        supprimer: depos.supprimer,
        iddette: depos.iddette,
        optionCreance: optionCreance,  
        scanmessage :scanMessage,
        numeroIndependant :numeroIndependant,
        idtrans : idTrans,
      );
      updateDeposInHive(_deposList[index]);
    }
  }
  


  //Enregistrer les données dans la boîte Hive
  Future<void> saveData(BuildContext context) async {
  await _initializeBox(); // S'assurer que la boîte est ouverte
  if (todobos != null) {
    await todobos!.put(depos.idoperation, depos).then((value) {
      // Affichez le showDialog en cas de succès
       showErrorDialog(context, 'Opération enregistrée avec succès.');
    }).catchError((error) {
      // Affichez le showDialog en cas d'erreur
      showErrorDialog(context, 'Erreur lors de l\'enregistrement. Veuillez reprendre l\'opereration!');
    });
  }
}

  // Image sélectionnée et texte reconnu
  late XFile selectedImage;
  String recognizedText = '';
  String recognizedText2 = '';

  // Réinitialiser les champs du formulaire
  void resetFormFields() {
    selectedImage = XFile('');
    recognizedText = '';
    formKey.currentState?.reset();
    depos = OrangeModel(
      idoperation: depos.idoperation + 1,
      dateoperation: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      montant: '',
      numero_telephone: '',
      info_client: '',
      typeoperation: 0,
      operateur: '',
      supprimer: 0,
      iddette: 0,
      optionCreance: false,
      scanmessage: '',
      numeroIndependant: '',
      idtrans: '',
      
    );
    idOperationController.text = depos.idoperation.toString();
    dateOperationController.text = depos.dateoperation;
  }


  Future<List<OrangeModel>> _loadDeposFromHive() async {
  if (todobos == null || !todobos!.isOpen) {
    todobos = await Hive.openBox<OrangeModel>('todobos');
  }

  List<OrangeModel> deposits = [];
  for (var value in todobos!.values) {
    deposits.add(value);
  }
  return deposits;
}


Future<void> pickImageCamera(BuildContext context) async {
  try {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sélectionnez une option'),
          actions: [
            TextButton(
              child: Text('Message'),
              onPressed: () => Navigator.pop(context, ImageSource.camera),
            ),
            TextButton(
              child: Text('Galerie'),
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
            ),
            TextButton(
              child: Text('CNIB'),
              onPressed: () async {
                Navigator.pop(context, null); // ferme le modal sans source classique

                // Lance traitement spécifique CNIB
                final XFile? imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
                if (imageFile == null) return;

                final InputImage image = InputImage.fromFilePath(imageFile.path);
                final infos = await extraireNomDepuisCnib(context, image);

                if (infos.isEmpty) {
                  // Erreur déjà gérée dans extraireNomDepuisCnib
                  return;
                }

                final nomComplet = "${infos['nom']} ${infos['prenoms']}";

                await verifierDernierSms(
                  context,
                  nomComplet,
                  montantController,
                  numeroTelephoneController,
                  idTransController,
                  typeOperationController,
                  infoClientController,
                );

                // Remplir le champ infoClientController avec les infos CNIB
                infoClientController.text = "${infos['nom']} ${infos['prenoms']} - Ref: ${infos['reference']}";
              },
            ),
          ],
        );
      },
    );

    if (source == null) return; // Si CNIB ou annulation, on arrête ici

    final XFile? returnedImage = await ImagePicker().pickImage(source: source);
    if (returnedImage == null) return;

    final inputImage = InputImage.fromFilePath(returnedImage.path);

    if (scan == 2) {
      await recognizeText(context, inputImage);
    } else {
      await detecterText(context, inputImage);
    }
  } catch (e) {
    print("Erreur lors de la sélection de l'image : $e");
    showErrorDialog(context, 'Une erreur est survenue lors de la sélection de l\'image.');
  }
}


Future<Map<String, String>> extraireNomDepuisCnib(
  BuildContext context,
  InputImage inputImage,
) async {
  final textRecognizer = GoogleMlKit.vision.textRecognizer();
  final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

  if (recognizedText.blocks.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Aucun texte détecté")),
      );
    }
    return {};
  }

  String extractedText = '';
  for (TextBlock block in recognizedText.blocks) {
    for (TextLine line in block.lines) {
      extractedText += line.text + '\n';
    }
  }

  String nom = extractInfo(extractedText, r'Nom:\s*(.*)');
  String prenoms = extractInfo(extractedText, r'Prénoms:\s*(.*)');
  String reference = extractInfo(extractedText, r'\b(B\d+(\s?\d+)*)\b');

  if (nom.isEmpty || prenoms.isEmpty || reference.isEmpty) {
    if (context.mounted) {
      showErrorDialog(context, 'Veuillez reprendre votre photo car une ou plusieurs informations sont manquantes.');
    }
    return {};
  }

  return {
    "nom": nom,
    "prenoms": prenoms,
    "reference": reference,
  };
}



// Future<void> verifierDernierSms(
//   BuildContext context,
//   String nomScanne,
//   TextEditingController montantController,
//   TextEditingController numeroTelephoneController,
//   TextEditingController idTransController,
//   TextEditingController typeOperationController,
//   TextEditingController infoClientController,
// ) async {
//   // Fonction pour fusionner lignes et compacter espaces
//   String fusionnerLignesEtCompacterEspaces(String texte) {
//     String result = texte.replaceAll(RegExp(r'[\r\n]+'), ' ');
//     result = result.replaceAll(RegExp(r'\s+'), ' ');
//     return result.trim();
//   }

//   // 1) permission SMS
//   var status = await Permission.sms.status;
//   if (!status.isGranted) {
//     status = await Permission.sms.request();
//     if (!status.isGranted) {
//    //   _showMessageDialog(context, "Permission SMS refusée");
//       print('[MonApp] Permission SMS refusée');
//       return;
//     }
//   }
//   print('[MonApp] Permission SMS accordée');

//   // 2) récupérer SMS (triés du plus récent au plus ancien)
//   List<SmsMessage> messages = await telephony.getInboxSms(
//     columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
//     sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
//   );

//   print('[MonApp] Nombre total de SMS récupérés : ${messages.length}');

//   // 3) limiter aux 5 derniers
//   if (messages.length > 10) {
//     messages = messages.sublist(0, 10);
//   }

//   print('[MonApp] --- Les ${messages.length} SMS les plus récents ---');
//   for (int i = 0; i < messages.length; i++) {
//     final preview = messages[i].body != null
//         ? (messages[i].body!.length > 120 ? messages[i].body!.substring(0, 120) + '...' : messages[i].body)
//         : 'aucun corps';
//     print('[MonApp] SMS #$i : Expéditeur="${messages[i].address}", Message="$preview"');
//   }
//   print('[MonApp] ----------------------------------');

//   // 4) expéditeurs autorisés (tout en minuscules)
//   final expediteursAutorises = [
//     "+22676839388",
//     "orangemoney",
//     "orange money",
//     "orange-money",
//     "orange",
//   ].map((e) => e.toLowerCase()).toList();

//   SmsMessage? smsTrouve;
//   String bodyNormalise = '';

//   // 5) recherche du premier SMS valide
//   for (final sms in messages) {
//     final address = sms.address?.toLowerCase() ?? '';
//     String body = sms.body ?? '';

//     // Fusionner lignes et compacter espaces
//     body = fusionnerLignesEtCompacterEspaces(body);

//     final bodyLower = body.toLowerCase();

//     final bool fromAuthorized = expediteursAutorises.any((exp) => address.contains(exp));
//     final bool containsTransfer = bodyLower.contains('transfert recu') ||
//     bodyLower.contains('transfert de') ||
//     bodyLower.contains('vous avez transféré') ||
//     bodyLower.contains('transfert') ||
//     bodyLower.contains('vous avez reçu') ||
//     bodyLower.contains('vous avez recu') ||
//     bodyLower.contains('reçu') ||
//     bodyLower.contains('recu');

//     if (fromAuthorized && containsTransfer) {
//       smsTrouve = sms;
//       bodyNormalise = body;
//       print('[MonApp] SMS OrangeMoney trouvé (expéditeur="$address")');
//       break;
//     }
//   }

//   if (smsTrouve == null) {
//    // _showMessageDialog(context, "Aucun SMS OrangeMoney trouvé dans les 5 derniers messages.");
//     print('[MonApp] Aucun SMS OrangeMoney trouvé');
//     return;
//   }

//   print('[MonApp] SMS trouvé (body fusionné): $bodyNormalise');

//   // 6) vérification nom scanné (tolérance inversion prénom/nom)
//   final bodyLower = bodyNormalise.toLowerCase();
//   final tokensNom = nomScanne
//       .toLowerCase()
//       .split(RegExp(r'\s+'))
//       .where((t) => t.trim().length > 1)
//       .toList();

//   final bool nameMatches = tokensNom.isNotEmpty && tokensNom.any((t) => bodyLower.contains(t));

//   if (!nameMatches) {
//    // _showMessageDialog(context, "Le nom scanné ne correspond pas au SMS trouvé.");
//     print('[MonApp] Nom "$nomScanne" non trouvé dans le message');
//     return;
//   }
//   print('[MonApp] Nom "$nomScanne" trouvé dans le message');

//   // 7) Extraction des données via RegExp
//   //final regMontant = RegExp(r'(?:transfere|recu|de)\s*[\n\r]*\s*(\d+(?:[\.,]\d+)?)', multiLine: true);
//   final regMontant = RegExp(
//   r'(?:transfere|recu|reçu|vous avez recu|vous avez reçu)\s*([\d\s,]+(?:[.,]\d{1,2})?)',
//   caseSensitive: false,
// );

//   final regNumero = RegExp(r'(?:numero|du|au)\s*[\n\r]*\s*(\d{8})', multiLine: true);
//   final regId = RegExp(r'(?:ID\s*(?:Trans)?|Trans\s*ID?|Trans)\s*:\s*([A-Za-z0-9.,]{10,30})', multiLine: true);

//   final montantMatch = regMontant.firstMatch(bodyNormalise);
//   final numeroMatch = regNumero.firstMatch(bodyNormalise);
//   final idMatch = regId.firstMatch(bodyNormalise);

//   String montant = montantMatch?.group(1) ?? '';
//   String numero = numeroMatch?.group(1) ?? '';
//   String idTrans = idMatch?.group(1) ?? '';

//   // Nettoyage montant : retirer espaces et virgules
//   if (montantMatch != null) {
//     String montantTexte = montantMatch.group(1) ?? '';
//     String montantNettoye = montantTexte.replaceAll(',', '').replaceAll(' ', '');
//     double? montantDouble = double.tryParse(montantNettoye);
//     int montantInt = montantDouble != null ? montantDouble.floor() : 0;
//     montant = montantInt.toString();

//     // Optionnel : remplacer montant dans bodyNormalise (si besoin)
//     // bodyNormalise = bodyNormalise.replaceFirst(montantTexte, montant);
//   }

//   if (montant.isEmpty || numero.isEmpty || idTrans.isEmpty) {
//   //  _showMessageDialog(context, "Impossible d'extraire toutes les données du SMS.");
//     print('[MonApp] Extraction données échouée: montant="$montant", numéro="$numero", idTrans="$idTrans"');
//     return;
//   }
//   print('[MonApp] Extraction réussie: montant="$montant", numéro="$numero", idTrans="$idTrans"');

//   // 8) détection type opération
//   final lowerText = bodyNormalise.toLowerCase();
//   List<String> keywordsDepos = ['transfert de', 'vous avez transféré', 'envoyé', 'transfert'];
//   List<String> keywordsRetrait = ['vous avez reçu', 'recu', 'reçu', 'a reçu', 'crédit', 'retrait'];
//   List<String> keywordsSansCompte = ['sans compte', 'non client', 'envoi sans compte'];

//   int selectedOption = 0;
//   if (keywordsDepos.any((kw) => lowerText.contains(kw))) {
//     selectedOption = 1;
//   } else if (keywordsRetrait.any((kw) => lowerText.contains(kw))) {
//     selectedOption = 2;
//   } else if (keywordsSansCompte.any((kw) => lowerText.contains(kw))) {
//     selectedOption = 3;
//   }
//     // Mettre à jour le contrôleur et les champs
//     if (selectedOption != 0) {
//       updateSelectedOption(selectedOption); // ← met à jour les radios
//     }

//   // 9) vérification doublon Hive
//   final box = await Hive.openBox('transferts');
//   final existe = box.values.any((e) {
//     if (e is Map && e.containsKey('idTransaction')) {
//       return e['idTransaction'] == idTrans;
//     }
//     return false;
//   });

//   if (existe) {
// //    _showMessageDialog(context, "Ce transfert a déjà été enregistré.");
//     print('[MonApp] Transfert déjà enregistré (idTrans="$idTrans")');
//     return;
//   }

//   // 10) remplir contrôleurs
//   montantController.text = montant;
//   numeroTelephoneController.text = numero;
//   idTransController.text = idTrans;
//   scanMessageController.text = 'Message Scanné';
//   typeOperationController.text = selectedOption != 0 ? selectedOption.toString() : '';

//   print('[MonApp] Type Operation : ${typeOperationController.text}');

// //  _showMessageDialog(context, "Données récupérées avec succès.");
//   print('[MonApp] Données remplies avec succès');
// }


Future<void> verifierDernierSms(
  BuildContext context,
  String nomScanne,
  TextEditingController montantController,
  TextEditingController numeroTelephoneController,
  TextEditingController idTransController,
  TextEditingController typeOperationController,
  TextEditingController infoClientController,
) async {
  String fusionnerLignesEtCompacterEspaces(String texte) {
    String result = texte.replaceAll(RegExp(r'[\r\n]+'), ' ');
    result = result.replaceAll(RegExp(r'\s+'), ' ');
    return result.trim();
  }

  // 1) permission SMS
  var status = await Permission.sms.status;
  if (!status.isGranted) {
    status = await Permission.sms.request();
    if (!status.isGranted) {
      print('[MonApp] Permission SMS refusée');
      return;
    }
  }
  print('[MonApp] Permission SMS accordée');

  // 2) récupérer SMS (triés du plus récent au plus ancien)
  List<SmsMessage> messages = await telephony.getInboxSms(
    columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
    sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
  );

  if (messages.isEmpty) {
    print('[MonApp] Aucun SMS disponible');
    return;
  }

  print('[MonApp] Nombre total de SMS récupérés : ${messages.length}');

  // 3) limiter aux 10 derniers
  if (messages.length > 10) {
    messages = messages.sublist(0, 10);
  }

  // 4) expéditeurs autorisés
  final expediteursAutorises = [
    "+22676839388",
    "orangemoney",
    "orange money",
    "orange-money",
    "orange",
  ].map((e) => e.toLowerCase()).toList();

  // 5) filtrer par expéditeur autorisé + transfert + nom scanné
  final tokensNom = nomScanne
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((t) => t.trim().length > 1)
      .toList();

  List<SmsMessage> candidats = [];
  for (final sms in messages) {
    final address = sms.address?.toLowerCase() ?? '';
    String body = fusionnerLignesEtCompacterEspaces(sms.body ?? '');
    final bodyLower = body.toLowerCase();

    final bool fromAuthorized =
        expediteursAutorises.any((exp) => address.contains(exp));
    final bool containsTransfer =
        bodyLower.contains('transfert recu') ||
        bodyLower.contains('transfert de') ||
        bodyLower.contains('vous avez transféré') ||
        bodyLower.contains('transfert') ||
        bodyLower.contains('vous avez reçu') ||
        bodyLower.contains('vous avez recu') ||
        bodyLower.contains('reçu') ||
        bodyLower.contains('recu');

    final bool nameMatches =
        tokensNom.isNotEmpty && tokensNom.any((t) => bodyLower.contains(t));

    if (fromAuthorized && containsTransfer && nameMatches) {
      candidats.add(sms);
    }
  }

  if (candidats.isEmpty) {
    print('[MonApp] Aucun SMS correspondant au nom "$nomScanne" trouvé');
    return;
  }

  // 6) choisir le plus récent
  candidats.sort((a, b) => (b.date ?? 0).compareTo(a.date ?? 0));
  final smsTrouve = candidats.first;
  final bodyNormalise = fusionnerLignesEtCompacterEspaces(smsTrouve.body ?? '');

  print('[MonApp] SMS trouvé (plus récent) : $bodyNormalise');

  // 7) Extraction des données via RegExp
  final regMontant = RegExp(
    r'(?:transfere|recu|reçu|vous avez recu|vous avez reçu)\s*([\d\s,]+(?:[.,]\d{1,2})?)',
    caseSensitive: false,
  );
  final regNumero = RegExp(r'(?:numero|du|au)\s*[\n\r]*\s*(\d{8})', multiLine: true);
  final regId = RegExp(
    r'(?:ID\s*(?:Trans)?|Trans\s*ID?|Trans)\s*:\s*([A-Za-z0-9.,]{10,30})',
    multiLine: true,
  );

  final montantMatch = regMontant.firstMatch(bodyNormalise);
  final numeroMatch = regNumero.firstMatch(bodyNormalise);
  final idMatch = regId.firstMatch(bodyNormalise);

  String montant = montantMatch?.group(1) ?? '';
  String numero = numeroMatch?.group(1) ?? '';
  String idTrans = idMatch?.group(1) ?? '';

  if (montantMatch != null) {
    String montantNettoye =
        montant.replaceAll(',', '').replaceAll(' ', '');
    double? montantDouble = double.tryParse(montantNettoye);
    montant = montantDouble != null ? montantDouble.floor().toString() : '';
  }

  if (montant.isEmpty || numero.isEmpty || idTrans.isEmpty) {
    print('[MonApp] Extraction échouée');
    return;
  }

  print('[MonApp] Extraction réussie: montant="$montant", numéro="$numero", idTrans="$idTrans"');

  // 8) détection type opération
  final lowerText = bodyNormalise.toLowerCase();
  List<String> keywordsDepos = ['transfert de', 'vous avez transféré', 'envoyé', 'transfert'];
  List<String> keywordsRetrait = ['vous avez reçu', 'recu', 'reçu', 'a reçu', 'crédit', 'retrait'];
  List<String> keywordsSansCompte = ['sans compte', 'non client', 'envoi sans compte'];

  int selectedOption = 0;
  if (keywordsDepos.any((kw) => lowerText.contains(kw))) {
    selectedOption = 1;
  } else if (keywordsRetrait.any((kw) => lowerText.contains(kw))) {
    selectedOption = 2;
  } else if (keywordsSansCompte.any((kw) => lowerText.contains(kw))) {
    selectedOption = 3;
  }
  if (selectedOption != 0) {
    updateSelectedOption(selectedOption);
  }

  // 9) vérification doublon Hive
  final box = await Hive.openBox('transferts');
  final existe = box.values.any((e) {
    if (e is Map && e.containsKey('idTransaction')) {
      return e['idTransaction'] == idTrans;
    }
    return false;
  });
  if (existe) {
    print('[MonApp] Transfert déjà enregistré');
    return;
  }

  // 10) remplir contrôleurs
  montantController.text = montant;
  numeroTelephoneController.text = numero;
  idTransController.text = idTrans;
  scanMessageController.text = 'Message Scanné';
  typeOperationController.text = selectedOption != 0 ? selectedOption.toString() : '';

  print('[MonApp] Données remplies avec succès');
}



Future<int> detecterText(BuildContext context, InputImage inputImage) async {
  final textRecognizer = GoogleMlKit.vision.textRecognizer();
  try {
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    if (recognizedText.blocks.isEmpty) {
      scanMessageController.text = '';
      return 0;
    }

    String extractedMessage = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        extractedMessage += line.text + ' ';
      }
    }

    print("Texte extrait : $extractedMessage");

    // Expressions régulières
    RegExp montantRegExp = RegExp(r'(?:transfere|recu|de)\s*[\n\r]*\s*(\d+(?:[\.,]\d{-1})?)',multiLine: true);
    RegExp numeroRegExp = RegExp(r'(?:numero|du|au)\s*[\n\r]*\s*(\d{8})', multiLine: true);
    RegExp idTransRegExp = RegExp(r'(?:ID\s*(?:Trans)?|Trans\s*ID?|Trans)\s*:\s*([A-Za-z0-9.,]{10,30})', multiLine: true);

    Iterable<RegExpMatch> matchesTransfere = montantRegExp.allMatches(extractedMessage.replaceAll(',', '').replaceAll('.', ','));
    Iterable<RegExpMatch> matchesNumero = numeroRegExp.allMatches(extractedMessage);
    Iterable<RegExpMatch> matchesiDTrans = idTransRegExp.allMatches(extractedMessage);

    String montant = '';
    String numero = '';
    String trans = '';

    final montantMatch = matchesTransfere.isNotEmpty ? matchesTransfere.first : null;

    if (montantMatch != null) {
      String montantTexte = montantMatch.group(1) ?? '';

      // Nettoyage : supprimer virgules et espaces
      String montantNettoye = montantTexte.replaceAll(',', '').replaceAll(' ', '');

      double? montantDouble = double.tryParse(montantNettoye);
      int montantInt = montantDouble != null ? montantDouble.floor() : 0;

      montant = montantInt.toString();

      // Remplacer l'ancien montant (texte) dans le message par le montant entier
      extractedMessage = extractedMessage.replaceFirst(montantTexte, montant);
    }


    if (matchesNumero.isNotEmpty) {
      numero = matchesNumero.first.group(1) ?? '';
    }

    if (matchesiDTrans.isNotEmpty) {
      trans = matchesiDTrans.first.group(1) ?? '';
    }

    if (montant.isEmpty || numero.isEmpty) {
      montantController.text = '';
      numeroTelephoneController.text = '';
      scanMessageController.text = '';
      idTransController.text = '';
      showErrorDialog(context, 'Impossible de renseigner les champs. Veuillez réessayer.');
      return 0;
    }

    if (montantController.text.isEmpty && numeroTelephoneController.text.isEmpty) {
      montantController.text = montant;
      numeroTelephoneController.text = numero;
      idTransController.text = trans;
      updateInfoClientController();
      scanMessageController.text = 'Message Scanné';
    }

    if (montantController.text == montant && numeroTelephoneController.text == numero && idTransController.text == trans) {
      recognizedText2 = 'Message Scanné';
    } else {
      recognizedText2 = '';
    }

    // 💡 Détection type d'opération
    final lowerText = extractedMessage.toLowerCase();
    List<String> keywordsDepos = ['transfert de','Transfert de', 'vous avez transféré', 'envoyé', 'transfert'];
    List<String> keywordsRetrait = ['Vous avez reçu','Vous avez recu','recu', 'reçu', 'a reçu', 'crédit', 'retrait'];
    List<String> keywordsSansCompte = ['sans compte', 'non client', 'envoi sans compte'];

    if (keywordsDepos.any((kw) => lowerText.contains(kw))) {
      selectedOption = 1;
    } else if (keywordsRetrait.any((kw) => lowerText.contains(kw))) {
      selectedOption = 2;
    } else if (keywordsSansCompte.any((kw) => lowerText.contains(kw))) {
      selectedOption = 3;
    } else {
      selectedOption = 0;
    }

    // ✅ Mise à jour du champ avec la valeur réelle
    typeOperationController.text = selectedOption != 0 ? selectedOption.toString() : '';

  } catch (e) {
    if (!context.mounted) return 0; // ✅ Ajout ici aussi
    showErrorDialog(context, 'Veuillez reprendre votre photo SVP!');
    return 0;
  } finally {
    textRecognizer.close();
  }
  return 0;
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

  // Débogage : Afficher le texte extrait
  // print('Texte extrait : $extractedText');

  String nom = extractInfo(extractedText, r'Nom:\s*(.*)');
  String prenoms = extractInfo(extractedText, r'Prénoms:\s*(.*)');
  String reference = extractInfo(extractedText, r'\b(B\d+(\s?\d+)*)\b');

  // Extraire et trier toutes les dates au format français
  List<String> dateStrings = extractAllDates(extractedText, r'\b\d{2}/\d{2}/\d{4}\b');
  List<DateTime> dates = dateStrings.map((dateStr) => DateFormat('dd/MM/yyyy').parse(dateStr)).toList();
  dates.sort();

  // Récupérer l'avant-dernière date
  String delivreeLe = dates.length >= 2 ? DateFormat('dd/MM/yyyy').format(dates[dates.length - 2]) : '';

  // Débogage : Afficher les valeurs extraites
  // print('Nom : $nom');
  // print('Prénoms : $prenoms');
  // print('Délivrée le : $delivreeLe');
  // print('Référence : $reference');

  if (nom.isEmpty || prenoms.isEmpty || delivreeLe.isEmpty || reference.isEmpty) {
    this.recognizedText = '';
    showErrorDialog(context, 'Veuillez reprendre votre photo car une ou plusieurs informations sont manquantes.');
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

List<String> extractAllDates(String text, String pattern) {
  final regExp = RegExp(pattern);
  final matches = regExp.allMatches(text);
  List<String> dates = matches.map((match) => match.group(0)!).toList();
  return dates;
}

bool isValidDate(String dateStr) {
  try {
    if (dateStr.isEmpty) {
      return false;
    }
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    dateFormat.parseStrict(dateStr);
    return true;
  } catch (e) {
    return false;
  }
}


 Future<List<OrangeModel>> loadNonScannedData() async {
   List<OrangeModel> deposits = [];
    if (todobos != null) {
      deposits = await _loadDeposFromHive();
    }
    return deposits;
    // var box = await Hive.openBox<OrangeModel>('todobos');
    // return box.values.where((depos) => depos.scanMessage == '').toList();
  }


 Future<void> deleteDeposInHive(int idoperation) async {
    var box = await Hive.openBox<OrangeModel>('todobos');
    final Map<dynamic, OrangeModel> depositMap = box.toMap();
    dynamic keyToDelete;
    depositMap.forEach((key, value) {
      if (value.idoperation == idoperation) {
        keyToDelete = key;
      }
    });
    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }
  }


Future<void> deleteNonScannedDeposInHive(int idoperation) async {
  var box = await Hive.openBox<OrangeModel>('todobos');

  // Cherchez la clé correspondant à l'idoperation fourni
  dynamic keyToDelete;
  final List<dynamic> keys = box.keys.toList(); // Obtenez toutes les clés du box
  final List<int> intKeys = keys.cast<int>(); // Convertir en List<int>

  for (var key in intKeys) {
    final OrangeModel? value = box.get(key);
    if (value != null && value.idoperation == idoperation && value.scanmessage == '') {
      keyToDelete = key;
    //  print('Trouvé pour suppression - Clé: $key, Valeur: ${value.idoperation}');
      break; // Une fois trouvé, vous pouvez sortir de la boucle
    }
  }

  if (keyToDelete != null) {
   // print('Suppression de la clé: $keyToDelete');
    await box.delete(keyToDelete);
  } else {
 //   print('Aucun élément trouvé avec idoperation: $idoperation');
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


  void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(''),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


Future<void> _initializeAndLoadData() async {
    await _initializeBox();
    _deposList = await loadData();
   // print('Données initialisées: ${_deposList.length} éléments');
  }


// Votre méthode calculateSum avec chargement de données

Future<Map<String, Map<String, double>>> calculateSum(DateFormat dateFormat) async {
  // Assurez-vous que la date de contrôle est récupérée avant de continuer
  await DateControleRecupere();

  // Assurez-vous que les données sont chargées avant de continuer
  await _initializeAndLoadData();

  // Maps pour stocker les sommes regroupées par opérateur
  Map<String, double> diminution = {};
  Map<String, double> augmentation = {};

  // Filtrer les données en fonction de la date de contrôle récupérée et de scanMessage
  DateTime controlDate = dateFormat.parse(dateOperationController.text);

  _deposList = _deposList.where((item) {
    DateTime itemDate = dateFormat.parse(item.dateoperation);
    bool dateMatches = itemDate.year == controlDate.year &&
                       itemDate.month == controlDate.month &&
                       itemDate.day == controlDate.day;
    bool scanMessageMatches = item.scanmessage == 'Message Scanné';
    bool optionCreanceMatches = !item.optionCreance;

    return dateMatches && scanMessageMatches && optionCreanceMatches;
  }).toList();


  // Récupérer les opérateurs depuis Hive
  var box = await Hive.openBox<AddSimModel>('todobos5');
  List<AddSimModel> operateursList = box.values.toList();

  // Initialiser les clés pour les opérateurs récupérés depuis Hive
  for (AddSimModel operateur in operateursList) {
    String operateurKey = operateur.idOperateur.toString();
    diminution[operateurKey] = 0.0;
    augmentation[operateurKey] = 0.0;
  }


  // Vérifiez si _deposList est vide après filtrage
  if (_deposList.isEmpty) {
    //print('La liste _deposList est vide pour la date de contrôle et scanMessage.');
    return {
      'augmentation': {},
      'diminution': {},
    };
  } else {
    // Parcourez les éléments de _deposList pour calculer les sommes
    for (var item in _deposList) {
      double montant = double.tryParse(item.montant) ?? 0.0;
      String operateurKey = item.operateur;

      if (item.typeoperation == 1) {
        if (diminution.containsKey(operateurKey)) {
          diminution[operateurKey] = diminution[operateurKey]! + montant;
        } else {
          diminution[operateurKey] = montant;
        }
      } else if (item.typeoperation == 2) {
        if (augmentation.containsKey(operateurKey)) {
          augmentation[operateurKey] = augmentation[operateurKey]! + montant;
        } else {
          augmentation[operateurKey] = montant;
        }
      }
    }


    // Assurez-vous que les clés existent avant d'effectuer l'addition
    double diminutionTotal = diminution.values.fold(0.0, (sum, value) => sum + value);
    double augmentationTotal = augmentation.values.fold(0.0, (sum, value) => sum + value);

    // Ajoutez les valeurs des opérateurs et affectez-les à l'opérateur 100
    augmentation['100'] = diminutionTotal;
    diminution['100'] = augmentationTotal;

    // Retourner une map contenant les résultats sous forme de somme totale pour chaque opérateur
    return {
      'augmentation': augmentation,
      'diminution': diminution,
    };
  }
}


 Future<void> _initializeOperateursBox() async {
    if (!Hive.isBoxOpen("todobos5")) {
      await Hive.openBox<AddSimModel>("todobos5");
    }
    OperateurBox = Hive.box<AddSimModel>("todobos5");
    operateurList = OperateurBox.values.toList();
  }


 // Méthode pour définir la valeur par défaut
   void initializeOperateurController(String libOperateur) {
    final operateur = operateurList.firstWhere(
      (operateur) => operateur.LibOperateur == 'Unité Orange',
      orElse: () => AddSimModel(
        idOperateur: 0, 
        LibOperateur: "",
        NumPhone:"",
        CodeAgent:"",
        supprimer:0
        ), // Valeur par défaut
    );
    operateurController.text = operateur.idOperateur.toString();
  }


  
void AutresOperationsController() {

  final filteredList = operateurList.where((operateur) => 
    operateur.idOperateur != 1 && operateur.idOperateur != 2 && operateur.idOperateur != 100).toList();

  if (filteredList.isNotEmpty) {
    operateurOptions = filteredList.map((operateur) {
      return {
        'value': operateur.idOperateur.toString(),
        'label': operateur.LibOperateur,
      };
    }).toList();

    // Définir la première option comme sélectionnée
    operateurController.text = operateurOptions.isNotEmpty ? operateurOptions.first['value']! : '0';
  } else {
    // Gérer le cas où il n'y a pas d'options disponibles
    operateurOptions = [];
    operateurController.text = '0';
  }
}



Future<bool> VerificationIdTrans(BuildContext context) async {
  if (todobos == null || !todobos!.isOpen) {
     todobos = await Hive.openBox<OrangeModel>('todobos');
  }

   _deposList = todobos!.values.toList();
  
  // Afficher la taille de la liste pour s'assurer qu'elle contient des éléments
 // print('Taille de _deposList : ${_deposList.length}');

  // Utiliser le format correct pour analyser la date
  DateTime dateFiltrer = DateFormat('dd/MM/yyyy').parse(dateOperationController.text);
 // print('Date filtrée : $dateFiltrer');

  // Filtrer _deposList par date
  List<OrangeModel> filteredList = _deposList.where((item) {
    DateTime itemDate = DateFormat('dd/MM/yyyy').parse(item.dateoperation);
    //print('Comparaison avec item.dateoperation: $itemDate');
    bool dateMatches = itemDate.year == dateFiltrer.year &&
                       itemDate.month == dateFiltrer.month &&
                       itemDate.day == dateFiltrer.day;
    return dateMatches;
  }).toList();

 // print('Liste filtrée par date: $filteredList');

  // Récupérer la valeur de idTransController
  String idTransToCheck = idTransController.text;
//  print('ID Trans à vérifier: $idTransToCheck');

  // Filtrer les éléments dans la liste filtrée en fonction de l'idTrans
  for (var item in filteredList) {
  //  print('Comparaison avec item.idTrans: ${item.idTrans}');
    if (item.idtrans == idTransToCheck) {
      // Si une correspondance est trouvée, affichez le dialogue d'erreur et retourner false
      showErrorDialog(context, "Une transaction avec cet ID Trans existe déjà.");
     // print('ID Trans trouvé, retour false');
      return false;
    }
  }

  // Si aucune correspondance n'est trouvée, retourner true
 // print('Aucune correspondance trouvée, retour true');
  return true;
}








// Demander la permission d'appeler
//  void requestCallPermission(BuildContext context) async {
//   try {
//     var status = await Permission.phone.request();
//     if (status.isGranted) {
//       await saveData(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Permission refusée pour faire un appel téléphonique'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Erreur lors de la demande de permission: $e'),
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }
// }

//   void fonctionDepos(BuildContext context) async {

//   var Operateur = OperateurBox.values.firstWhereOrNull(
//       (Operateur) => Operateur.LibOperateur == 'Orange');

//       String? Operat = Operateur?.idOperateur.toString(); // Convertir en String si nécessaire

//       //print('tttttttttt: $Operat');

//   if (formKey.currentState != null && formKey.currentState!.validate()) {

//     String montant = montantController.text;
//     String number = numeroTelephoneController.text;

//     // String? codeD = opTransactionController.getCodeTransaction(Operat!, '1');
//     String? codeD = opTransactionController.getCodeTransaction('1', '1');
//     if (codeD == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('CodeTransaction non trouvé pour Operateur=1 et TypeOperation=1'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//       return;
//     }

//     String? CodeAg = LibOperateurController.getCodeAgent('Orange');
//     if (CodeAg == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Libelle operateur non trouvé'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//       return;
//     }

//     String resultat = "$codeD*$number*$montant*$CodeAg#";
//     String encodedResultat = Uri.encodeComponent(resultat).replaceAll('%23', '#');

//     try {
//       await platform.invokeMethod('initiateCall', {'number': encodedResultat});

//       // Supposant que la confirmation de transaction est détectée ici
//      // await waitForTransactionConfirmation(); // Implémentez cette méthode pour attendre la confirmation

//       await saveData(context); // Sauvegarde des données après la transaction réussie
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Opération réussie'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     } on PlatformException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Échec de la sélection de la SIM: '${e.message}'"),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Erreur inattendue lors de la sélection de la SIM: $e"),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }
// }



}
