import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/pages/miscellaneous/contact-input_page.dart';
import 'package:haweyati/src/ui/pages/miscellaneous/phone-number-input_page.dart';
import 'package:haweyati/src/ui/pages/otp-page.dart';
import 'package:haweyati/src/ui/widgets/contact-input-field.dart';
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati_client_data_models/utils/toast_utils.dart';

import '../const.dart';

Future verifyPhoneNumber(BuildContext context, String phone) async {
  final isVerified = await navigateTo(context, OtpVerificationPage(phone));
  if (isVerified == null) {
    showErrorToast("Phone Verification Canceled");
    return;
  } else if (!isVerified) {
    Navigator.of(context).pop();
    return null;
  }

  return phone;
}

Future getPhoneNumber(context) => navigateTo(context, ContactInputPage());

Future getVerifiedPhoneNumber(BuildContext context) async {
  final phone = await navigateTo(context, ContactInputPage());
  if (phone == null) {
    return null;
  }

  var isVerified;
  if(isDebugMode) isVerified = true;
  else isVerified = await navigateTo(context, OtpVerificationPage(phone));
  if (isVerified == null) {
    Scaffold.of(context)?.showSnackBar(SnackBar(
      content: Text("Your Phone Number wasn't verified"),
    ));
  } else if (!isVerified) {
    Navigator.of(context).pop();

    return null;
  }

  return phone;
}