import 'package:flutter/foundation.dart';
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
      _StatusCircle('Order Placed', Icons.done_all),
      _StatusLine(),
      _StatusCircle('Processing', Icons.done_all),
      _StatusLine(),
      _StatusCircle('Dispatched', Icons.done_all),
      _StatusLine(),
      _StatusCircle('Delivered', Icons.done_all),
    ],
    mainAxisAlignment: MainAxisAlignment.center
  );
}


class _StatusCircle extends Container {
  _StatusCircle(String title, IconData icon, [bool status = false]): super(
    width: 40, height: 40,
    clipBehavior: Clip.none,
    decoration: BoxDecoration(
      color: status
        ? Colors.red
        : Colors.grey.shade300,
      shape: BoxShape.circle
    ),
    child: Stack(children: [
      Align(
        alignment: Alignment.center,
        child: Icon(icon,
          size: 19,
          color: status
            ? Colors.white
            : Colors.grey.shade500
        )
      ),

      Positioned(
        left: -75,
        bottom: 0,
        // alignment: Alignment(0, 3),
        child: SizedBox(
          width: 150,
          // color: Colors.red,
          // clipBehavior: Clip.none,
          child: Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10),
          ),
        )
      )
    ])
  );
}

class _StatusLine extends Container {
  _StatusLine([bool status = false]): super(
    width: 50, height: 1,
    color: status ? Colors.red : Colors.grey.shade300
  );
}
