import 'package:hive/hive.dart';

part 'EntrepriseModel.g.dart';

@HiveType(typeId: 2)
class EntrepriseModel extends HiveObject {
  @HiveField(0)
  int idEntreprise;

  @HiveField(1)
  String NomEntreprise;

  @HiveField(2)
  String DirecteurEntreprise;

  @HiveField(3)
  String DateControle;

  @HiveField(4)
  String numeroTelEntreprise;

  @HiveField(5)
  String emailEntreprise;


  EntrepriseModel({
    required this.idEntreprise,
    required this.NomEntreprise,
    required this.DirecteurEntreprise,
    required this.DateControle,
    required this.numeroTelEntreprise,
    required this.emailEntreprise,
  });

  factory EntrepriseModel.fromJSON(Map<String, dynamic> json) {
    return EntrepriseModel(
      idEntreprise: json['idEntreprise'] ?? 0,      
      NomEntreprise: json['NomEntreprise'] ?? '',
      DateControle: json['DateControle'] ?? '',
      DirecteurEntreprise: json['DirecteurEntreprise'] ?? '',
      numeroTelEntreprise: json['numeroTelEntreprise'] ?? '',
      emailEntreprise: json['emailEntreprise'] ?? '',
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'idEntreprise': idEntreprise,
      'NomEntreprise': NomEntreprise,
      'DirecteurEntreprise': DirecteurEntreprise,
      'DateControle': DateControle,
      'numeroTelEntreprise': numeroTelEntreprise,
      'emailEntreprise': emailEntreprise,
    };
  }
}
