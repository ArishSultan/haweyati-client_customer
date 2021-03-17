import 'package:flutter/cupertino.dart';

class AppConfig extends ChangeNotifier {
  AppConfig._();

  factory AppConfig() => _instance;

  static AppConfig _instance = AppConfig._();

  Locale get locale => _locale;
  Locale _locale = Locale('en');

  set locale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
