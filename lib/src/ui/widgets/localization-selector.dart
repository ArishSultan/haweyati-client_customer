import 'package:flutter/material.dart';
import 'package:haweyati/src/data.dart';

class LocalizationSelector extends StatelessWidget {
  LocalizationSelector();

  final _appData = AppData.instance();

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      isDense: true,
      underline: Container(),
      iconEnabledColor: Colors.white,
      icon: Icon(Icons.language, size: 20),
      dropdownColor: Color(0xFF313F53),

      value: _appData.currentLocale.value,

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
            child: Text('عربى', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        )
      ],

      onChanged: (val) async {
        if (_appData.currentLocale.value.languageCode == 'en') {
          _appData.locale = const Locale('ar');
        } else {
          _appData.locale = const Locale('en');
        }

      }
    );
  }
}