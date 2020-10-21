import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/common/services/jwt-auth_service.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/pages/auth/sign-in_page.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/ui/widgets/location-picker.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';
import 'package:haweyati/src/utils/validators.dart';

class CustomerRegistration extends StatefulWidget {
  final String contact;
  CustomerRegistration({this.contact});

  @override
  _CustomerRegistrationState createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  String _name;
  String _password;
  String _confirmPassword;

  var autoValidate = false;
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      key: scaffoldKey,
      appBar: HaweyatiAppBar(hideCart:true,hideHome: true,),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Form(
          key: formKey,
          autovalidate: autoValidate,
          child: Column(children: <Widget>[
            HeaderView(
              title: 'Register Yourself',
              subtitle: 'Provide your Personal Information',
            ),
            HaweyatiTextField(
              value: _name,
              label: 'Name',
              onSaved: (val) => _name = val,
              validator: (value) => emptyValidator(value, 'name'),
            ),
            SizedBox(height: 15),
            AbsorbPointer(
              absorbing: true,
              child: HaweyatiTextField(
                label: 'Contact',
                value: widget.contact,
                keyboardType: TextInputType.number
              ),
            ),
            SizedBox(height: 15),
            HaweyatiPasswordField(
              label: 'Password',
              onSaved: (password) => _password = password,
              validator: (value) => passwordValidator(value)
            ),
            SizedBox(height: 15),
            HaweyatiPasswordField(
              label: 'Confirm Password',
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please confirm password';
                } if (_password != _confirmPassword) {
                  // return 'Passwords don\'t match';
                }
                return null;
              }
            ),
            SizedBox(height: 15),
            LocationPicker(
              initialValue: AppData.instance().location,
              onChanged: (location) => AppData.instance().location = location
            )
          ]),
        )
      ),

      bottom: RaisedActionButton(
        label: 'Register',
        onPressed: () async {
          formKey.currentState.save();
          if (formKey.currentState.validate()) {

            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).requestFocus(FocusNode());

            final location = AppData.instance().location;
            FormData data = FormData.fromMap({
              'name': _name,
              'scope': 'customer',
              'password': _password,
              'email': DateTime.now(),
              'address': location.address,
              'contact' : widget?.contact,
              'latitude': location.latitude,
              'longitude': location.longitude,
            });

            showDialog(
              context: context,
              builder: (context) => WaitingDialog(message: 'Registering, Please wait ...')
            );

            var res;
            try {
              res = await HaweyatiService.post('customers', data);
              await JwtAuthService.create().$signIn(SignInData()
                ..username = widget.contact
                ..password = _password
              );

              Navigator.of(context).pushNamed(HOME_PAGE);
            } catch (e) {
              Navigator.pop(context);
              scaffoldKey.currentState.showSnackBar(
                SnackBar(content: Text(e.toString()))
              );
            }
          } else {
            setState(() { autoValidate = true; });
          }
        }
      ),
    );
  }
}
