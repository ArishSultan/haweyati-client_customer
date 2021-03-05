import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:haweyati/src/rest/_new/auth_service.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/common/simple-form.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/widgets/contact-input-field.dart';
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati/src/ui/views/localized_view.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/widgets/localization-selector.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';
import 'package:haweyati/src/common/modals/confirmation-dialog.dart';
import 'package:haweyati/src/ui/pages/auth/reset-password_page.dart';
import 'package:haweyati/src/ui/pages/auth/customer-registration_page.dart';
import 'package:haweyati/src/utils/phone-verification.dart';
import 'package:haweyati_client_data_models/data.dart';

class SignInPage extends StatefulWidget {
  final String phone;
  SignInPage({this.phone});
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _data = SignInRequest();
  final _key = GlobalKey<SimpleFormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    if(widget.phone!=null)
      _data.username = widget.phone;

    print(widget.phone);
    print(_data.username);
  }



  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (context, lang) => Scaffold(
        key: _scaffoldKey,
        appBar: HaweyatiAppBar(
          hideCart: true,
          hideHome: true,
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: LocalizationSelector(),
              ),
            )
          ],
        ),
        body: DottedBackgroundView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Stack(children: [
            SimpleForm(
              key: _key,
              waitingDialog: WaitingDialog(message: 'Signing in ...'),
              onError: (err) async {
                print(err);
                if (err is DioError) {
                  if (err.response.statusCode == 401) {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Unable To Sign in'),
                            content: Text(
                                'No Customer account is associated with the provided Credentials'
                                '\n\n'
                                'Please provide correct Credentials or Register Yourself as a Customer'),
                          );
                        });
                  }

                  if (err.response.statusCode == 404) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'No Customer account was found, Please Register'),
                    ));
                  }
                }
              },
              afterSubmit: () {
                Navigator.of(context).pop();
              },
              onSubmit: () {
                FocusScope.of(context).unfocus();
                return AuthService.signIn(_data);
              },
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ListView(children: [
                  HeaderView(
                    title: lang.signIn,
                    subtitle: lang.enterCredentials,
                  ),
                  ContactInputField((value, status) {
                    _data.username = value;
                  },widget.phone),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: HaweyatiPasswordField(
                      context: context,
                      label: lang.yourPassword,
                      onSaved: (value) => _data.password = value,
                      validator: (value) =>
                          value.isEmpty ? 'Provide your Password' : null,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 300),
                      child: GestureDetector(
                        onTap: () async {
                          var num = verifyPhoneAndNavigateTo(
                            context,
                            (phone) => ResetPasswordPage(phoneNumber: phone),
                          );

                          // if (num == null) {
                          //   _scaffoldKey.currentState.showSnackBar(SnackBar(
                          //     content: Text('No Number was Entered'),
                          //   ));
                          // }
                        },
                        child: Text(
                          lang.forgotPassword,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
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
                  onTap: () async {
                    final number = await getPhoneNumber(context);
                    if (number == null) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('No Number was provided'),
                      ));
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (context) =>
                          WaitingDialog(message: 'Preparing for Registration'),
                    );
                    final registerType =
                        await AuthService.prepareForRegistration(
                            context, number);
                    Navigator.of(context).pop();

                    if (registerType[0] == CustomerRegistrationType.noNeed) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text(
                            'You are already a customer please Sign in or use '
                            'Forgot password button',
                          ),
                        ),
                      );
                    } else {
                      if (registerType[0] ==
                          CustomerRegistrationType.fromExisting) {
                        final flag = await showDialog(
                            context: context,
                            builder: (context) => ConfirmationDialog(
                                  title: Text('NOTE!'),
                                  content: Text(
                                      'Your customer account will be linked to the business account!'),
                                ));

                        if (flag == true) {
                          final verify =
                              await verifyPhoneNumber(context, number);
                          if (verify == null) {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text('Phone not verified')));
                            return;
                          }

                          navigateTo(
                              context,
                              CustomerRegistration(
                                contact: number,
                                profile: registerType[1],
                                type: registerType[0],
                              ));
                        }
                      }

                      if (registerType[0] ==
                          CustomerRegistrationType.fromGuest) {
                        final verify = await verifyPhoneNumber(context, number);
                        if (verify == null) {
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text('Phone not verified')));
                          return;
                        }
                        navigateTo(
                            context,
                            CustomerRegistration(
                              contact: number,
                              profile: registerType[1],
                              type: registerType[0],
                            ));
                      }

                      if (registerType[0] == CustomerRegistrationType.new_) {
                        final verify = await verifyPhoneNumber(context, number);
                        if (verify == null) {
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text('Phone not verified')));
                        }

                        navigateTo(
                            context,
                            CustomerRegistration(
                              contact: number,
                              type: registerType[0],
                            ));
                      }
                    }
                  },
                  child: Text(
                    'Register Yourself',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            )
          ]),
        ),
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          heroTag: 'none',
          child: Transform.rotate(
            angle: AppLocalizations.of(context).localeName == 'ar' ? 3.14 : 0,
            child: Image.asset(NextFeatureIcon, width: 30),
          ),
          onPressed: () => _key.currentState.submit(),
        ),
      ),
    );
  }
}
