// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order-details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderDetailsAdapter extends TypeAdapter<OrderDetails> {
  @override
  final int typeId = 8;

  @override
  OrderDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderDetails(
      netTotal: fields[1] as double,
      items: (fields[0] as List)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderDetails obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.items)
      ..writeByte(1)
      ..write(obj.netTotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
