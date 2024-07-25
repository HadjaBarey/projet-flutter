import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kadoustransfert/Model/ClientModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ClientController {
  final formKey = GlobalKey<FormState>();
  late Box<ClientModel> todobos1;

  ClientController() {
    initializeBox();
  }

  TextEditingController idClientController = TextEditingController();
  TextEditingController identiteController = TextEditingController();
  TextEditingController refCNIBController = TextEditingController();
  TextEditingController numeroTelephoneController = TextEditingController();
  TextEditingController supprimerController = TextEditingController(text: '0');

  ClientModel client = ClientModel(
    idClient: 0,
    Identite: '',
    RefCNIB: '',
    numeroTelephone: '',
    supprimer: 0,
  );


  // Image sélectionnée et texte reconnu
  late XFile selectedImage;
  String recognizedText = '';

  void resetFormFields() {
    selectedImage = XFile('');
    recognizedText = '';
    formKey.currentState?.reset();
    client = ClientModel(
      idClient: client.idClient + 1,
      RefCNIB: '',
      Identite: '',
      numeroTelephone: '',
      supprimer: 0,
    );
    idClientController.text = client.idClient.toString();
    identiteController.clear();
    refCNIBController.clear();
    numeroTelephoneController.clear();
  }

  void _initializeClientId() {
    if (todobos1.isNotEmpty) {
      final sortedClients = todobos1.values.toList()
        ..sort((a, b) => a.idClient.compareTo(b.idClient));
      final lastClient = sortedClients.last;
      client.idClient = lastClient.idClient + 1;
    } else {
      client.idClient = 1;
    }
    idClientController.text = client.idClient.toString();
  }

  Future<void> initializeBox() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(ClientModelAdapter().typeId)) {
      Hive.registerAdapter(ClientModelAdapter());
    }
    todobos1 = await Hive.openBox<ClientModel>("todobos1");
    _initializeClientId();
  }

  Future<List<ClientModel>> loadData() async {
    if (todobos1.isEmpty) {
      return [];
    }
    return todobos1.values.toList();
  }

void updateClient({
  int? idClient,
  String? identite,
  String? refCNIB,
  String? numeroTelephone,
  int? supprimer,
}) {
  print('UpdateClient called with: $idClient, $identite, $refCNIB, $numeroTelephone, $supprimer');
  if (idClient != null) client.idClient = idClient;
  if (identite != null) client.Identite = identite;
  if (refCNIB != null) client.RefCNIB = refCNIB;
  if (numeroTelephone != null) client.numeroTelephone = numeroTelephone;
  //if (supprimer != null) client.supprimer = supprimer;
}


  Future<void> saveClientData() async {
    try {
      await todobos1.put(client.idClient, client);
      print("Enregistrement réussi : $client");
    } catch (e) {
      print("Erreur lors de l'enregistrement : $e");
    }
  }

  Future<void> markAsDeleted(ClientModel client) async {
    if (todobos1 != null) {
      //client.supprimer = 1;
      await todobos1.put(client.idClient, client).then((value) {
        print("Client marqué comme supprimé : $client");
      }).catchError((error) {
        print("Erreur lors de la mise à jour : $error");
      });
    }
  }



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

   // Reconnaître le texte à partir de l'image
  Future<void> recognizeText(InputImage inputImage) async {
    final textRecognizer = GoogleMlKit.vision.textRecognizer();

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    if (recognizedText.blocks.isEmpty) {
      this.recognizedText = '';
      updateClient(identite: '');
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
    String reference = extractInfo(extractedText, r'\b(B\d+(\s?\d+)*)\b');


  // Extraire et trier toutes les dates au format français
    List<String> dateStrings = extractAllDates(extractedText, r'\b\d{2}/\d{2}/\d{4}\b');
    List<DateTime> dates = dateStrings.map((dateStr) => DateFormat('dd/MM/yyyy').parse(dateStr)).toList();
    dates.sort();

    // Récupérer l'avant-dernière date
    String delivreeLe = dates.length >= 2 ? DateFormat('dd/MM/yyyy').format(dates[dates.length - 2]) : '';


    print('Nom: $nom');
    print('Prénoms: $prenoms');
    print('Délivrée le: $delivreeLe');
    print('Référence: $reference');

    if (nom.isEmpty || prenoms.isEmpty || delivreeLe.isEmpty || reference.isEmpty) {
      this.recognizedText = '';
      updateClient(identite: 'Erreur: veuillez reprendre votre photo car une ou plusieurs informations sont manquantes.');
      return;
    }

    if (!isValidDate(delivreeLe)) {
      this.recognizedText = '';
      updateClient(identite: 'Erreur: La date de délivrance n\'est pas valide.');
      return;
    }

    String infoClient = '$nom $prenoms / CNIB N° $reference du $delivreeLe';
    this.recognizedText = extractedText;
    identiteController.text = infoClient;
    updateClient(identite: infoClient);
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
      final dateFormat = DateFormat('dd/MM/yyyy'); // Assuming the date format is 'dd/MM/yyyy'
      dateFormat.parseStrict(dateStr);
      return true;
    } catch (e) {
      return false;
    }
  }

}
