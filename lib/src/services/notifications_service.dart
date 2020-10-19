import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';

part 'notifications_service.g.dart';

typedef TokenUpdater = Future<void> Function(String);
typedef NotificationDataParser<T extends NotificationData> = T Function(Map<String, dynamic>);
typedef NotificationReceivedHandler = Future<void> Function(Notification, NotificationData, BuildContext);

@HiveType(typeId: 222)
class Notification {
  @HiveField(0) String body;
  @HiveField(1) String title;
}

@HiveType(typeId: 221)
class NotificationData {
  @HiveField(0) String type;
  @HiveField(1) DateTime createdAt;
}

class NotificationsService {
  static BuildContext _context;
  static TokenUpdater _tokenUpdater;
  static FirebaseMessaging _firebaseMessaging;
  static NotificationDataParser _notificationDataParser;
  static Function(Notification, NotificationData) _beforeNotify;

  static initialize<T extends NotificationData>({
    List<String> topics,
    Function beforeNotify,
    @required BuildContext context,
    @required TokenUpdater tokenUpdater,
    @required NotificationDataParser<T> dataParser,

    NotificationReceivedHandler onResume,
    NotificationReceivedHandler onLaunch,
    NotificationReceivedHandler onReceived,
  }) {
    assert(context != null);
    assert(dataParser != null);
    assert(tokenUpdater != null);

    _context = context;
    _beforeNotify = beforeNotify;
    _notificationDataParser = dataParser;

    _firebaseMessaging = FirebaseMessaging()
      ..onTokenRefresh.listen(_tokenUpdater);

    if (topics?.isNotEmpty ?? false) {
      topics.forEach(_firebaseMessaging.subscribeToTopic);
    }

    _firebaseMessaging.configure(
      onResume: (message) => _parseData(message, onResume),
      onLaunch: (message) => _parseData(message, onLaunch),
      onMessage: (message) => _parseData(message, onReceived),
    );
  }

  static _parseData(Map<String, dynamic> json, next) async {
    print('body');
    print(json['notification']['body']);
    print('title');
    print(json['notification']['title']);
    final notification = Notification()
      ..body = json['notification']['body']
      ..title = json['notification']['title'];

    // final data = _notificationDataParser(json['data']);
    //
    // await _beforeNotify(notification, data);
    //

    if (next != null)
      return next(notification, null, _context);
  }

  static Future<void> updateToken() async {
    return _tokenUpdater(await _firebaseMessaging.getToken());
  }
}