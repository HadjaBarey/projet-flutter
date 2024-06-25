import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kadoustransfert/Model/ClientModel.dart';

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

  void resetFormFields() {
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
}
