// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreableNotificationAdapter extends TypeAdapter<StoreableNotification> {
  @override
  final int typeId = 220;

  @override
  StoreableNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoreableNotification(
      data: fields[1] as NotificationData,
      isRead: fields[0] as bool,
      notification: fields[2] as Notification,
    );
  }

  @override
  void write(BinaryWriter writer, StoreableNotification obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isRead)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.notification);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreableNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
