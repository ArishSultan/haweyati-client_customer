// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_service.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationAdapter extends TypeAdapter<Notification> {
  @override
  final int typeId = 222;

  @override
  Notification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Notification()
      ..body = fields[0] as String
      ..title = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, Notification obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.body)
      ..writeByte(1)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationDataAdapter extends TypeAdapter<NotificationData> {
  @override
  final int typeId = 221;

  @override
  NotificationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationData()
      ..type = fields[0] as String
      ..createdAt = fields[1] as DateTime;
  }

  @override
  void write(BinaryWriter writer, NotificationData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification()
    ..body = json['body'] as String
    ..title = json['title'] as String;
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'body': instance.body,
      'title': instance.title,
    };
