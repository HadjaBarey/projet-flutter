import 'package:hive/hive.dart';


part 'ClientModel.g.dart';

@HiveType(typeId: 1)
class ClientModel extends HiveObject {
  @HiveField(0)
  int idClient;

  @HiveField(1)
  String Identite;

  @HiveField(2)
  String RefCNIB;

  @HiveField(3)
  String numeroTelephone;



  ClientModel({
    required this.idClient,
    required this.Identite,
    required this.RefCNIB,
    required this.numeroTelephone,
  });

  factory ClientModel.fromJSON(Map<String, dynamic> json) {
    return ClientModel(
      idClient: json['idClient'],
      Identite: json['Identite'],
      RefCNIB: json['RefCNIB'],
      numeroTelephone: json['numeroTelephone'],
    );
  }

  // Constructeur par défaut sans paramètres
  ClientModel.empty()
      : idClient = 0,
        Identite = '',
        RefCNIB = '',
        numeroTelephone = '';

}
