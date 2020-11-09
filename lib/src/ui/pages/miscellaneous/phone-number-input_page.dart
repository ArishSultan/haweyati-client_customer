import 'package:flutter/material.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/common/simple-form.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/contact-input-field.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';

class PhoneNumberInputPage extends StatefulWidget {
  PhoneNumberInputPage();

  @override
  _PhoneNumberInputPageState createState() => _PhoneNumberInputPageState();
}

class _PhoneNumberInputPageState extends State<PhoneNumberInputPage> {
  var _phone = '';
  var _status = false;

  final GlobalKey<SimpleFormState> key = GlobalKey<SimpleFormState>();

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      body: DottedBackgroundView(
        child: Column(children: [
          HeaderView(
            title: 'Hello',
            subtitle: 'Enter your phone number',
          ),
          ContactInputField((phone, status) {
            if (status) {
              if (!_status) {
                setState(() => _status = true);
              }

              _phone = phone;
            } else {
              if (_status) {
                setState(() => _status = false);
              }
            }
          }),
        ]),
      ),
      bottom: FlatButton(
        child: Image.asset(NextFeatureIcon),
        onPressed: _status ? () {
          Navigator.of(context).pop(_phone);
        } : null,
      ),
    );
  }
}
