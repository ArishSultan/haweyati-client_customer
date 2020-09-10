import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haweyati/services/phone-auth-service.dart';
import 'package:haweyati/src/ui/widgets/loading-dialog.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/src/utlis/validators.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationPhoneNumber extends StatefulWidget {
  final String phoneNumber;
  VerificationPhoneNumber({this.phoneNumber}):assert(phoneNumber!=null);
  @override
  _VerificationPhoneNumberState createState() =>
      _VerificationPhoneNumberState();
}

class _VerificationPhoneNumberState extends State<VerificationPhoneNumber> {
  static String smsCode;
  static String verificationId;
  FirebaseAuth auth = FirebaseAuth.instance;
  var formKey = GlobalKey<FormState>();
  bool autoValidate=false;
  TextEditingController v1 = TextEditingController();
  TextEditingController v2 = TextEditingController();
  TextEditingController v3 = TextEditingController();
  TextEditingController v4 = TextEditingController();
  TextEditingController v5 = TextEditingController();
  TextEditingController v6 = TextEditingController();
  int time = 50;
  String typedCode = '';


  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  signInWithOTP(smsCode, verId) async {
    openLoadingDialog(context, "Verifying otp...");
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    AuthResult result = await auth.signInWithCredential(authCreds);
    if(result.user != null){
      Navigator.pop(context);
      print("Phone Auth verified");
//      Navigator.pop(context,true);
//      Navigator.pop(context,true);
    } else {
      Navigator.pop(context);
      print("Not verified");
    }
  }

  @override
  void initState() {
    super.initState();
    verifyNumber(widget.phoneNumber, context);
  }

  Future verifyNumber(String inputNo,BuildContext context) async{
    await auth.verifyPhoneNumber(
        phoneNumber: inputNo,
        codeAutoRetrievalTimeout: (String verID) {
          verificationId=verID;
        },
        codeSent: (String verID,[int forceCodeResend]) async {
          verificationId = verID;
          v6.addListener(() async {
            if(v6.text.isNotEmpty) {
              print("Completed");
              print(typedCode);
              AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verID, smsCode: smsCode);
              AuthResult result = await auth.signInWithCredential(credential);
            if(result.user != null){
              print("code verified");
            } else {
              print("wrong code specified");
            }
            } else {
              print("not completed");
            }
          });
//          if(v6.text.isNotEmpty){
//            print("Called to complete");
//
//          }
        },
        timeout: const Duration(seconds: 5),
        verificationCompleted: (AuthCredential credential) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('phone', inputNo);
          Navigator.pop(context,true);
          Navigator.pop(context,true);
        },
        verificationFailed: (AuthException exception){
          print('${exception.message}');
        }
    );
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

//                FlatButton(
//                  child: Text('asdasd'),
//                  onPressed: () {
//                    auth.completer.complete();
//                  },
//                )
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
                typedCode = '';
                typedCode+=v1.text+v2.text+v3.text+v4.text+v5.text+v6.text;
                signInWithOTP(typedCode,verificationId);
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
