import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebasePhoneAuth{
 final completer = Completer();
     static String smsCode;
     static String verificationId;
     static FirebaseAuth auth = FirebaseAuth.instance;

   Future verifyNumber(String inputNo,BuildContext context) async{
    await auth.verifyPhoneNumber(
        phoneNumber: inputNo,
        codeAutoRetrievalTimeout: (String verID) {
          verificationId=verID;
        },
        codeSent: (String verID,[int forceCodeResend]) async {
          await this.completer.future;

          final credential = PhoneAuthProvider.credential(
            verificationId: verID, smsCode: '00'
          );

          UserCredential result = await auth.signInWithCredential(credential);
          if(result.user != null){
            print("code verified");
          } else {
            print("wrong code specified");
          }
        },
        timeout: const Duration(seconds: 5),
        verificationCompleted: (AuthCredential credential) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('phone', inputNo);
          Navigator.pop(context);
          Navigator.pop(context);
        },

        verificationFailed: (exception){
          print('${exception.message}');
        }
    );
  }

}

