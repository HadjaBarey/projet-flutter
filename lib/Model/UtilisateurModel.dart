import 'package:hive/hive.dart';

part 'UtilisateurModel.g.dart';

@HiveType(typeId: 0)
class UtilisateurModel extends HiveObject {
  @HiveField(0)
  int idUtilisateur;

  @HiveField(1)
  String IdentiteUtilisateur;

  @HiveField(2)
  String RefCNIBUtilisateur;

  @HiveField(3)
  String NumPhoneUtilisateur;

  @HiveField(4)
  int supprimer;

  UtilisateurModel({
    required this.idUtilisateur,
    required this.IdentiteUtilisateur,
    required this.RefCNIBUtilisateur,
    required this.NumPhoneUtilisateur,
    required this.supprimer,
  });
}
