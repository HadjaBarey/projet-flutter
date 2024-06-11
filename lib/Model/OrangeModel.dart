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
    );
  }

  // Constructeur par défaut sans paramètres
  OrangeModel.empty()
      : idoperation = 0,
        dateoperation = '',
        montant = '',
        numeroTelephone = '',
        infoClient = '',
        typeOperation = 0,
        operateur = '',
        supprimer = 0,
        iddette = 0;
}
