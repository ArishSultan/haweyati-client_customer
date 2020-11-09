import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/pages/miscellaneous/contact-input_page.dart';
import 'package:haweyati/src/ui/pages/miscellaneous/phone-number-input_page.dart';
import 'package:haweyati/src/ui/pages/otp-page.dart';
import 'package:haweyati/src/ui/widgets/contact-input-field.dart';
import 'package:haweyati/src/utils/navigator.dart';

Future getVerifiedPhoneNumber(BuildContext context) async {
  final phone = await navigateTo(context, ContactInputPage());
  if (phone == null) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
      content: Text("You didn't enter a Phone Number"),
    ));

    return 0;
  }

  final isVerified = await navigateTo(context, OtpVerificationPage(phone));
  if (isVerified == null) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
      content: Text("Your Phone Number wasn't verified"),
    ));
  } else if (!isVerified) {
    Navigator.of(context).pop();

    return null;
  }

  return phone;
}