import 'package:dio/dio.dart';
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
          if (details is! DioError)
            Text(details?.stackTrace.toString())
          else Text('Error')
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