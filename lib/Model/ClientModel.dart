import 'package:hive/hive.dart';

part 'ClientModel.g.dart';

@HiveType(typeId: 0)
class ClientModel extends HiveObject {
  @HiveField(0)
  int idClient;

  @HiveField(1)
  String Identite;

  @HiveField(2)
  String RefCNIB;

  @HiveField(3)
  String numeroTelephone;

  @HiveField(4)
  int supprimer;

  ClientModel({
    required this.idClient,
    required this.Identite,
    required this.RefCNIB,
    required this.numeroTelephone,
    required this.supprimer,
  });

  factory ClientModel.fromJSON(Map<String, dynamic> json) {
    return ClientModel(
      idClient: json['idClient'] ?? 0,
      Identite: json['Identite'] ?? '',
      RefCNIB: json['RefCNIB'] ?? '',
      numeroTelephone: json['numeroTelephone'] ?? '',
      supprimer: json['supprimer'] ?? 0,
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'idClient': idClient,
      'Identite': Identite,
      'RefCNIB': RefCNIB,
      'numeroTelephone': numeroTelephone,
      'supprimer': supprimer,
    };
  }
}
