import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future navigateTo(BuildContext context, Widget widget) {
  FocusScope.of(context)?.unfocus();

  return Navigator.of(context).push(
    CupertinoPageRoute(builder: (context) => widget)
  );
}