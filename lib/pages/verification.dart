import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haweyati/services/phone-auth-service.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/src/utlis/validators.dart';
import 'package:haweyati/widgits/appBar.dart';

class VerificationPhoneNumber extends StatefulWidget {
  final String phoneNumber;
  VerificationPhoneNumber({this.phoneNumber}):assert(phoneNumber!=null);
  @override
  _VerificationPhoneNumberState createState() =>
      _VerificationPhoneNumberState();
}

class _VerificationPhoneNumberState extends State<VerificationPhoneNumber> {
  FirebasePhoneAuth auth;
  var formKey = GlobalKey<FormState>();
  bool autoValidate=false;
  TextEditingController v1 = TextEditingController();
  TextEditingController v2 = TextEditingController();
  TextEditingController v3 = TextEditingController();
  TextEditingController v4 = TextEditingController();
  TextEditingController v5 = TextEditingController();
  TextEditingController v6 = TextEditingController();
  int time = 50;

  @override
  void initState() {
    super.initState();
    phoneVerification();
  }

  phoneVerification() async {
   auth = FirebasePhoneAuth()..verifyNumber(widget.phoneNumber, context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HaweyatiAppBar(context: context,),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
                alignment: Alignment(0, 0.95),
                child: GestureDetector(
                    onTap: () {

                    },
                    child:Text(
                      time != 0 ?
                      "Please Wait 0:$time " : 'Resend',
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).accentColor),
                    ))),
            Align(
                alignment: Alignment(0, 0.85),
                child: Text(
                  "Didn't receive a code ?",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Verification",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
                  child: Text(
                    loremIpsum.substring(0,70),
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.phoneNumber),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: ()=> Navigator.pop(context),
                        child: Text(
                      "Change",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 15, 70, 100),
                  child: Form(
                    key: formKey,
                    autovalidate: autoValidate,
                    child: Row(
                      children: <Widget>[
                        _buildField(v1),
                        _buildField(v2),
                         _buildField(v3),
                        _buildField(v4),
                         _buildField(v5),
                        _buildField(v6,true)
                      ],
                    ),
                  ),
                ),

                FlatButton(
                  child: Text('asdasd'),
                  onPressed: () {
                    auth.completer.complete();
                  },
                )
              ],
            )
          ],
        ));
  }


  Widget _buildField(TextEditingController controller,[bool last=false]){
    return Expanded(
        child: TextFormField(
          obscureText: true,
          controller: controller,
          validator: (value)=> emptyValidator(value, 'code'),
          onChanged: (val){
            FocusScope.of(context).nextFocus();
            if(last) {
              if (formKey.currentState.validate()){
                print("Verify OTP and navigate to next page");
              }else{
                //set autovalidate to true
              }
          }
          },
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: InputDecoration(
              hintText: "-",
              hintStyle: TextStyle(fontWeight: FontWeight.bold)),
        ));
  }
}
