import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:haweyati/models/hive-models/customer/customer-model.dart';
import 'package:haweyati/models/hive-models/notifications_model.dart';
import 'package:haweyati/src/app.dart';
import 'package:haweyati/src/utlis/hive-local-data.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HaweyatiData.init();

  runApp(EasyLocalization(
      supportedLocales: [const Locale('ar'), const Locale('en')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: HaweyatiApp((await SharedPreferences.getInstance()).getBool('firstTime') ?? true)
  ));
}
