import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/common/modals/confirmation-dialog.dart';
import 'package:haweyati/src/common/modals/util.dart';
import 'package:haweyati/src/common/services/easy-rest/easy-rest.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/profile_model.dart';
import 'package:haweyati/src/models/user_model.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/l10n/app_localizations.dart';
import 'package:haweyati/src/common/simple-form.dart';
import 'package:haweyati/src/ui/pages/auth/customer-registration_page.dart';
import 'package:haweyati/src/ui/pages/miscellaneous/contact-input_page.dart';
import 'package:haweyati/src/ui/reset-password_page.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/localized_view.dart';
import 'package:haweyati/src/common/models/serializable.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/common/services/jwt-auth_service.dart';
import 'package:haweyati/src/ui/widgets/localization-selector.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class SignInData extends Serializable {
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
  final _data = SignInData();
  final _key = GlobalKey<SimpleFormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LocalizedView(builder: (context, lang) => Scaffold(
      key: _scaffoldKey,
      appBar: HaweyatiAppBar(
        hideCart: true, hideHome: true,
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

              if (err is DioError) {
                if (err.response.statusCode == 404) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('No Customer account was found, Please Register')
                  ));
                }
              }
            },
            afterSubmit: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(HOME_PAGE, (route) => false);
            },
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
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: HaweyatiPasswordField(
                    context: context,
                    label: lang.yourPassword,
                    controller: TextEditingController(text: '12345677'),
                    onSaved: (value) => _data.password = value,
                    validator: (value) => value.isEmpty ? 'Provide your Password' : null,
                  ),
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 300),
                    child: GestureDetector(
                      onTap: () async {
                        final number = await navigateTo(context, ContactInputPage());
                        if (number != null) {
                          navigateTo(context, ResetPasswordPage(phoneNumber: number));
                        }
                      },
                      child: Text(lang.forgotPassword, style: TextStyle(
                        color: Theme.of(context).primaryColor
                      ))
                    ),
                  )
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
                  final number = await navigateTo(context, ContactInputPage());
                  if (number != null) {
                    showDialog(
                      context: context,
                      builder: (context) => WaitingDialog(
                        message: 'Preparing for Registration',
                      )
                    );
                    final service = await EasyRest().$getOne(route: 'persons/contact/$number');
                    Navigator.of(context).pop();
                    print('Service');
                    print(service);

                    if (service != null) {
                      final result = await showConfirmationDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          content: Text('This contact is already linked to other accounts i.e. Driver or Supplier'
                              'Do You also want to link a customer account to this number?'),
                        )
                      );

                      if (result ?? false) {
                        await EasyRest().$post(endpoint: 'customers', payload: User(
                          profile: Profile.fromJson(service),
                          location: AppData.instance().location
                        ));
                      }
                    } else {
                      navigateTo(context, CustomerRegistration(contact: number));
                    }
                  }
                },
                child: Text('Register Yourself', style: TextStyle(
                  color: Theme.of(context).primaryColor
                ))
              ),
            )
          )
        ]),
      ),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        heroTag: 'none',
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
