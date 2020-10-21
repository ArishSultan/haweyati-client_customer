import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/utils/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';

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
    showDialog(
      context: context,
      builder: (context) => WaitingDialog(message: 'Verifying otp')
    );
    AuthCredential authCreds = PhoneAuthProvider.getCredential(verificationId: verId, smsCode: smsCode);
    UserCredential result = await auth.signInWithCredential(authCreds);
    if(result.user != null){
      Navigator.pop(context);
      print("Phone Auth verified");
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
              UserCredential result = await auth.signInWithCredential(credential);
            if(result.user != null){
              print("code verified");
            } else {
              print("wrong code specified");
            }
            } else {
              print("not completed");
            }
          });
        },
        timeout: const Duration(seconds: 5),
        verificationCompleted: (AuthCredential credential) async {
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setString('phone', inputNo);
          // Navigator.pop(context,true);
          // Navigator.pop(context,true);
        },
        verificationFailed: (exception) {
          print('${exception.message}');
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      appBar: HaweyatiAppBar(hideHome: true, hideCart: true),
      body: DottedBackgroundView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: <Widget>[
          HeaderView(
            title: 'Verification',
            subtitle: loremIpsum.substring(0, 70),
          ),
          Row(children: <Widget>[
            Text(widget.phoneNumber),
            SizedBox(width: 15),
            GestureDetector(
              onTap: ()=> Navigator.pop(context),
              child: Text('Change', style: TextStyle(color: Theme.of(context).accentColor))
            )
          ], mainAxisAlignment: MainAxisAlignment.center),
          SizedBox(height: 15),
          SizedBox(
            width: 220,
            child: Form(
              key: formKey,
              autovalidate: autoValidate,
              child: Row(children: <Widget>[
                _buildField(v1),
                SizedBox(width: 10),
                _buildField(v2),
                SizedBox(width: 10),
                _buildField(v3),
                SizedBox(width: 10),
                _buildField(v4),
                SizedBox(width: 10),
                _buildField(v5),
                SizedBox(width: 10),
                _buildField(v6, true)
              ]),
            ),
          ),
          Spacer(),
          _ResendTimer(
            gaps: [50, 120, 300],
            onResend: () {
              verifyNumber(widget.phoneNumber, context);
            }
          ),
          SizedBox(height: 15),
        ]),
      ));
  }


  Widget _buildField(TextEditingController controller,[bool last=false]){
    return Expanded(
      child: TextFormField(
        obscureText: true,
        controller: controller,
        validator: (value) => emptyValidator(value, 'code'),
        onChanged: (val){
          FocusScope.of(context).nextFocus();
          if (last) {
            if (formKey.currentState.validate()){
              typedCode = '';
              typedCode += v1.text + v2.text + v3.text + v4.text + v5.text + v6.text;
               signInWithOTP(typedCode,verificationId);
            } else {
            }
          }
        },
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: InputDecoration(
          hintText: "-",
          hintStyle: TextStyle(fontWeight: FontWeight.bold)
        ),
      )
    );
  }
}

class _ResendTimer extends StatefulWidget {
  final List<int> gaps;
  final Function onResend;

  _ResendTimer({this.gaps, this.onResend});

  @override
  __ResendTimerState createState() => __ResendTimerState();
}

class __ResendTimerState extends State<_ResendTimer> {
  var _allow = false;
  final _controller = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _startCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Text("Didn't receive a code?", style: TextStyle(
        color: Colors.grey.shade600
      )),
      SizedBox(height: 5),

      if (_allow)
        GestureDetector(
          onTap: () {
            widget.onResend();

            setState(() {
              _allow = false;
            });

            _startCounter();
          },
          child: Text('Resend Code', style: TextStyle(
            color: Theme.of(context).primaryColor
          ))
        )
      else
        StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Wait for ' + _buildTime(snapshot.data), style: TextStyle(
                color: Theme.of(context).primaryColor
              ));
            } else {
              return Text('...');
            }
          },
        )
    ], direction: Axis.vertical, crossAxisAlignment: WrapCrossAlignment.center);
  }

  static _buildTime(int seconds) {
    final _minutes = seconds > 60 ? seconds % 60 : 0;
    final _seconds = seconds - 60 * _minutes;

    return _minutes.toString().padLeft(2, '0')
        + ':' + _seconds.toString().padLeft(2, '0');
  }

  void _startCounter() async {
    var len = 10;

    while (len >= 0) {
      if (_controller.isClosed) return;
      await Future.delayed(Duration(seconds: 1), () {
        _controller.add(len--);
      });
    }

    setState(() { _allow = true; });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }
}
