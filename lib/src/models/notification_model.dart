import 'package:haweyati/src/services/notifications_service.dart';
import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 220)
class StoreableNotification {
  @HiveField(0) bool isRead;
  @HiveField(1) NotificationData data;
  @HiveField(2) Notification notification;

  StoreableNotification({
    this.data,
    this.isRead,
    this.notification,
  });
}
