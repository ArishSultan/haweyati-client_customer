import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CartOrderDismissConfirmationDialog extends StatefulWidget {
  @override
  _CartOrderDismissConfirmationDialogState createState() => _CartOrderDismissConfirmationDialogState();
}

class _CartOrderDismissConfirmationDialogState extends State<CartOrderDismissConfirmationDialog> {
  var _cartToo = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20
      ),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18, color: Color(0xFF313F53)
      ),
      titlePadding: const EdgeInsets.only(
        top: 20, left: 15, right: 15
      ),
      contentPadding: const EdgeInsets.only(
        top: 10, left: 15, right: 15, bottom: 0
      ),
      actionsPadding: const EdgeInsets.only(
        top: 0, left: 15, right: 15
      ),
      title: Text('Are you sure?'),
      content: Wrap(children: [
        Text('This item wil be removed from cart'),

        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(children: [
            Checkbox(
              value: _cartToo,
              visualDensity: VisualDensity.compact,
              onChanged: (val) => setState(() => _cartToo = val),
            ),
            Text('Remove From Cart too?'),
          ]),
        )
      ]),
      actions: [
        FlatButton(
          child: Text('YES'),
          shape: StadiumBorder(),
          textColor: Theme.of(context).primaryColor,
          onPressed: () => Navigator.of(context).pop(
            _cartToo ? CartOrderDismissResult.cartToo : CartOrderDismissResult.simple
          )
        ),
        FlatButton(
          child: Text('NO'),
          shape: StadiumBorder(),
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.of(context).pop()
        )
      ],
    );
  }
}

enum CartOrderDismissResult {
  simple,
  cartToo
}
