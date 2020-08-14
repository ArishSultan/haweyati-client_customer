// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dumpster-order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DumpsterOrderAdapter extends TypeAdapter<DumpsterOrder> {
  @override
  final int typeId = 1;

  @override
  DumpsterOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DumpsterOrder(
      dumpster: fields[0] as Dumpster,
      extraDayPrice: fields[2] as double,
      extraDays: fields[1] as int,
      total: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DumpsterOrder obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dumpster)
      ..writeByte(1)
      ..write(obj.extraDays)
      ..writeByte(2)
      ..write(obj.extraDayPrice)
      ..writeByte(3)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DumpsterOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
