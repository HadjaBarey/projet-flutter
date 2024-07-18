// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AddSimModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddSimModelAdapter extends TypeAdapter<AddSimModel> {
  @override
  final int typeId = 3;

  @override
  AddSimModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddSimModel(
      idOperateur: fields[0] as int,
      LibOperateur: fields[1] != null ? fields[1] as String : '',
      NumPhone: fields[2] != null ? fields[2] as String : '',
      CodeAgent: fields[3] != null ? fields[3] as String : '',
      supprimer: fields[4] != null ? fields[4] as int : 0,
    );
  }

  @override
  void write(BinaryWriter writer, AddSimModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idOperateur)
      ..writeByte(1)
      ..write(obj.LibOperateur)
      ..writeByte(2)
      ..write(obj.NumPhone)
      ..writeByte(3)
      ..write(obj.CodeAgent)
      ..writeByte(4)
      ..write(obj.supprimer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddSimModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
