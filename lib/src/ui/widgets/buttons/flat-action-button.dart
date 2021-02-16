import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlatActionButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final Function onPressed;
  final EdgeInsets padding;

  FlatActionButton({
    @required this.label,
    this.padding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
    this.icon, this.onPressed
  }): assert(label != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(height: 40),
        child: FlatButton(
          onPressed: onPressed,
          shape: StadiumBorder(),
          textColor: Colors.white,
          disabledTextColor: Colors.white,
          disabledColor: Color(0x7FFF974D),
          color: Theme.of(context).primaryColor,
          child: icon != null ? Row(children: [
            icon, const SizedBox(width: 8.0), Text(label)
          ], mainAxisAlignment: MainAxisAlignment.center) : Text(label),
        ),
      )
    );
  }
}
