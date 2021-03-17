import 'package:flutter/material.dart';

abstract class AppTheme {
  static const accentColor = Color(0xFFFF974D);

  static const primaryColor = accentColor;
  static const primaryColor2 = Color(0xFF313F53);

  static final data = ThemeData(
    accentColor: accentColor,
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(
      color: primaryColor2,
    ),
    backgroundColor: Color(0xffffffff),
  );
}
