import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati/src/utils/validations.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/rest/_new/auth_service.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/location-picker.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/ui/pages/miscellaneous/terms-and-conditions_page.dart';

class CustomerRegistration extends StatefulWidget {
  final String contact;
  final Profile profile;
  final CustomerRegistrationType type;

  CustomerRegistration({this.contact, this.type, this.profile});

  @override
  _CustomerRegistrationState createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  String _name;
  String _password;
  String _confirmPass;

  var agreeToTerms = false;
  var autoValidate = false;
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _name = widget.profile?.name ?? '';
    _password = widget.profile?.password ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      key: scaffoldKey,
      appBar: HaweyatiAppBar(
        hideCart: true,
        hideHome: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Form(
          key: formKey,
          autovalidate: autoValidate,
          child: Column(children: <Widget>[
            HeaderView(
              title: 'Register Yourself',
              subtitle: 'Your Account will be created on the phone number that '
                  'you have provided i.e. ${widget.contact}',
            ),
            HaweyatiTextField(
              value: _name,
              label: 'Name',
              disabled: widget.type == CustomerRegistrationType.fromExisting,
              onSaved: (val) => _name = val,
              validator: (value) => emptyValidator(value, 'name'),
            ),
            SizedBox(height: 15),
            HaweyatiPasswordField(
              label: 'Password',
              disabled: widget.type == CustomerRegistrationType.fromExisting,
              onSaved: (password) => _password = password,
              validator: (value) {
                if (widget.profile != null && widget.type != CustomerRegistrationType.fromGuest) return null;
                return passwordValidator(value);
              },
            ),
            SizedBox(height: 15),
            HaweyatiPasswordField(
              label: 'Confirm Password',
              onSaved: (password) => _confirmPass = password,
              disabled: widget.type == CustomerRegistrationType.fromExisting,
              validator: (value) {
                if (widget.profile != null && widget.type != CustomerRegistrationType.fromGuest) return null;
                if (value.isEmpty) {
                  return 'Please confirm password';
                }
                if (_password != value) {
                  return 'Passwords don\'t match';
                }

                return null;
              },
            ),
            SizedBox(height: 15),
            Row(children: [
              Checkbox(
                value: agreeToTerms,
                visualDensity: VisualDensity.compact,
                onChanged: (val) => setState(() => agreeToTerms = val),
              ),
              Text.rich(TextSpan(
                text: 'Agree to ',
                children: [
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        navigateTo(context, TermsAndConditionsPage());
                      },
                  )
                ],
              )),
            ]),
            LocationPicker(
              initialValue: AppData().location,
              onChanged: (location) => AppData().location = location,
            )
          ], crossAxisAlignment: CrossAxisAlignment.start),
        ),
      ),
      bottom: RaisedActionButton(
        label: 'Register',
        onPressed: agreeToTerms
            ? () async {
                formKey.currentState.save();
                if (formKey.currentState.validate()) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  FocusScope.of(context).requestFocus(FocusNode());

                  showDialog(
                    context: context,
                    builder: (context) => WaitingDialog(
                      message: 'Registering, Please wait ...',
                    ),
                  );

                  try {
                    final customer = Customer()
                      ..profile = widget.profile ?? Profile(
                        name: _name,
                        password: _password,
                        contact: widget.contact,
                        deviceToken: await FirebaseMessaging.instance.getToken()
                      )
                      ..location = AppData().location;

                    if (widget.type == CustomerRegistrationType.new_) {
                      await AuthService.registerNewCustomer(customer);
                    } else if (widget.type == CustomerRegistrationType.fromGuest) {
                      final customer = Customer()
                        ..profile = Profile(
                          name: _name,
                          password: _password,
                          contact: widget.contact,
                            deviceToken: await FirebaseMessaging.instance.getToken()
                        )
                        ..location = AppData().location;
                      await AuthService.registerGuest(customer);
                    } else {
                      await AuthService.linkProfile(customer);
                    }
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) => WaitingDialog(
                        message:
                        'You have been registered, Now Signing you in.',
                      ),
                    );
                    await AuthService.signIn(SignInRequest(
                      username: widget.contact,
                      password: widget.profile?.password ?? _password,
                    ));
                    Navigator.of(context).popUntil((route) => false);
                    Navigator.of(context).pushNamed(HOME_PAGE);
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //     content: Text('You are now a registered customer.')));
                  } catch (e) {
                    Navigator.pop(context);
                    print(e);
                    // throw e;

                    // ScaffoldMessenger.of(context)
                    //     .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                } else {
                  setState(() => autoValidate = true);
                }
              }
            : null,
      ),
    );
  }
}

// customers/convert-guest
//3166787047