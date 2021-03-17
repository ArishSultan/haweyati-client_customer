import 'package:haweyati/src/base/theme.dart';
import 'package:haweyati/src/common/modals/confirmation-dialog.dart';
import 'package:haweyati/src/ui/pages/miscellaneous/features_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:haweyati/src/ui/widgets/controller_widget.dart';

import 'base/config.dart';
import 'routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'ui/pages/home_page.dart';
import 'ui/pages/miscellaneous/welcome_page.dart';

class App extends ControlledWidget<AppConfig> {
  static Future<void> initializeAndRun() async {
    return runApp(App._());
  }

  App._() : super(controller: AppConfig());

  @override
  _AppState createState() => _AppState();
}

class _AppState extends ControlledWidgetState<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.data,
      home: WelcomePage(),
      locale: widget.controller.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}


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
                    return WelcomePage();
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
