import 'package:flutter/material.dart';

class UnableToPlaceOrderDialog extends StatelessWidget {
  final dynamic details;
  UnableToPlaceOrderDialog(this.details);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Unable to Place your order'),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(details.toString()),
          ),
          Text(details.stackTrace.toString())
        ],
      ),
      actions: [
        FlatButton(
          child: Text('OK'),
          shape: StadiumBorder(),
          onPressed: () => Navigator.of(context).pop()
        )
      ]
    );
  }
}