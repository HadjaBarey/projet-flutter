// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UtilisateurModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UtilisateurModelAdapter extends TypeAdapter<UtilisateurModel> {
  @override
  final int typeId = 5;

  @override
  UtilisateurModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UtilisateurModel(
      idUtilisateur: fields[0] as int,
      IdentiteUtilisateur: fields[1] as String,
      RefCNIBUtilisateur: fields[2] as String,
      NumPhoneUtilisateur: fields[3] as String,
      supprimer: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UtilisateurModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idUtilisateur)
      ..writeByte(1)
      ..write(obj.IdentiteUtilisateur)
      ..writeByte(2)
      ..write(obj.RefCNIBUtilisateur)
      ..writeByte(3)
      ..write(obj.NumPhoneUtilisateur)
      ..writeByte(4)
      ..write(obj.supprimer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UtilisateurModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
