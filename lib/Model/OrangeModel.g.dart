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
      numero_telephone: fields[3] as String,
      info_client: fields[4] as String,
      typeoperation: fields[5] as int,
      operateur: fields[6] as String,
      supprimer: fields[7] as int,
      iddette: fields[8] as int,
      optionCreance: fields[9] as bool,
      scanmessage: fields[10] as String,
      numeroIndependant: fields[11] as String,
      idtrans: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrangeModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.idoperation)
      ..writeByte(1)
      ..write(obj.dateoperation)
      ..writeByte(2)
      ..write(obj.montant)
      ..writeByte(3)
      ..write(obj.numero_telephone)
      ..writeByte(4)
      ..write(obj.info_client)
      ..writeByte(5)
      ..write(obj.typeoperation)
      ..writeByte(6)
      ..write(obj.operateur)
      ..writeByte(7)
      ..write(obj.supprimer)
      ..writeByte(8)
      ..write(obj.iddette)
      ..writeByte(9)
      ..write(obj.optionCreance)
      ..writeByte(10)
      ..write(obj.scanmessage)
      ..writeByte(11)
      ..write(obj.numeroIndependant)
      ..writeByte(12)
      ..write(obj.idtrans);
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
