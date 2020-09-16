// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'finishing-material_order.dart';
//
// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************
//
// class FMOrderAdapter extends TypeAdapter<FMOrder> {
//   @override
//   final int typeId = 14;
//
//   @override
//   FMOrder read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return FMOrder(
//       product: fields[0] as FinishingMaterial,
//       variant: (fields[1] as Map)?.cast<String, dynamic>(),
//       qty: fields[2] as int,
//       total: fields[3] as double,
//       price: fields[4] as double,
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, FMOrder obj) {
//     writer
//       ..writeByte(5)
//       ..writeByte(0)
//       ..write(obj.product)
//       ..writeByte(1)
//       ..write(obj.variant)
//       ..writeByte(2)
//       ..write(obj.qty)
//       ..writeByte(3)
//       ..write(obj.total)
//       ..writeByte(4)
//       ..write(obj.price);
//   }
//
//   @override
//   int get hashCode => typeId.hashCode;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is FMOrderAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
