import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/l10n/localization.dart';

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
      builder: (context, value, _) => CupertinoApp(
        locale: Locale('ar', 'AE'),
        routes: routes,

        initialRoute: /*status ? HOME_PAGE : */FEATURES_PAGE,

        supportedLocales: const [
          const Locale('en'),
          const Locale('ar', 'AE'),
        ],

        localizationsDelegates: [
          // HaweyatiLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
      ),
    )
  );
}
