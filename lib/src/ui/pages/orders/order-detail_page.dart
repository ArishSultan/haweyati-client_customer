import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:haweyati/l10n/app_localizations.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/models/order/building-material/order-item_model.dart';
import 'package:haweyati/src/models/order/dumpster/order-item_model.dart';
import 'package:haweyati/src/models/order/finishing-material/order-item_model.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/pages/orders/my-orders_page.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/location-picker.dart';
import 'package:haweyati/src/ui/widgets/rich-price-text.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;
  OrderDetailPage(this.order);

  @override
  Widget build(BuildContext context) {
    return ScrollableView.sliver(
      showBackground: true,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
      appBar: HaweyatiAppBar(actions: [
        IconButton(
          icon: Image.asset(CustomerCareIcon, width: 20),
          onPressed: () => Navigator.of(context).pushNamed(HELPLINE_PAGE)
        )
      ]),
      children: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(5, 20, 5, 40),
          sliver: SliverToBoxAdapter(child: _OrderDetailHeader(order.status.index)),
        ),

        SliverToBoxAdapter(child: OrderMeta(order)),

        SliverPadding(
          padding: const EdgeInsets.only(bottom: 15, top: 25),
          sliver: SliverToBoxAdapter(child: LocationPicker(initialValue: order.location)),
        ),

        SliverList(delegate: SliverChildBuilderDelegate(
          (context, index) => _OrderItemWidget(order.items[index]),
          childCount: order.items.length
        )),

        SliverToBoxAdapter(
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
            children: [
              TableRow(children: [
                Text('Sub Total', style: TextStyle(
                  height: 2, fontSize: 13,
                  fontFamily: 'Lato',
                  color: Colors.grey.shade600,
                )),

                RichPriceText(price: order.total - order.deliveryFee, fontSize: 13)
              ]),
              TableRow(children: [
                Text('Delivery Fee', style: TextStyle(
                  height: 2, fontSize: 13,
                  fontFamily: 'Lato',
                  color: Colors.grey.shade600,
                )),

                RichPriceText(price: order.deliveryFee, fontSize: 13)
              ])
            ],
          ),
        ),
        SliverToBoxAdapter(child: Divider()),
        SliverToBoxAdapter(
          child: Table(children: [
            TableRow(children: [
              Text('Total', style: TextStyle(
                height: 2,
                fontSize: 13,
                fontFamily: 'Lato',
                color: Colors.grey.shade600,
              )),

              RichPriceText(price: order.total, fontWeight: FontWeight.bold, fontSize: 18)
            ])
          ], defaultVerticalAlignment: TableCellVerticalAlignment.baseline),
        )
      ]
    );
  }
}

class _OrderItemWidget extends StatelessWidget {
  final OrderItemHolder holder;
  _OrderItemWidget(this.holder);

  @override
  Widget build(BuildContext context) {
    final qty = _qty(holder);

    return DarkContainer(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        OrderItemTile(holder),

        if (holder.item is FinishingMaterialOrderItem)
          Table(children: [
            ..._buildVariants((holder.item as FinishingMaterialOrderItem).variants),

            TableRow(children: [
              Text('Quantity', style: TextStyle(
                height: 1.6,
                fontSize: 13,
                color: Colors.grey,
              )),

              Text('${(holder.item as FinishingMaterialOrderItem).qty} ${(holder.item as FinishingMaterialOrderItem).qty == 1 ? 'Piece' : 'Pieces'}',
                textAlign: TextAlign.right,
                style: TextStyle(color: Color(0xFF313F53)),
              )
            ]),
            TableRow(children: [
              Text('Price', style: TextStyle(
                height: 1.6,
                fontSize: 13,
                color: Colors.grey,
              )),

              RichPriceText(price: (holder.item as FinishingMaterialOrderItem).price)
            ]),
            TableRow(children: [
              Text('Total', style: TextStyle(
                height: 2.5,
                fontSize: 13,
                color: Colors.grey,
              )),

              RichPriceText(price: holder.subtotal, fontWeight: FontWeight.bold)
            ])
          ], defaultVerticalAlignment: TableCellVerticalAlignment.baseline)
        else
          Table(children: [
            TableRow(children: [
              Text('Quantity', style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 2)),
              Text(AppLocalizations.of(context).nProducts(qty), textAlign: TextAlign.right, style: TextStyle(
                fontSize: 13
              ))
            ]),
            TableRow(children: [
              Text('Price', style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 2)),
              RichPriceText(price: holder.subtotal / qty, fontSize: 13)
            ]),

            TableRow(children: [
              Text('Total', style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 3)),
              RichPriceText(price: holder.subtotal, fontWeight: FontWeight.bold)
            ]),
          ], defaultVerticalAlignment: TableCellVerticalAlignment.baseline)
      ]),

    );
  }

  static int _qty(OrderItemHolder holder) {
    if (holder.item is BuildingMaterialOrderItem) {
      return (holder.item as BuildingMaterialOrderItem).qty;
    }

    return 1;
  }
}

