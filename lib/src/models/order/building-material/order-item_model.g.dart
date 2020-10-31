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
      size: fields[2] as String,
      qty: fields[1] as int,
      price: fields[3] as double,
    )..product = fields[0] as Orderable;
  }

  @override
  void write(BinaryWriter writer, BuildingMaterialOrderItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.qty)
      ..writeByte(2)
      ..write(obj.size)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(0)
      ..write(obj.product);
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
