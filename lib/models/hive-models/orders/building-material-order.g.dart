// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'building-material-order.dart';
//
// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************
//
// class BMOrderAdapter extends TypeAdapter<BMOrder> {
//   @override
//   final int typeId = 7;
//
//   @override
//   BMOrder read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return BMOrder(
//       product: fields[0] as BuildingMaterial,
//       size: fields[1] as String,
//       qty: fields[2] as int,
//       total: fields[4] as double,
//       price: fields[3] as double,
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, BMOrder obj) {
//     writer
//       ..writeByte(5)
//       ..writeByte(0)
//       ..write(obj.product)
//       ..writeByte(1)
//       ..write(obj.size)
//       ..writeByte(2)
//       ..write(obj.qty)
//       ..writeByte(3)
//       ..write(obj.price)
//       ..writeByte(4)
//       ..write(obj.total);
//   }
//
//   @override
//   int get hashCode => typeId.hashCode;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is BMOrderAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
