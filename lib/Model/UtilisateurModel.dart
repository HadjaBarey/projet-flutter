import 'package:hive/hive.dart';

part 'UtilisateurModel.g.dart';

@HiveType(typeId: 5)
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

  factory UtilisateurModel.fromJSON(Map<String, dynamic> json) {
    return UtilisateurModel(
      idUtilisateur: json['idUtilisateur'] ?? 0,
      IdentiteUtilisateur: json['IdentiteUtilisateur'] ?? '',
      RefCNIBUtilisateur: json['RefCNIBUtilisateur'] ?? '',
      NumPhoneUtilisateur: json['NumPhoneUtilisateur'] ?? '',
      supprimer: json['supprimer'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUtilisateur': idUtilisateur,
      'IdentiteUtilisateur': IdentiteUtilisateur,
      'RefCNIBUtilisateur': RefCNIBUtilisateur,
      'NumPhoneUtilisateur': NumPhoneUtilisateur,
      'supprimer':supprimer,
    };
  }
}
