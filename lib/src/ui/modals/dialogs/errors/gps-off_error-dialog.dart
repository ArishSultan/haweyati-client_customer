import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/widgets/buttons/dialog-action_button.dart';

class GPSErrorDialog extends AlertDialog {
  GPSErrorDialog(BuildContext context): super(
    title: Text('Location is Turned Off'),
    content: Text('Open your device settings and Turn On GPS'),
    actions: [
      DialogActionButton(
        label: 'ok',
        isPrimary: true,
        onPressed: () => Navigator.of(context).pop()
      )
    ]
  );
}