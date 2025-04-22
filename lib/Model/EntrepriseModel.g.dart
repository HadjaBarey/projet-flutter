// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EntrepriseModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntrepriseModelAdapter extends TypeAdapter<EntrepriseModel> {
  @override
  final int typeId = 2;

  @override
  EntrepriseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EntrepriseModel(
      idEntreprise: fields[0] as int,
      NomEntreprise: fields[1] as String,
      DirecteurEntreprise: fields[2] as String,
      DateControle: fields[3] as String,
      numeroTelEntreprise: fields[4] as String,
      emailEntreprise: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EntrepriseModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.idEntreprise)
      ..writeByte(1)
      ..write(obj.NomEntreprise)
      ..writeByte(2)
      ..write(obj.DirecteurEntreprise)
      ..writeByte(3)
      ..write(obj.DateControle)
      ..writeByte(4)
      ..write(obj.numeroTelEntreprise)
      ..writeByte(5)
      ..write(obj.emailEntreprise);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntrepriseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
