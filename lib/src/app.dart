import 'package:haweyati/src/common/modals/confirmation-dialog.dart';
import 'package:haweyati/src/ui/pages/miscellaneous/features_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'ui/pages/home_page.dart';

class HaweyatiApp extends Theme {
  HaweyatiApp({
    bool status,
    ValueListenable<Locale> locale,
  }) : super(
          data: ThemeData(
            appBarTheme: AppBarTheme(
              color: Color(0xFF313F53),
              iconTheme: IconThemeData(color: Colors.white),
              brightness: Brightness.dark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    print(states);
                    return Color(0xFFFF974D);
                  },
                ),
                overlayColor: MaterialStateProperty.all(Color(0x33FFFFFF)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(StadiumBorder()),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              isDense: true,
              border: OutlineInputBorder(),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            accentColor: Color(0xFFFF974D),
            primaryColor: Color(0xFFFF974D),
          ),
          child: ValueListenableBuilder(
            valueListenable: locale,
            builder: (context, value, _) {
              return CupertinoApp(
                locale: value,
                routes: routes,
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Builder(builder: (context) {
                    if (status) {
                      return HomePage();
                    } else {
                      return FeaturesPage();
                    }
                  }),
                ),
                // initialRoute: status ? HOME_PAGE : FEATURES_PAGE,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
              );
            },
          ),
        );
}
