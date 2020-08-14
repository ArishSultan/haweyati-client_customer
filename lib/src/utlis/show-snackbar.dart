
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackbar(GlobalKey<ScaffoldState> key, String message,[bool error=false]){
   key.currentState.showSnackBar(SnackBar(
     backgroundColor: error? Colors.red : Colors.black,
    content: Text(message,),
     behavior: SnackBarBehavior.floating,
  ));
}