import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';

class NoScrollView extends Scaffold {
  NoScrollView({
    Key key,
    Widget body,
    Widget bottom,
    bool extendBody,
    PreferredSizeWidget appBar = const HaweyatiAppBar()
  }): super(
    key: key,
    body: body,
    appBar: appBar,
    backgroundColor: Colors.white,
    extendBody: extendBody ?? bottom is FlatActionButton,
    bottomNavigationBar: bottom
  );
}
