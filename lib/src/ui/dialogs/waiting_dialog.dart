import 'package:flutter/material.dart';

class WaitingDialog extends Dialog {
  WaitingDialog({
    String message = 'Waiting for task completion ...'
  }): super(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(children: [
        SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          )
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(message, style: TextStyle(
              fontSize: 16
            )),
          ),
        )
      ]),
    ),
  );
}