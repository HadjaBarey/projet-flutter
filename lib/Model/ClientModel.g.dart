// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientModelAdapter extends TypeAdapter<ClientModel> {
  @override
  final int typeId = 0;

  @override
  ClientModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientModel(
      idClient: fields[0] as int,
      Identite: fields[1] as String,
      RefCNIB: fields[2] as String,
      numeroTelephone: fields[3] as String,
      supprimer: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ClientModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idClient)
      ..writeByte(1)
      ..write(obj.Identite)
      ..writeByte(2)
      ..write(obj.RefCNIB)
      ..writeByte(3)
      ..write(obj.numeroTelephone)
      ..writeByte(4)
      ..write(obj.supprimer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
