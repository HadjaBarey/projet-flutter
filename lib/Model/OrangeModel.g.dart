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
      dateoperation: fields[1] != null ? fields[1] as String : '',
      montant: fields[2] != null ? fields[2] as String : '',
      numeroTelephone: fields[3] != null ? fields[3] as String : '',
      infoClient: fields[4] != null ? fields[4] as String : '',
      typeOperation: fields[5] != null ? fields[5] as int : 0,
      operateur: fields[6] != null ? fields[6] as String : '',
      supprimer: fields[7] != null ? fields[7] as int : 0,
      iddette: fields[8] != null ? fields[8] as int : 0,
      optionCreance: fields[9] != null ? fields[9] as bool : false,
      scanMessage: fields[10] != null ? fields[10] as String : '',
      numeroIndependant: fields[11] != null ? fields[11] as String : '',
    );
  }

  @override
  void write(BinaryWriter writer, OrangeModel obj) {
    writer
      ..writeByte(12)
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
      ..write(obj.optionCreance)
      ..writeByte(10)
      ..write(obj.scanMessage)
      ..writeByte(11)
      ..write(obj.numeroIndependant);
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