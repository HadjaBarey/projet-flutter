// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UsersKeyModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsersKeyModelAdapter extends TypeAdapter<UsersKeyModel> {
  @override
  final int typeId = 7;

  @override
  UsersKeyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsersKeyModel(
      numauto: fields[0] as int,
      numeroaleatoire: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UsersKeyModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.numauto)
      ..writeByte(1)
      ..write(obj.numeroaleatoire);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersKeyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
