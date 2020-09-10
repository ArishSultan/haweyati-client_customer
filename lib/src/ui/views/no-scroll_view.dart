import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/flat-action-button.dart';

class NoScrollView extends Scaffold {
  NoScrollView({
    Widget body,
    Widget bottom,
    PreferredSizeWidget appBar = const HaweyatiAppBar()
  }): super(
    body: body,
    appBar: appBar,
    backgroundColor: Colors.white,
    extendBody: bottom is FlatActionButton,
    bottomNavigationBar: bottom
  );
}
