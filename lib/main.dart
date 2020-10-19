import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:haweyati/src/app.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/user_model.dart';
import 'package:haweyati/src/utils/user-storage.dart';
import 'package:haweyati/src/utils/token-storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:haweyati/src/common/services/jwt-auth_service.dart';
import 'package:haweyati/src/common/services/easy-rest/easy-rest.dart';
import 'package:haweyati/src/common/services/http/basics/request-type.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppData.initiate();
  await Firebase.initializeApp();

  EasyRest.configure(
    port: 4000,
    host: kReleaseMode ? '178.128.16.246' : '192.168.100.100'
  );

  await JwtAuthService.configure<User, String>(
    userStorage: UserStorage(),
    tokenStorage: TokenStorage(),
    userParser: (json) => User.fromJson(json),
    tokenParser: (json) => json['access_token'],
    userRequest: RequestConfig(type: RequestType.get, endpoint: 'auth/profile'),
    signInRequest: RequestConfig(type: RequestType.post, endpoint: 'auth/sign-in'),
    signOutRequest: RequestConfig(type: RequestType.post, endpoint: 'auth/sign-out'),
  );

  final _appData = AppData.instance();

  // fcm.onTokenRefresh.listen((event) {
  //   if (_appData.isAuthenticated) {
  //     EasyRest().$patch(
  //       endpoint: 'fcm/token',
  //       payload: _appData.user.profile..token = event
  //     );
  //   }
  // });

  runApp(HaweyatiApp(
    locale: _appData.currentLocale,
    status: await _appData.isFuseBurnt
  ));
}

