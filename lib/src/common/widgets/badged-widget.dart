import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BadgedWidget extends StatelessWidget {
  final double size;
  final Widget child;
  final Widget badge;

  BadgedWidget({
    this.size,
    @required this.child,
    @required this.badge
  });

  BadgedWidget.numbered({
    int number = 9,
    double size,
    Widget child,
  }): this(
    size: size,
    child: child,
    badge: Positioned(
      top: -3,
      right: 5,
      child: Container(
        width: 20,
        height: 20,
        child: Center(
          child: number > 9 ? Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle
            ),
          ) : Text(number.toString(), style: TextStyle(
            color: Colors.white
          ))
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white
          ),
          boxShadow: [BoxShadow(
            blurRadius: 1,
            spreadRadius: 1,
            color: Color.fromRGBO(0, 0, 0, 0.3)
          )],
          color: Color(0xFFFF974D),
          shape: BoxShape.circle
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      badge
    ], clipBehavior: Clip.none);
  }
}
