// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinishingMaterialOptionAdapter
    extends TypeAdapter<FinishingMaterialOption> {
  @override
  final int typeId = 26;

  @override
  FinishingMaterialOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinishingMaterialOption(
      id: fields[0] as String,
      name: fields[1] as String,
      values: (fields[2] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FinishingMaterialOption obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.values);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinishingMaterialOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
