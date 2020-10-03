import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/l10n/app_localizations.dart';
import 'package:haweyati/src/common/simple-form.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/localized_view.dart';
import 'package:haweyati/src/common/models/serializable.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/common/services/jwt-auth_service.dart';
import 'package:haweyati/src/ui/widgets/localization-selector.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';

class _SignInData extends Serializable {
  String username;
  String password;

  @override serialize() => {
    'username': username,
    'password': password
  };
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _data = _SignInData();
  final _key = GlobalKey<SimpleFormState>();

  @override
  Widget build(BuildContext context) {
    return LocalizedView(builder: (context, lang) => Scaffold(
      appBar: HaweyatiAppBar(
        hideCart: true,
        hideHome: true,
        actions: [Center(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: LocalizationSelector(),
        ))],
      ),
      body: DottedBackgroundView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Stack(children: [
          SimpleForm(
            key: _key,
            waitingDialog: WaitingDialog(message: 'Signing in ...'),
            onError: (err) async {
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
            afterSubmit: () => Navigator.of(context)
              .pushNamedAndRemoveUntil(HOME_PAGE, (route) => false),

            onSubmit: () => JwtAuthService.create().$signIn(_data),

            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ListView(children: [
                HeaderView(
                  title: lang.signIn,
                  subtitle: lang.enterCredentials,
                ),

                HaweyatiTextField(
                  label: lang.yourPhone,
                  scrollPadding: const EdgeInsets.all(300),
                  controller: TextEditingController(text: '+923317079787'),
                  onSaved: (value) => _data.username = value,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 100),
                  child: HaweyatiPasswordField(
                    context: context,
                    label: lang.yourPassword,
                    controller: TextEditingController(text: '12345677'),
                    onSaved: (value) => _data.password = value,
                    validator: (value) => value.isEmpty ? 'Provide your Password' : null,
                  ),
                )
              ]),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                onTap: () {
                  print('Forgot Password');
                },
                child: Text(lang.forgotPassword, style: TextStyle(
                  color: Theme.of(context).primaryColor
                ))
              ),
            )
          )
        ]),
      ),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: Transform.rotate(
          angle: AppLocalizations.of(context).localeName == 'ar' ? 3.14: 0,
          child: Image.asset(NextFeatureIcon, width: 30)
        ),
        onPressed: () => _key.currentState.submit()
      )
    ));
  }
}
