import 'package:flutter/widgets.dart';
import 'package:haweyati/models/hive-models/customer/customer-model.dart';
import 'package:haweyati/src/app.dart';
import 'package:haweyati/src/common/services/easy-rest/easy-rest.dart';
import 'package:haweyati/src/common/services/http/basics/request-type.dart';
import 'package:haweyati/src/common/services/jwt-auth_service.dart';
import 'package:haweyati/src/utils/app-data.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:haweyati/src/utils/token-storage.dart';
import 'package:haweyati/src/utils/user-storage.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppData.initiate();

  EasyRest.configure(
    port: 4000,
    host: '128.199.20.220'
  );
  
  await JwtAuthService.configure<Customer, String>(
    userStorage: UserStorage(),
    tokenStorage: TokenStorage(),
    tokenParser: (json) => json['access_token'],
    userParser: (json) => Customer.fromJson(json),
    userRequest: RequestConfig(type: RequestType.get, endpoint: 'auth/profile'),
    signInRequest: RequestConfig(type: RequestType.post, endpoint: 'auth/sign-in'),
    signOutRequest: RequestConfig(type: RequestType.post, endpoint: 'auth/sign-out'),
  );

  runApp(EasyLocalization(
    supportedLocales: [const Locale('ar'), const Locale('en')],
    fallbackLocale: const Locale('en'),
    path: 'assets/translations',
    child: HaweyatiApp(await AppData.instance().isFuseBurnt)
  ));
}
