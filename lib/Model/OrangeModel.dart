import 'dart:convert';

import 'package:hive/hive.dart';

part 'OrangeModel.g.dart';

@HiveType(typeId: 1)
class OrangeModel extends HiveObject {
  @HiveField(0)
  int idoperation;

  @HiveField(1)
  String dateoperation;

  @HiveField(2)
  String montant;

  @HiveField(3)
  String numero_telephone;

  @HiveField(4)
  String info_client;

  @HiveField(5)
  int typeoperation;

  @HiveField(6)
  String operateur;

  @HiveField(7)
  int supprimer;

  @HiveField(8)
  int iddette;

  @HiveField(9)
  bool optionCreance;

  @HiveField(10)
  String scanmessage;

  @HiveField(11)
  String numeroIndependant;

  @HiveField(12)
  String idtrans;

  OrangeModel({
    required this.idoperation,
    required this.dateoperation,
    required this.montant,
    required this.numero_telephone,
    required this.info_client,
    required this.typeoperation,
    required this.operateur,
    required this.supprimer,
    required this.iddette,
    this.optionCreance = false,
    required this.scanmessage,
    required this.numeroIndependant,
    required this.idtrans,
  });

  factory OrangeModel.fromJSON(Map<String, dynamic> json) {
    return OrangeModel(
      idoperation: json['idoperation'] ?? 0,
      dateoperation: json['dateoperation'] ?? '',
      montant: json['montant'] ?? '',
      numero_telephone: json['numero_telephone'] ?? '',
      info_client: json['info_client'] ?? '',
      typeoperation: json['typeoperation'] ?? 0,
      operateur: json['operateur'] ?? '',
      supprimer: json['supprimer'] ?? 0,
      iddette: json['iddette'] ?? 0,
      optionCreance: json['optionCreance'] ?? false,
      scanmessage: json['scanmessage'] ?? '',
      numeroIndependant: json['numeroIndependant'] ?? '',
      idtrans: json['idtrans'] ?? '',
    );
  }

  OrangeModel.empty()
      : idoperation = 0,
        dateoperation = '',
        montant = '',
        numero_telephone = '',
        info_client = '',
        typeoperation = 0,
        operateur = '',
        supprimer = 0,
        iddette = 0,
        optionCreance = false,
        scanmessage = '',
        numeroIndependant = '',
        idtrans = '';

  Map<String, dynamic> toJson() {
    return {
      'idoperation': idoperation,
      'dateoperation': dateoperation,
      'montant': montant,
      'numero_telephone': numero_telephone,
      'info_client': info_client,
      'typeoperation': typeoperation,
      'operateur': operateur,
      'supprimer': supprimer,
      'iddette': iddette,
      'optionCreance': optionCreance,
      'scanmessage': scanmessage,
      'numeroIndependant': numeroIndependant,
      'idtrans': idtrans,
    };
  }
}