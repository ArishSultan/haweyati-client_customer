// @dart = 2.12

import 'package:flutter/material.dart';

class DirectionalArrow extends StatelessWidget {
  final Widget child;

  DirectionalArrow(this.child);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: Directionality.of(context) == TextDirection.rtl ? 3.14159 : 0,
      child: child,
    );
  }
}
