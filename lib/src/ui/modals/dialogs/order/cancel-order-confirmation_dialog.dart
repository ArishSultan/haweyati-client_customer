import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/widgets/buttons/dialog-action_button.dart';

class CancelOrderConfirmationDialog extends StatelessWidget {
  static const title = 'Are you sure?';
  static const message = 'You are in a middle of placing an order, '
      'if you go back your progress will be lost, '
      'Do you really want to go back?';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(15),
      title: Text(title),
      content: Text(message),

      actions: [
        DialogActionButton(
          label: 'yes',
          onPressed: () => Navigator.of(context).pop(false)
        ),
        DialogActionButton(
          label: 'no',
          isPrimary: true,
          onPressed: () => Navigator.of(context).pop(true)
        )
      ]
    );
  }
}
