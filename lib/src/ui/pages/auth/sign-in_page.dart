import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/common/simple-form.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/common/models/serializable.dart';
import 'package:haweyati/src/common/services/jwt-auth_service.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';

class _SignInData extends Serializable {
  String username;
  String password;

  @override serialize() => {
    'username': username,
    'password': password
  };
}

class SignInPage extends StatelessWidget {
  final _data = _SignInData();
  final _key = GlobalKey<SimpleFormState>();

  @override
  Widget build(BuildContext context) {
    return ScrollableView(
      appBar: const HaweyatiAppBar(hideCart: true, hideHome: true),
      showBackground: true,
      child: SimpleForm(
        key: _key,
        waitingDialog: WaitingDialog(message: 'Signing in ...'),
        onError: (err) async {
          print(err);
          print('here');
          if (err is UnAuthorizedError) {
            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Username or Password is incorrect'),
                );
              }
            );
          }
        },
        afterSubmit: () => Navigator
          .of(context)
          .pushNamedAndRemoveUntil(HOME_PAGE, (route) => false),

        onSubmit: () => JwtAuthService.create().$signIn(_data),

        child: Column(children: [
          HeaderView(
            title: 'Sign in',
            subtitle: 'Enter your Credentials',
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: HaweyatiTextField(
              label: 'Your Phone #',
              controller: TextEditingController(text: '+923317079787'),
              onSaved: (value) => _data.username = value,
            ),
          ),

          HaweyatiPasswordField(
            label: 'Your Password',
            context: context,
            controller: TextEditingController(text: '12345678'),
            onSaved: (value) => _data.password = value,
            validator: (value) => value.isEmpty ? 'Provide your Password' : null,
          )
        ]),
      ),
      bottom: Container(
        height: 110,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              child: Text('Forgot password?',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).accentColor,
                )
              ),
              onTap: () => Navigator.of(context).pushNamed('/'),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FloatingActionButton(
              elevation: 0,
              child: Image.asset(NextFeatureIcon, width: 30),
              onPressed: () => _key.currentState.submit()
            ),
          )
        ])
      ),
    );
  }
}
