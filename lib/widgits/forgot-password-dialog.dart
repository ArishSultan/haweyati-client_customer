import 'package:flutter/material.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/loading-dialog.dart';
import 'package:haweyati/src/utlis/validators.dart';
import 'message-dialog.dart';

class ForgotPasswordDialog extends StatefulWidget {
  @override
  State createState() => new ForgotPasswordDialogState();
}

class ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  var _formKey = GlobalKey<FormState>();
  bool _autoValidate =  false;
  var email = TextEditingController();

  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Text("Please provide email to reset password",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16
      ),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: TextFormField(
                    validator: (value) => emailValidator(value),
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 12.0),
                      border: OutlineInputBorder(),
                    )),
              ),
            ) ,
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Builder(
                  builder: (ctx) {
                    return RaisedButton(
                      child: Text(
                        "Submit", style: TextStyle(color: Colors.white),),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          FocusScope.of(context).requestFocus(FocusNode());
                          openLoadingDialog(context, "Submitting");
                          var res;
                          try {
                             res = await HaweyatiService.post('persons/forgotpassword', {
                              "email": email.text
                            });
                            print(email.text);
                            print(res.state['_id']);
                          }
                           catch (e) {
                            Navigator.of(context).pop();
                            openMessageDialog(context,
                              res.toString(),);
                            print(e);
                            return;
                          }

                          Navigator.pop(context);
                          Navigator.pop(context);
                          openMessageDialog(context,
                              'Please check your email for resetting password.');
                        }
                        else {
                          setState(() {
                            _autoValidate = true;
                          });
                        }
                      },
                      color: Theme
                          .of(context)
                          .accentColor,
                      shape: StadiumBorder(),
                    );
                  }
                ),
              ),
            ),

          ],
          ),
    );
  }

}
