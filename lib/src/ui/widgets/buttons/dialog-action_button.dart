import 'package:flutter/material.dart';

class DialogActionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final Function onPressed;

  DialogActionButton({
    this.label,
    this.isPrimary = false,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      textColor: isPrimary
        ? Colors.white
        : Theme.of(context).primaryColor,

      color: isPrimary
        ? Theme.of(context).primaryColor
        : Colors.transparent,

      child: Text(label.toUpperCase()),
      shape: StadiumBorder()
    );
  }
}
