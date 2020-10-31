// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order-item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DumpsterOrderItemAdapter extends TypeAdapter<DumpsterOrderItem> {
  @override
  final int typeId = 51;

  @override
  DumpsterOrderItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DumpsterOrderItem(
      extraDays: fields[1] as int,
      extraDaysPrice: fields[2] as double,
    )..product = fields[0] as Orderable;
  }

  @override
  void write(BinaryWriter writer, DumpsterOrderItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.extraDays)
      ..writeByte(2)
      ..write(obj.extraDaysPrice)
      ..writeByte(0)
      ..write(obj.product);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DumpsterOrderItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
