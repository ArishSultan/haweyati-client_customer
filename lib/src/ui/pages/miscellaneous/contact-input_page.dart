import 'package:flutter/material.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/ui/pages/otp-page.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

// ignore: must_be_immutable
class ContactInputPage extends StatelessWidget {
  String contact;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: HaweyatiAppBar(
        hideCart: true, hideHome: true
      ),

      body: Form(
        key: _formKey,
        child: DottedBackgroundView(
          child: Column(children: [
            HeaderView(
              title: 'Contact Number',
              subtitle: 'your contact number will be used for verification',
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: HaweyatiTextField(
                label: 'Your Contact #',
                hint: '500303339',
                onSaved: (val) => contact = val,
                keyboardType: TextInputType.phone,
                validator: (val) {
                  return val.isEmpty ? 'Contact is Required' : null;
                }
              ),
            )
          ]),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: Image.asset(NextFeatureIcon, width: 30),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            var result = await navigateTo(context, OtpPage(
              phoneNumber: contact
            ));
            if (result == null) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Phone Number is not verified')
              ));
            }

            if (result ?? false) {
              Navigator.of(context).pop(contact);
            }
          }
        },
      ),
    );
  }
}
