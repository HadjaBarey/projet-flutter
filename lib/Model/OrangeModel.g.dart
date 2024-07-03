// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrangeModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrangeModelAdapter extends TypeAdapter<OrangeModel> {
  @override
  final int typeId = 1;

  @override
  OrangeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrangeModel(
      idoperation: fields[0] as int,
      dateoperation: fields[1] as String,
      montant: fields[2] as String,
      numeroTelephone: fields[3] as String,
      infoClient: fields[4] as String,
      typeOperation: fields[5] as int,
      operateur: fields[6] as String,
      supprimer: fields[7] as int,
      iddette: fields[8] as int,
      optionCreance: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OrangeModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.idoperation)
      ..writeByte(1)
      ..write(obj.dateoperation)
      ..writeByte(2)
      ..write(obj.montant)
      ..writeByte(3)
      ..write(obj.numeroTelephone)
      ..writeByte(4)
      ..write(obj.infoClient)
      ..writeByte(5)
      ..write(obj.typeOperation)
      ..writeByte(6)
      ..write(obj.operateur)
      ..writeByte(7)
      ..write(obj.supprimer)
      ..writeByte(8)
      ..write(obj.iddette)
      ..writeByte(9)
      ..write(obj.optionCreance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrangeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
