import 'package:hive/hive.dart';

part 'UsersKeyModel.g.dart';

@HiveType(typeId: 0)
class UsersKeyModel extends HiveObject {
  @HiveField(0)
  int numauto;

  @HiveField(1)
  String numeroaleatoire;

  UsersKeyModel({
    required this.numauto,
    required this.numeroaleatoire,
  });

  factory UsersKeyModel.fromJSON(Map<String, dynamic> json) {
    return UsersKeyModel(
      numauto: json['numauto'] ?? 0,
      numeroaleatoire: json['numeroaleatoire'] ?? '',
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'numauto': numauto,
      'numeroaleatoire': numeroaleatoire,
    };
  }
}
