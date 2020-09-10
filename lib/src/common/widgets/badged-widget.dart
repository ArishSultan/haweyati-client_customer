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
    double size,
    Widget child,
    Widget badge
  }): this(
    size: size,
    child: child,
    badge: badge
  );

  @override
  Widget build(BuildContext context) {

  }
}
