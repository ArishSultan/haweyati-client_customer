import 'package:flutter/material.dart';

class GPSErrorDialog extends AlertDialog {
  GPSErrorDialog(BuildContext context): super(
    title: Text('Location is Turned Off'),
    content: Text('Turn on device GPS'),
    actions: [
      FlatButton(
        child: Text('OK'),
        shape: StadiumBorder(),
        onPressed: () => Navigator.of(context).pop()
      )
    ]
  );
}