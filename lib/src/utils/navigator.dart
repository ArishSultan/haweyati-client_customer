import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/utils/phone-verification.dart';

Future navigateTo(BuildContext context, Widget widget) {
  FocusScope.of(context)?.unfocus();

  return Navigator.of(context)
      .push(CupertinoPageRoute(builder: (context) => widget));
}

Future verifyPhoneAndNavigateTo(
  BuildContext context,
  Widget Function(String phone) builder,
) async {
  while (true) {
    final phone = await getVerifiedPhoneNumber(context);
    if (phone == null) {
      // Navigator.of(context).pop();
      return;
    }
    if (phone != null) {
      return navigateTo(context, builder(phone));
    }
  }
}
