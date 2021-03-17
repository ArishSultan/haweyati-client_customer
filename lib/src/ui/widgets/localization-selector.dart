// @dart=2.12

import 'package:flutter/material.dart';
import 'package:haweyati/src/base/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';

class LocalizationSelector extends StatelessWidget {
  LocalizationSelector();

  final _appConfig = AppConfig();

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      isDense: true,
      underline: Container(),
      iconEnabledColor: Colors.white,
      icon: Icon(Icons.language, size: 20),
      dropdownColor: Color(0xFF313F53),

      value: _appConfig.locale,

      items: [
        DropdownMenuItem(
          value: Locale('en'),
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text('English', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ),

        DropdownMenuItem(
          value: Locale('ar'),
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text('العربية', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        )
      ],

      onChanged: (val) async {
        if (_appConfig.locale.languageCode != val?.languageCode) {
          /// Create 2s delay for smooth translation
          showDialog(
            context: context,
            builder: (context) => WaitingDialog(
              message: AppLocalizations.of(context)?.changingLanguage
            )
          );
          _appConfig.locale = val; //await Future.delayed(Duration(seconds: 1), () => val);
          Navigator.of(context).pop();
        }
      }
    );
  }
}