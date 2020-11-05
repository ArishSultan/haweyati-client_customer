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
      qty: fields[3] as int,
      extraDays: fields[1] as int,
      extraDaysPrice: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DumpsterOrderItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.extraDays)
      ..writeByte(2)
      ..write(obj.extraDaysPrice)
      ..writeByte(3)
      ..write(obj.qty);
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
