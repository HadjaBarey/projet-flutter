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
}
