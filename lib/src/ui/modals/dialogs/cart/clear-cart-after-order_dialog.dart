import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati_client_data_models/data.dart';

class ClearCartAfterOrderDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Remove Products from Cart?'),
      content: Text('The products that you just ordered will be removed from cart.'),

      actions: [
      ],
    );
  }
}