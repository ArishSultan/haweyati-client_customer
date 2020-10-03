import 'package:flutter/material.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/services/orders_service.dart';
import 'package:haweyati/src/ui/views/live-scrollable_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final _service = OrdersService();

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      body: LiveScrollableView(
        loader: () => _service.orders(),
        builder: (context, order) => _OrderListTile(order),
      ),
    );
  }
}


class _OrderListTile extends StatelessWidget {
  final Order order;
  _OrderListTile(this.order);

  @override
  Widget build(BuildContext context) {
    return DarkContainer(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(15),
      child: Wrap(children: [
        Row(children: [
          Text('Order'),
          _OrderStatus(OrderStatus.active)
        ])
      ]),
    );
  }
}

enum OrderStatus {
  active,
  pending,
  competed,
  canceled
}


class _OrderStatus extends Container {
  _OrderStatus(final OrderStatus status): super(
    padding: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 5
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Color(0xFFFF974D)
    ),
    child: Text('Pending', style: TextStyle(
      color: Colors.white,
      fontSize: 10
    ))
  );

  static Color _color(OrderStatus status) {
    switch (status) {
      case OrderStatus.active:
        return Colors.green;
      case OrderStatus.pending:
        return Color(0xFFFF974D);
      case OrderStatus.competed:
        return Color(0xFF313F53);
      case OrderStatus.canceled:
        return Colors.red;
    }
  }
}
