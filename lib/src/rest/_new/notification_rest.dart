import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/_new/_config.dart';
import 'package:retrofit/http.dart';
import 'package:haweyati_client_data_models/data.dart';

part 'notification_rest.g.dart';

@RestApi(baseUrl: apiUrl)
abstract class NotificationRest {
  NotificationRest._();
  factory NotificationRest() => _NotificationRest(defaultDio);

  @GET('/fcm/get-unseen/{id}')
  Future<List<NotificationRequest>> _get(@Path('id') String id);

  Future<List<NotificationRequest>> get() => _get(AppData().user.id);
}
