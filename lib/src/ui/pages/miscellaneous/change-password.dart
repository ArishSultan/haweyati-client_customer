import 'package:flutter/material.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool loading = false;
  bool autoValidate = false;

  var _formKey = GlobalKey<FormState>();
  var key = GlobalKey<ScaffoldState>();

  String _oldPassword;
  String _newPassword;
  String _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      key: key,
      appBar: HaweyatiAppBar(hideCart: true, hideHome: true),
      body: Form(
        key: _formKey,
        autovalidate: autoValidate,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(children: <Widget>[
            HaweyatiPasswordField(
              label: "Old Password",
              validator: (value) {
                return value.isEmpty ? "Please Enter Old Password" : null;
              },
              onSaved: (val) => _oldPassword = val,
              context: context,
            ),
              SizedBox(height: 15,),
            HaweyatiPasswordField(
              label: "New Password",
              validator: (value) {
                if (value.length < 8)
                  return 'Password must be at least 8 characters';
                return value.isEmpty ? "Please Enter New Password" : null;
              },
              onSaved: (val) => _newPassword = val,
              context: context,
            ),

            SizedBox(height: 15,),
            HaweyatiPasswordField(
              label: "Confirm Password",
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Enter Confirm Password';
                } if (_newPassword != _confirmPassword) {
                  return 'New and Confirm Passwords not matched';
                }

                return null;
              },
              onSaved: (val) => _confirmPassword = val,
              context: context,
            ),
            SizedBox(height: 15,),
          ]),
        )
      ),

      bottom: FlatActionButton(
        label: 'Change Password',

        onPressed: () async {
          if(_formKey.currentState.validate()){
            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).requestFocus(FocusNode());

            showDialog(
              context: context,
              builder: (context) => WaitingDialog()
            );

            var change = {
              '_id': AppData.instance().user.profile.id,
              'old': _oldPassword,
              'password': _newPassword,
            };
            var res = await HaweyatiService.patch('persons/update-password', change);
            try {
              Navigator.pop(context);
              key.currentState.showSnackBar(
                SnackBar(content: Text('Your password has been updated successfully!'))
              );
            } catch (e) {
              Navigator.pop(context);
              key.currentState.hideCurrentSnackBar();
              key.currentState.showSnackBar(
                SnackBar(content: Text(res.toString()))
              );
            }

          } else {
            setState(() {
              autoValidate=true;
            });
          }
        }
      ),
    );
  }
}
