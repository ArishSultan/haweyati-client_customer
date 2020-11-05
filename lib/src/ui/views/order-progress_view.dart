import 'package:flutter/material.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';

typedef OrderProgressBuilder = List<Widget> Function(BuildContext context);
class OrderProgressView<T extends OrderItem> extends ScrollableView {
  OrderProgressView({
    Key key,
    bool allow = true,
    $Order<T> order,
    double progress = .25,
    List<Widget> Function($Order order) builder,
    List<Widget> children,
    Function() onContinue,
    Function($Order<T> order) $onContinue,
  }): super(
    key: key,
    padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
    children: builder(order),
    extendBody: true,
    showBackground: true,
    crossAxisAlignment: CrossAxisAlignment.start,
    appBar: HaweyatiAppBar(progress: progress, confirmOrderCancel: true),
    bottom: RaisedActionButton(
      label: 'Continue',
      onPressed: allow ? () => $onContinue(order) : null
    ),
  ) {
    print('Allow: ' + allow.toString());
  }

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