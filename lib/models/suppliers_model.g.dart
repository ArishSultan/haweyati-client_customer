// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suppliers_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SupplierAdapter extends TypeAdapter<Supplier> {
  @override
  final int typeId = 11;

  @override
  Supplier read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Supplier(
      services: (fields[0] as List)?.cast<String>(),
      status: fields[1] as String,
      sId: fields[2] as String,
      city: fields[3] as String,
      person: fields[4] as Person,
      location: fields[5] as HiveLocation,
      iV: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Supplier obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.services)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.sId)
      ..writeByte(3)
      ..write(obj.city)
      ..writeByte(4)
      ..write(obj.person)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.iV);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
