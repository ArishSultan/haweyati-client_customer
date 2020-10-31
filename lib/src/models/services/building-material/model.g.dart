// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BuildingMaterialAdapter extends TypeAdapter<BuildingMaterial> {
  @override
  final int typeId = 21;

  @override
  BuildingMaterial read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BuildingMaterial(
      id: fields[0] as String,
      name: fields[1] as String,
      image: fields[3] as ImageModel,
      parent: fields[2] as String,
      pricing: (fields[5] as List)?.cast<BuildingMaterialPricing>(),
      description: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BuildingMaterial obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.parent)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.pricing);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuildingMaterialAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
