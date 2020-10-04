import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;
  OrderDetailPage(this.order);

  @override
  Widget build(BuildContext context) {
    return ScrollableView.sliver(children: [
      SliverToBoxAdapter(child: _OrderDetailHeader(order.status))
    ]);
  }
}

class _OrderDetailHeader extends Row {
  _OrderDetailHeader(OrderStatus status): super(
    children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle
        ),
        child: Icon(Icons.done_all),
      )
    ]
  );
}
