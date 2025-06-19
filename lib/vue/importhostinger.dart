import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class OperationModel {
  final int idoperation;
  final String dateoperation; // format 'yyyy-MM-dd' ou autre format standard
  final double montant;
  final String numeroTelephone;
  final String infoClient;
  final int typeOperation;
  final String operateur;
  final int supprimer;
  final int iddette;
  final bool optionCreance;
  final String scanMessage;
  final String numeroIndependant;
  final String idTrans;

  OperationModel({
    required this.idoperation,
    required this.dateoperation,
    required this.montant,
    required this.numeroTelephone,
    required this.infoClient,
    required this.typeOperation,
    required this.operateur,
    required this.supprimer,
    required this.iddette,
    required this.optionCreance,
    required this.scanMessage,
    required this.numeroIndependant,
    required this.idTrans,
  });

  Map<String, dynamic> toJson() {
    return {
      'idoperation': idoperation,
      'dateoperation': dateoperation,
      'montant': montant,
      'numeroTelephone': numeroTelephone.trim(),
      'infoClient': infoClient,
      'typeOperation': typeOperation,
      'operateur': operateur,
      'supprimer': supprimer,
      'iddette': iddette,
      'optionCreance': optionCreance,
      'scanMessage': scanMessage,
      'numeroIndependant': numeroIndependant.trim(),
      'idTrans': idTrans,
    };
  }
}

class TransferService {
  final String baseUrl = " https://kadoussconnect.com/transfertflutter/backend/save_data.php";

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<bool> isConnectedToInternet() async {
    // Implémenter une vraie vérification réseau, ou utiliser connectivity_plus
    return true;
  }

  Future<bool> sendOperations(List<OperationModel> operations, String numeroEntreprise, String emailEntreprise) async {
    if (!await isConnectedToInternet()) {
      print('🚫 Pas de connexion internet.');
      return false;
    }

    final token = await getToken();
    if (token == null) {
      print('❌ Token manquant.');
      return false;
    }

    // Suppression des anciennes données avant insertion
    final deleteResponse = await http.post(
      Uri.parse('$baseUrl/delete_operations.php'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'numeroTelEntreprise': numeroEntreprise,
        'emailEntreprise': emailEntreprise,
      }),
    );

    if (deleteResponse.statusCode != 200) {
      print('❌ Erreur suppression : ${deleteResponse.body}');
      return false;
    }

    // Envoi des opérations une à une (tu peux aussi faire un batch si tu veux)
    for (var op in operations) {
      final response = await http.post(
        Uri.parse('$baseUrl/insert_operation.php'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          ...op.toJson(),
          'numeroTelEntreprise': numeroEntreprise,
          'emailEntreprise': emailEntreprise,
        }),
      );

      if (response.statusCode != 200) {
        print('❌ Erreur envoi opération ${op.idoperation}: ${response.body}');
        return false;
      }
    }

    print('✅ Toutes les opérations ont été envoyées.');
    return true;
  }
}
