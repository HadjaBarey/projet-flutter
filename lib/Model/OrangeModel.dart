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
  String numeroTelephone;

  @HiveField(4)
  String infoClient;

  @HiveField(5)
  int typeOperation;

  @HiveField(6)
  String operateur;

  @HiveField(7)
  int supprimer;

  @HiveField(8)
  int iddette;

  @HiveField(9)
  bool optionCreance;

  @HiveField(10)
  String scanMessage;

  @HiveField(11)
  String numeroIndependant;

  @HiveField(12)
  String idTrans;

  OrangeModel({
    required this.idoperation,
    required this.dateoperation,
    required this.montant,
    required this.numeroTelephone,
    required this.infoClient,
    required this.typeOperation,
    required this.operateur,
    required this.supprimer,
    required this.iddette,
    this.optionCreance = false,
    required this.scanMessage,
    required this.numeroIndependant,
    required this.idTrans,
  });

  factory OrangeModel.fromJSON(Map<String, dynamic> json) {
    return OrangeModel(
      idoperation: json['idoperation'] ?? 0,
      dateoperation: json['dateoperation'] ?? '',
      montant: json['montant'] ?? '',
      numeroTelephone: json['numeroTelephone'] ?? '',
      infoClient: json['infoClient'] ?? '',
      typeOperation: json['typeOperation'] ?? 0,
      operateur: json['operateur'] ?? '',
      supprimer: json['supprimer'] ?? 0,
      iddette: json['iddette'] ?? 0,
      optionCreance: json['optionCreance'] ?? false,
      scanMessage: json['scanMessage'] ?? '',
      numeroIndependant: json['numeroIndependant'] ?? '',
      idTrans: json['idTrans'] ?? '',
    );
  }

  OrangeModel.empty()
      : idoperation = 0,
        dateoperation = '',
        montant = '',
        numeroTelephone = '',
        infoClient = '',
        typeOperation = 0,
        operateur = '',
        supprimer = 0,
        iddette = 0,
        optionCreance = false,
        scanMessage = '',
        numeroIndependant = '',
        idTrans = '';

  Map<String, dynamic> toJson() {
    return {
      'idoperation': idoperation,
      'dateoperation': dateoperation,
      'montant': montant,
      'numeroTelephone': numeroTelephone,
      'infoClient': infoClient,
      'typeOperation': typeOperation,
      'operateur': operateur,
      'supprimer': supprimer,
      'iddette': iddette,
      'optionCreance': optionCreance,
      'scanMessage': scanMessage,
      'numeroIndependant': numeroIndependant,
      'idTrans': idTrans,
    };
  }
}