class OrderItemTile extends StatelessWidget {
  final OrderItemHolder item;
  OrderItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    String title;
    String imageUrl;
    dynamic product = item.item.product;

    if (item.item is DumpsterOrderItem) {
      title = '${product.size} Yards';
      imageUrl = product.image.name;
    } else if (item.item is BuildingMaterialOrderItem) {
      title = product.name;
      imageUrl = product.image.name;
    } else if (item.item is FinishingMaterialOrderItem) {
      title = product.name;
      imageUrl = product.images.name;
    }


    return ListTile(
      contentPadding: const EdgeInsets.only(bottom: 15),
      leading: Container(
        width: 60,
        decoration: BoxDecoration(
          color: Color(0xEEFFFFFF),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 1,
              color: Colors.grey.shade500
            )
          ],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(HaweyatiService.resolveImage(imageUrl))
          )
        ),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
_buildVariants(Map<String, dynamic> variants) {
  final list = [];

  variants.forEach((key, value) {
    list.add(TableRow(children: [
      Text(key, style: TextStyle(
        height: 1.6,
        fontSize: 13,
        color: Colors.grey,
      )),

      Text(value, style: TextStyle(color: Color(0xFF313F53)), textAlign: TextAlign.right)
    ]));
  });

  return list;
}
class _OrderDetailHeader extends StatelessWidget {
  final int status;
  _OrderDetailHeader(this.status);

  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 65,
      child: Stack(
        children: [
          CustomPaint(painter: _OrderStatusPainter(status)),
          Positioned(
            left: 30, top: 10,
            child: Icon(Icons.done_all, size: 20, color: Colors.white)
          ),
          Positioned(
            top: 9,
            left: 109,
            child: Image.asset(SettingsIcon, width: 22)
          ),
          // Positioned(left: 30, child: Image.asset(CartIcon, width: 30)),
          Positioned(
            right: 30, top: 9,
            child: Image.asset(HomeIcon, width: 20)
          ),
        ],
      )
    );
  }
}
class _OrderStatusPainter extends CustomPainter {
  final int progress;
  _OrderStatusPainter(this.progress);

  static TextPainter _genText(String text) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey.shade700
        )
      ),
      textDirection: TextDirection.ltr
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final xOffset1 = 40.0;
    final xOffset2 = 120.0;
    final xOffset3 = 200.0;
    final xOffset4 = 280.0;

    final txt1 = _genText('Order Placed')..layout();
    final txt2 = _genText('Preparing')..layout();
    final txt3 = _genText('Dispatched')..layout();
    final txt4 = _genText('Delivered')..layout();

    final _donePainter = Paint()
      ..color = Color(0xFFFF974D)
      ..strokeWidth = 1;

    final _unDonePainter = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    txt1.paint(canvas, Offset(xOffset1 - txt1.width / 2, 50));
    txt2.paint(canvas, Offset(xOffset2 - txt2.width / 2, 50));
    txt3.paint(canvas, Offset(xOffset3 - txt3.width / 2, 50));
    txt4.paint(canvas, Offset(xOffset4 - txt4.width / 2, 50));

    canvas.drawLine(Offset(xOffset1, 20), Offset(xOffset2, 20), progress > 1 ? _donePainter : _unDonePainter);
    canvas.drawLine(Offset(xOffset2, 20), Offset(xOffset3, 20), progress > 2 ? _donePainter : _unDonePainter);
    canvas.drawLine(Offset(xOffset3, 20), Offset(xOffset4, 20), progress > 3 ? _donePainter : _unDonePainter);

    canvas.drawCircle(Offset(xOffset1, 20), 20, progress > 0 ? _donePainter : _unDonePainter);
    canvas.drawCircle(Offset(xOffset2, 20), 20, progress > 1 ? _donePainter : _unDonePainter);
    canvas.drawCircle(Offset(xOffset3, 20), 20, progress > 2 ? _donePainter : _unDonePainter);
    canvas.drawCircle(Offset(xOffset4, 20), 20, progress > 3 ? _donePainter : _unDonePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}