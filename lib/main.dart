import 'package:flutter/widgets.dart';
import 'package:haweyati/src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:haweyati_client_data_models/mixins/locale_mixin.dart';

void main() async {
  App.initializeAndRun();
  // WidgetsFlutterBinding.ensureInitialized();
  //
  // await AppData.initiate();
  // await Firebase.initializeApp();
  //
  // final _appData = AppData();
  // // fcm.onTokenRefresh.listen((event) {
  // //   if (_appData.isAuthenticated) {
  // //     EasyRest().$patch(
  // //       endpoint: 'fcm/token',
  // //       payload: _appData.user.profile..token = event
  // //     );
  // //   }
  // // });
  //
  // runApp(
  //   HaweyatiApp(
  //     locale: LocaleData.locale,
  //     status: await _appData.isFuseBurnt,
  //   ),
  // );
}
