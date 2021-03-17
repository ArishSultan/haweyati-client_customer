// @dart = 2.12

import 'package:flutter/widgets.dart';

abstract class ControlledWidget<T extends Listenable> extends StatefulWidget {
  final T controller;
  ControlledWidget({required this.controller});

  @override
  ControlledWidgetState createState();
}

abstract class ControlledWidgetState<T extends ControlledWidget> extends State<T> {
  @override
  @mustCallSuper
  void initState() {
    widget.controller.addListener(_rebuild);
    super.initState();
  }

  @override
  @mustCallSuper
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});
}