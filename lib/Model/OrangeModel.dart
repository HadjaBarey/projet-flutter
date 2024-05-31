import 'package:hive/hive.dart';

// part 'DeposOrange.g.dart';

@HiveType(typeId: 0)
class DeposOrange extends HiveObject {
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

  DeposOrange({
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

  factory DeposOrange.fromJSON(Map<String, dynamic> json) {
    return DeposOrange(
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
  DeposOrange.empty()
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
