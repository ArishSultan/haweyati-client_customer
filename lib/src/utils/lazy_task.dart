import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pedantic/pedantic.dart';

Future<dynamic> performLazyTask(
  BuildContext context,
  Future<dynamic> Function()  task,  {
  String message = 'Please Wait',
  bool persistent = true,
}) async {

  FocusScope.of(context).requestFocus(FocusNode());
  FocusScope.of(context).requestFocus(FocusNode());

  if (persistent) {
    unawaited(openLoadingDialog(context, message));
  } else {
    unawaited(openLoadingDialog(context, message));
  }

  final result = await task();
  if(Navigator.canPop(context))
    Navigator?.of(context)?.pop();

  return result;
}

openLoadingDialog(BuildContext context, String text) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(children: <Widget>[
          SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation(Colors.black))),
          SizedBox(width: 10),
          Expanded(child: Text(text + "..."))
        ]),
      ));
}