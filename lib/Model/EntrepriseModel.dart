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


  EntrepriseModel({
    required this.idEntreprise,
    required this.NomEntreprise,
    required this.DirecteurEntreprise,
    required this.DateControle,
  });
}
