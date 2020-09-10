import 'package:haweyati/models/notifications_model.dart';
import 'package:haweyati/services/haweyati-service.dart';

class NotificationsService extends HaweyatiService<NotificationModel> {
  @override
  NotificationModel parse(Map<String, dynamic> item) => NotificationModel.fromJson(item);

  Future<List<NotificationModel>> notifications() async {
    // return this.getAll('fcm/person/${HaweyatiData.customer.profile.id}');
  }

}