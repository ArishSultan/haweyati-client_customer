import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';

class OrderProgressView extends ScrollableView {
  OrderProgressView({
    Key key,
    List<Widget> children,
    Function onContinue,
  }): super(
    key: key,
    children: children,
    showBackground: true,
    crossAxisAlignment: CrossAxisAlignment.start,
    appBar: HaweyatiAppBar(progress: .25, confirmOrderCancel: true),
    bottom: FlatActionButton(
      label: 'Continue',
      onPressed: onContinue
    ),
  );

  OrderProgressView.sliver({
    Key key,
    List<Widget> children,
    Function onContinue,
  }): super.sliver(
    showBackground: true,
    children: children,
    appBar: HaweyatiAppBar(progress: .25, confirmOrderCancel: true),
    bottom: RaisedActionButton(
      label: 'Continue',
      onPressed: onContinue
    ),
  );
}