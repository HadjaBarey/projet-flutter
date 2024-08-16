// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OpTransactionModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OpTransactionModelAdapter extends TypeAdapter<OpTransactionModel> {
  @override
  final int typeId = 4;

  @override
  OpTransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OpTransactionModel(
      idOpTransaction: fields[0] as int,
      CodeTransaction: fields[1] as String,
      TypeOperation: fields[2] as String,
      Operateur: fields[3] as String,
      supprimer: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, OpTransactionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idOpTransaction)
      ..writeByte(1)
      ..write(obj.CodeTransaction)
      ..writeByte(2)
      ..write(obj.TypeOperation)
      ..writeByte(3)
      ..write(obj.Operateur)
      ..writeByte(4)
      ..write(obj.supprimer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpTransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
