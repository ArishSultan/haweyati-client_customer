import 'package:haweyati/src/rest/haweyati-service.dart';
import 'package:haweyati/src/rest/orders_service.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/l10n/app_localizations.dart';
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/rich-price-text.dart';
import 'package:haweyati/src/ui/views/live-scrollable_view.dart';
import 'package:haweyati/src/ui/pages/orders/order-detail_page.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  var _orderId = '';
  final _service = OrdersService();
  final _key = GlobalKey<LiveScrollableViewState>();

  @override
  Widget build(BuildContext context) {
    var view;
    view = LiveScrollableView(
      key: _key,
      header: Padding(
        padding: const EdgeInsets.all(15),
        child: CupertinoTextField(
          prefix: Padding(
            padding: const EdgeInsets.fromLTRB(15, 7, 5, 7),
            child: Icon(
              CupertinoIcons.search,
              size: 21,
              color: Colors.grey.shade400,
            ),
          ),
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
          placeholderStyle: TextStyle(
            fontSize: 15,
            fontFamily: 'Lato',
            color: Colors.grey.shade400,
          ),
          placeholder: 'Item Name or order number',
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade200,
          ),
          onChanged: (val) async {
            _orderId = val;
            await view.reload();
          },
        ),
      ),
      loader: () => _service.orders(
        id: AppData().user.id,
        orderId: _orderId,
      ),
      builder: (context, order) => GestureDetector(
        onTap: () async {
          await navigateTo(context, OrderDetailPage(order));
          setState(() {});
        },
        child: _OrderListTile(order),
      ),
    );

    return NoScrollView(body: view);
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
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: OrderMeta(order),
        ),
        for (final item in order.products) OrderItemTile(item),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(children: [
            Text(
              'Total',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            Spacer(),
            RichPriceText(
              price: order.total,
              fontWeight: FontWeight.bold,
            ),
          ]),
        )
      ]),
    );
  }
}

class _OrderStatus extends Container {
  _OrderStatus(final OrderStatus status)
      : super(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _color(status),
          ),
          child: Text(
            status.value,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        );

  static Color _color(OrderStatus status) {
    return Colors.red;
    // switch (status) {
    //   case OrderStatus.dispatched:
    //   case OrderStatus.active:
    //     return Colors.green;
    //   case OrderStatus.pending:
    //     return Color(0xFFFF974D);
    //   case OrderStatus.closed:
    //     return Color(0xFF313F53);
    //   case OrderStatus.rejected:
    //     return Colors.red;
    // }
    //
    // return null;
  }
}

class OrderMeta extends Row {
  OrderMeta(Order order)
      : super(
          children: [
            Column(children: [
              RichText(
                text: TextSpan(
                  text: 'Order Date - ',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  children: [
                    TextSpan(
                      text: DateFormat('d MMM y,')
                          .add_jm()
                          .format(order.createdAt),
                      style: TextStyle(fontSize: 13, color: Color(0xFF313F53)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  text: 'Order ID - ',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  children: [
                    TextSpan(
                      text: order.number.toUpperCase(),
                      style: TextStyle(fontSize: 13, color: Color(0xFF313F53)),
                    )
                  ],
                ),
              )
            ], crossAxisAlignment: CrossAxisAlignment.start),
            Spacer(),
            _OrderStatus(order.status)
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        );
}

class OrderItemTile extends StatelessWidget {
  final OrderProductHolder holder;
  OrderItemTile(this.holder);

  @override
  Widget build(BuildContext context) {
    int qty = 1;
    String title;
    String imageUrl;

    if (holder.item is DumpsterOrderable) {
      final item = holder.item as DumpsterOrderable;

      qty = item.qty;
      title = '${item.product?.size} Yards';
      imageUrl = item.product.image.name;
    } else if (holder.item is BuildingMaterialOrderable) {
      final item = holder.item as BuildingMaterialOrderable;

      qty = item.qty;
      title = item.product?.name;
      imageUrl = item.product?.image?.name;
    } else if (holder.item is FinishingMaterialOrderable) {
      final item = holder.item as FinishingMaterialOrderable;

      qty = item.qty;
      title = item.product.name;
      imageUrl = item.product.image.name;
    }

    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: Container(
        width: 60,
        decoration: BoxDecoration(
          color: Color(0xEEFFFFFF),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 1,
              color: Colors.grey.shade500,
            )
          ],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(HaweyatiService.resolveImage(imageUrl)),
          ),
        ),
      ),
      title: Text(
        title.toString(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(AppLocalizations.of(context).nProducts(qty)),
    );
  }
}
