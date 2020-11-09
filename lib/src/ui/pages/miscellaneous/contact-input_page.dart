import 'package:flutter/material.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/ui/pages/auth/customer-registration_page.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/contact-input-field.dart';
import 'package:haweyati/src/utils/navigator.dart';

class ContactInputPage extends StatefulWidget {
  @override
  _ContactInputPageState createState() => _ContactInputPageState();
}

class _ContactInputPageState extends State<ContactInputPage> {
  var number = '';
  var status = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    navigateTo(context, CustomerRegistration(contact: '+923006309211',));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: HaweyatiAppBar(hideCart: true, hideHome: true),

      body: DottedBackgroundView(
        child: Column(children: [
          HeaderView(
            title: 'Contact Number',
            subtitle: 'your contact number will be used for verification',
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ContactInputField((phone, state) {
              if (state) {
                if (!status) {
                  setState(() => status = true);
                }
              } else {
                if (status) {
                  setState(() => status = false);
                }
              }

              number = phone;
            }),
          )
        ]),
      ),

      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FlatButton(
          color: Theme.of(context).primaryColor,
          disabledColor: Color(0x77FF974D),
          child: Image.asset(NextFeatureIcon, width: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28)
          ),
          onPressed: status ? () async {
            Navigator.of(context).pop(number);
          } : null,
        ),
      ),
    );
  }
}
