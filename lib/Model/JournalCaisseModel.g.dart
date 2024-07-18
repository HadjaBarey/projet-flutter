// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JournalCaisseModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JournalCaisseModelAdapter extends TypeAdapter<JournalCaisseModel> {
  @override
  final int typeId = 6;

  @override
  JournalCaisseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalCaisseModel(
      idjournal: fields[0] as int,
      dateJournal: fields[1] != null ? fields[1] as String : '',
      montantJ: fields[2] != null ? fields[2] as String : '',
      typeCompte: fields[3] != null ? fields[3] as String : '',
      operateur: fields[4] != null ? fields[4] as String : '',
    );
  }

  @override
  void write(BinaryWriter writer, JournalCaisseModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idjournal)
      ..writeByte(1)
      ..write(obj.dateJournal)
      ..writeByte(2)
      ..write(obj.montantJ)
      ..writeByte(3)
      ..write(obj.typeCompte)
      ..writeByte(4)
      ..write(obj.operateur);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalCaisseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
