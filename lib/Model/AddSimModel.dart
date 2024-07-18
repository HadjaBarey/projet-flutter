import 'package:hive/hive.dart';

part 'AddSimModel.g.dart';

@HiveType(typeId: 3)
class AddSimModel extends HiveObject {
  @HiveField(0)
  int idOperateur;

  @HiveField(1)
  String LibOperateur;

  @HiveField(2)
  String NumPhone;

  @HiveField(3)
  String CodeAgent;

  @HiveField(4)
  int supprimer;

  AddSimModel({
    required this.idOperateur,
    required this.LibOperateur,
    required this.NumPhone,
    required this.CodeAgent,
    required this.supprimer,
  });

  factory AddSimModel.fromJSON(Map<String, dynamic> json) {
    return AddSimModel(
      idOperateur: json['idOperateur'] ?? 0,
      LibOperateur: json['LibOperateur'] ?? '',
      NumPhone: json['NumPhone'] ?? '',
      CodeAgent: json['CodeAgent'] ?? '',
      supprimer: json['supprimer'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idOperateur': idOperateur,
      'LibOperateur': LibOperateur,
      'NumPhone': NumPhone,
      'CodeAgent': CodeAgent,
      'supprimer': supprimer,
    };
  }
}
