import 'package:flutter/material.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/pages/auth/sign-in_page.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class ResetPasswordPage extends StatefulWidget {
  final String phoneNumber;
  ResetPasswordPage({this.phoneNumber});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool loading = false;
  bool autoValidate = false;

  var _formKey = GlobalKey<FormState>();
  var key = GlobalKey<ScaffoldState>();

  TextEditingController newPass = new TextEditingController();
  TextEditingController confirmPass = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return NoScrollView(
      key: key,
      appBar: HaweyatiAppBar(hideHome: true, hideCart: true),
      body: Form(
        key: _formKey,
        autovalidate: autoValidate,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(children: <Widget>[
            HaweyatiPasswordField(
              label: "New Password",
              controller :newPass,
              validator: (value) {
                if (value.length < 8)
                  return 'Password must be at least 8 characters';
                return value.isEmpty ? "Please Enter New Password" : null;
              },
              context: context,
            ),
            SizedBox(height: 15),
            HaweyatiPasswordField(
              context: context,
              label: "Confirm Password",
              controller:confirmPass,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Enter Confirm Password';
                } if (newPass.text != confirmPass.text) {
                  return 'New and Confirm Passwords not matched';
                }

                return null;
              }
            )
          ])
        )
      ),

      bottom: FlatActionButton(
        label: 'Proceed',
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).requestFocus(FocusNode());

            showDialog(
              context: context,
              builder: (context) => WaitingDialog(message: 'Resetting your password...')
            );
            var change = {
              'contact' : widget.phoneNumber,
              'password' : newPass.text,
            };

            var res = await HaweyatiService
                .post('persons/contact/change-password', change);

            try {
              Navigator.pop(context);

              await key.currentState.showSnackBar(SnackBar(
                content: Text('Your password has been changed successfully!')
              )).closed;

              Navigator.pop(context);
            } catch (e) {
              Navigator.pop(context);
              key.currentState.hideCurrentSnackBar();
              key.currentState.showSnackBar(SnackBar(content: Text(res.toString())));
            }
          } else {
            setState(() {
              autoValidate = true;
            });
          }
        }
      ),
    );
  }
}
