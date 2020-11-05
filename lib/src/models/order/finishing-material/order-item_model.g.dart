// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order-item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinishingMaterialOrderItemAdapter
    extends TypeAdapter<FinishingMaterialOrderItem> {
  @override
  final int typeId = 50;

  @override
  FinishingMaterialOrderItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinishingMaterialOrderItem(
      qty: fields[1] as int,
      price: fields[2] as double,
      variants: (fields[3] as Map)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, FinishingMaterialOrderItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.qty)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.variants);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinishingMaterialOrderItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
