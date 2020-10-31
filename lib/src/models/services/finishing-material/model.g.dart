// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinishingMaterialAdapter extends TypeAdapter<FinishingMaterial> {
  @override
  final int typeId = 22;

  @override
  FinishingMaterial read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinishingMaterial(
      id: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as double,
      parent: fields[3] as String,
      images: fields[4] as ImageModel,
      options: (fields[7] as List)?.cast<FinishingMaterialOption>(),
      variants: (fields[6] as List)
          ?.map((dynamic e) => (e as Map)?.cast<String, dynamic>())
          ?.toList(),
      description: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FinishingMaterial obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.parent)
      ..writeByte(4)
      ..write(obj.images)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.variants)
      ..writeByte(7)
      ..write(obj.options);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinishingMaterialAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}