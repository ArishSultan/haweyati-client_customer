// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 0;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      customer: fields[6] as String,
      note: fields[4] as String,
      dropOffDate: fields[2] as String,
      dropOffTime: fields[3] as String,
      service: fields[0] as String,
      helper: fields[5] as bool,
      image: fields[7] as String,
      city: fields[15] as String,
      order: fields[9] as OrderDetails,
      paymentType: fields[10] as String,
      paymentIntentId: fields[11] as String,
      address: fields[14] as String,
      longitude: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.service)
      ..writeByte(2)
      ..write(obj.dropOffDate)
      ..writeByte(3)
      ..write(obj.dropOffTime)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.helper)
      ..writeByte(6)
      ..write(obj.customer)
      ..writeByte(7)
      ..write(obj.image)
      ..writeByte(9)
      ..write(obj.order)
      ..writeByte(10)
      ..write(obj.paymentType)
      ..writeByte(11)
      ..write(obj.paymentIntentId)
      ..writeByte(13)
      ..write(obj.longitude)
      ..writeByte(14)
      ..write(obj.address)
      ..writeByte(15)
      ..write(obj.city);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
