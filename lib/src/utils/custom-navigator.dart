import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomNavigator {
  static navigateTo(context, widget) {
    return Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) => widget)
    );
  }

  static pushReplacement(context,widget) {
    return Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (BuildContext context) => widget),(Route<dynamic> route) => false);
  }
}

Future navigateTo(BuildContext context, Widget widget) {
  return Navigator.of(context).push(
    CupertinoPageRoute(builder: (context) => widget)
  );
}