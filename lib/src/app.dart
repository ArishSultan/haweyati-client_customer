import 'routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:haweyati/l10n/app_localizations.dart';

class HaweyatiApp extends Theme {
  HaweyatiApp({
    bool status,
    ValueListenable<Locale> locale,
  }): super(
    data: ThemeData(
      appBarTheme: AppBarTheme(
        color: Color(0xFF313F53),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        brightness: Brightness.dark
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            print(states);
            return Color(0xFFFF974D);
          }),
          overlayColor: MaterialStateProperty.all(Color(0x33FFFFFF)),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(StadiumBorder())
        )
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        border: OutlineInputBorder()
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
      accentColor: Color(0xFFFF974D),
      primaryColor: Color(0xFFFF974D)
    ),
    child: ValueListenableBuilder(
      valueListenable: locale,
      builder: (context, value, _) {
        return CupertinoApp(
          locale: value,
          routes: routes,
          debugShowCheckedModeBanner: false,
          initialRoute: status ? HOME_PAGE : FEATURES_PAGE,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates
        );
      }
    )
  );
}
