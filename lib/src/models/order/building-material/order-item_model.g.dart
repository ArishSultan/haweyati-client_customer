// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order-item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BuildingMaterialOrderItemAdapter
    extends TypeAdapter<BuildingMaterialOrderItem> {
  @override
  final int typeId = 52;

  @override
  BuildingMaterialOrderItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BuildingMaterialOrderItem(
      fields[2] as BuildingMaterialSize,
      qty: fields[1] as int,
      price: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BuildingMaterialOrderItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.qty)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.size);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuildingMaterialOrderItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
