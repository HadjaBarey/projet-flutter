import 'package:hive/hive.dart';

part 'JournalCaisseModel.g.dart';

@HiveType(typeId: 6)
class JournalCaisseModel extends HiveObject {
  @HiveField(0)
  int idjournal;

  @HiveField(1)
  String dateJournal;

  @HiveField(2)
  String montantJ;

  @HiveField(3)
  String typeCompte;

  @HiveField(4)
  String operateur;


  JournalCaisseModel({
    required this.idjournal,
    required this.dateJournal,
    required this.montantJ,
    required this.typeCompte,
    required this.operateur,
  });

  factory JournalCaisseModel.fromJSON(Map<String, dynamic> json) {
    return JournalCaisseModel(
      idjournal: json['idjournal'] ?? 0,
      dateJournal: json['dateJournal'] ?? '',
      montantJ: json['montantJ'] ?? '',
      typeCompte: json['typeCompte'] ?? 0,
      operateur: json['operateur'] ?? '',
    );
  }

  JournalCaisseModel.empty()
      : idjournal = 0,
        dateJournal = '',
        montantJ = '',
        typeCompte = '',
        operateur = '';
       
  Map<String, dynamic> toJson() {
    return {
      'idjournal': idjournal,
      'dateJournal': dateJournal,
      'montantJ': montantJ,
      'typeCompte': typeCompte,
      'operateur': operateur,
    };
  }

}
