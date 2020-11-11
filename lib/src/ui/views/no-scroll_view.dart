import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';

class NoScrollView extends StatelessWidget {
  final Widget body;
  final Widget bottom;
  final bool extendBody;
  final PreferredSizeWidget appBar;

  NoScrollView({
    Key key,
    this.body,
    this.bottom,
    this.extendBody,
    this.appBar = const HaweyatiAppBar(),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: Builder(builder: (context) => body),
      appBar: appBar,
      backgroundColor: Colors.white,
      extendBody: extendBody ?? bottom is FlatActionButton,
      bottomNavigationBar: bottom
    );
  }
}
