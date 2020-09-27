import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/routes.dart';

import 'routes.dart';

class HaweyatiApp extends StatelessWidget {
  final bool status;
  HaweyatiApp(this.status);

  @override
  Widget build(BuildContext context) {
    return Theme(
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
      child: CupertinoApp(
        routes: routes,
        locale: context.locale,
        initialRoute: status ? HOME_PAGE : FEATURES_PAGE,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
      )
    );
  }
}