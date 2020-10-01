import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';

class ClearCartAfterOrderDialog extends StatelessWidget {
  final _appData = AppData.instance();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Remove Products from Cart?'),
      content: Text('The products that you just ordered will be removed from cart.'),

      actions: [
        FlatActionButton()
      ],
    );
  }
}