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
  bool optionCreance; // Ajout de la nouvelle variable de type boolean

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
    required this.optionCreance, // Ajout du champ dans le constructeur
  });

  factory OrangeModel.fromJSON(Map<String, dynamic> json) {
    return OrangeModel(
      idoperation: json['idoperation'],
      dateoperation: json['dateoperation'],
      montant: json['montant'],
      numeroTelephone: json['numeroTelephone'],
      infoClient: json['infoClient'],
      typeOperation: json['typeOperation'],
      operateur: json['operateur'],
      supprimer: json['supprimer'],
      iddette: json['iddette'],
      optionCreance: json['isNewField'], // Ajout du champ dans la méthode fromJSON
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
        optionCreance = false; // Initialisation du champ dans le constructeur vide

  factory OrangeModel.fromMap(Map<String, dynamic> map) {
    return OrangeModel(
      idoperation: map['idoperation'],
      dateoperation: map['dateoperation'],
      montant: map['montant'],
      numeroTelephone: map['numeroTelephone'],
      infoClient: map['infoClient'],
      typeOperation: map['typeOperation'],
      operateur: map['operateur'],
      supprimer: map['supprimer'],
      iddette: map['iddette'],
      optionCreance: map['isNewField'], // Ajout du champ dans la méthode fromMap
    );
  }
}
