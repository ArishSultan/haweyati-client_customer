import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/flat-action-button.dart';

class ScrollableView extends Scaffold {
  ScrollableView({
    Key key,
    Widget child,
    Widget bottom,
    List<Widget> children,
    bool showBackground = false,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    PreferredSizeWidget appBar = const HaweyatiAppBar(),
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 15)
  }): super(
    key: key,
    appBar: appBar,
    extendBody: true,
    backgroundColor: Colors.white,
    body: showBackground ? DottedBackgroundView(
      child: SingleChildScrollView(
        padding: padding,
        child: child ?? Column(
          children: children,
          crossAxisAlignment: crossAxisAlignment,
        )
      )
    ): SingleChildScrollView(
      padding: padding,
      child: child ?? Column(children: children)
    ),
    bottomNavigationBar: bottom
  );

  ScrollableView.sliver({
    Widget bottom,
    List<Widget> children,
    PreferredSizeWidget appBar = const HaweyatiAppBar()
  }): super(
    appBar: appBar,
    body: CustomScrollView(slivers: children),
    extendBody: bottom is FlatActionButton,
    bottomNavigationBar: bottom
  );
}
