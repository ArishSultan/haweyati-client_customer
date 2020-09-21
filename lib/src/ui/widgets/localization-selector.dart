import 'package:flutter/material.dart';

class LocalizationSelector extends StatelessWidget {
  final Locale selected;
  final Function onChanged;

  LocalizationSelector({
    this.selected,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      isDense: true,
      iconEnabledColor: Colors.white,
      icon: Icon(Icons.language, size: 20),
      underline: Container(),
      dropdownColor: Color(0xFF313F53),

      value: this.selected ?? Locale('ar'),

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
            child: Text('Arabic', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        )
      ],

      onChanged: this.onChanged,
    );
  }
}