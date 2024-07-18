import 'package:hive/hive.dart';

part 'OpTransactionModel.g.dart';

@HiveType(typeId: 4)
class OpTransactionModel extends HiveObject {
  @HiveField(0)
  int idOpTransaction;

  @HiveField(1)
  String CodeTransaction;

  @HiveField(2)
  String TypeOperation;

  @HiveField(3)
  String Operateur;

  @HiveField(4)
  int supprimer;

  OpTransactionModel({
    required this.idOpTransaction,
    required this.CodeTransaction,
    required this.TypeOperation,
    required this.Operateur,
    required this.supprimer,
  });

  factory OpTransactionModel.fromJSON(Map<String, dynamic> json) {
    return OpTransactionModel(
      idOpTransaction: json['idOpTransaction'] ?? 0,
      CodeTransaction: json['CodeTransaction'] ?? '',
      TypeOperation: json['TypeOperation'] ?? '',
      Operateur: json['Operateur'] ?? '',
      supprimer: json['supprimer'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idOpTransaction': idOpTransaction,
      'CodeTransaction': CodeTransaction,
      'TypeOperation': TypeOperation,
      'Operateur': Operateur,
      'supprimer':supprimer,
    };
  }
}
