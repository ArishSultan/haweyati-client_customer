import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:haweyati/l10n/app_localizations.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/orders_service.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/snack-bars/payment/not-selected_snack-bar.dart';
import 'package:haweyati/src/ui/views/order-confirmation_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/ui/widgets/details-table.dart';
import 'package:haweyati/src/ui/widgets/table-rows.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/rest/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/location-picker.dart';
import 'package:haweyati/src/ui/widgets/rich-price-text.dart';
import 'package:haweyati/src/ui/pages/orders/my-orders_page.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;
  OrderDetailPage(this.order);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return ScrollableView.sliver(
      showBackground: true,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 70),
      appBar: HaweyatiAppBar(actions: [
        IconButton(
          icon: Image.asset(CustomerCareIcon, width: 20),
          onPressed: () => Navigator.of(context).pushNamed(HELPLINE_PAGE),
        ),
        if (widget.order.status == OrderStatus.pending ||
            widget.order.status == OrderStatus.approved)
          IconButton(
            icon: Icon(Icons.dnd_forwardslash),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => WaitingDialog(message: 'Canceling Order')
              );

              await OrdersService().cancelOrder(widget.order.id);
              widget.order.status = OrderStatus.canceled;
              Navigator.of(context).pop();

              setState(() {});
            },
          ),
      ]),
      bottom: (widget.order.deliveryFee!=null && widget.order.paymentType == null) ?
      FlatActionButton(
        label: 'Proceed Payment',
        onPressed: () async {
          var order = widget.order;
          final result = await selectPayment(context, order.total);
          if (result == null) {
            //Todo: Snackbar
            // Scaffold.of(context)
            //     .showSnackBar(PaymentMethodNotSelectedSnackBar());
            return;
          } else {
            order.paymentType = result.method;
            order.paymentIntentId = result.intentId;
          }

          showDialog(context: context,builder: (context){
            return WaitingDialog(
              message: 'Processing order',
            );
          });

          await OrdersService().processPayment({
            '_id' : order.id,
            'paymentType' : order.paymentType,
            'paymentIntentId' : order.paymentIntentId,
          });

          Navigator.pop(context);
          Navigator.pop(context);

        },
      ) : widget.order.deliveryFee == null ? Text("Order is awaiting confirmation from supplier") :SizedBox(),
      children: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(5, 20, 5, 40),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: SizedBox(
                width: 320,
                child: _OrderDetailHeader(widget.order.status.index),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: OrderMeta(widget.order)),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 15, top: 25),
          sliver: SliverToBoxAdapter(
            child: LocationPicker(initialValue: widget.order.location),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _OrderProductWidget(widget.order.products[index]),
            childCount: widget.order.products.length,
          ),
        ),
        SliverToBoxAdapter(
          child: Table(
            textBaseline: TextBaseline.alphabetic,
            defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
            children: [
              TableRow(children: [
                Text(
                  'Sub Total',
                  style: TextStyle(
                    height: 2,
                    fontSize: 13,
                    fontFamily: 'Lato',
                    color: Colors.grey.shade600,
                  ),
                ),
                RichPriceText(
                  price: (widget.order.total - (widget.order.deliveryFee ?? 0)),
                  fontSize: 13,
                )
              ]),
              // TableRow(children: [
              //   Text('Delivery Fee', style: TextStyle(
              //     height: 2, fontSize: 13,
              //     fontFamily: 'Lato',
              //     color: Colors.grey.shade600,
              //   )),
              //
              //   // if (order.items.first.item is DumpsterOrderItem)
              //   //   RichPriceText(price: order.deliveryFee * (order.items.first.item as DumpsterOrderItem).qty, fontSize: 13)
              //   // else
              //   //   RichPriceText(price: order.deliveryFee, fontSize: 13)
              //
              // ])
            ],
          ),
        ),
        SliverToBoxAdapter(child: Divider()),
        SliverToBoxAdapter(
          child: Table(children: [
            TableRow(children: [
              Text(
                'Total',
                style: TextStyle(
                  height: 2,
                  fontSize: 13,
                  fontFamily: 'Lato',
                  color: Colors.grey.shade600,
                ),
              ),
              RichPriceText(
                price: widget.order.total,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )
            ])
          ],             textBaseline: TextBaseline.alphabetic,
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline),
        )
      ],
    );
  }
}

class _OrderProductWidget extends StatelessWidget {
  final OrderProductHolder holder;
  _OrderProductWidget(this.holder);

  Widget _buildFinishingMaterial(BuildContext context, FinishingMaterialOrderable item,) {
    return Table(children: [
      ..._buildVariants(item.variants),
      DetailRow('Quantity', AppLocalizations.of(context).nProducts(item.qty)),
      PriceRow('Price', item.price),
      PriceRow('Total', item.price),
      TableRow(children: [
        Text(
          'Total',
          style: TextStyle(
            height: 2.5,
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        RichPriceText(price: holder.subtotal, fontWeight: FontWeight.bold)
      ])
    ], textBaseline: TextBaseline.alphabetic, defaultVerticalAlignment: TableCellVerticalAlignment.baseline);
  }

  @override
  Widget build(BuildContext context) {
    final qty = _qty(holder);

    return DarkContainer(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        OrderProductTile(holder),
        if (holder.item is FinishingMaterialOrderable)
          _buildFinishingMaterial(context, holder.item)
        else
          DetailsTable([
            DetailRow('Quantity', AppLocalizations.of(context).nProducts(qty)),
            PriceRow('Price', holder.subtotal / qty),
            PriceRow('Total', holder.subtotal),
          ]),
      ]),
    );
  }

  static int _qty(OrderProductHolder holder) {
    if (holder.item is BuildingMaterialOrderable) {
      return (holder.item as BuildingMaterialOrderable).qty;
    } else if (holder.item is DumpsterOrderable) {
      return (holder.item as DumpsterOrderable).qty;
    }

    return 1;
  }
}

class OrderProductTile extends StatelessWidget {
  final OrderProductHolder item;
  OrderProductTile(this.item);

  @override
  Widget build(BuildContext context) {
    String title;
    String imageUrl;
    dynamic product = item.item.product;

    if (item.item is DumpsterOrderable) {
      title = '${product.size} Yards';
      imageUrl = product.image.name;
    } else if (item.item is BuildingMaterialOrderable) {
      title = product.name;
      imageUrl = product.image.name;
    } else if (item.item is FinishingMaterialOrderable) {
      title = product.name;
      imageUrl = product.image.name;
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
                  blurRadius: 5, spreadRadius: 1, color: Colors.grey.shade500)
            ],
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(HaweyatiService.resolveImage(imageUrl)))),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

_buildVariants(Map<String, dynamic> variants) {
  final list = [];

  variants?.forEach((key, value) {
    list.add(TableRow(children: [
      Text(key,
          style: TextStyle(
            height: 1.6,
            fontSize: 13,
            color: Colors.grey,
          )),
      Text(value,
          style: TextStyle(color: Color(0xFF313F53)),
          textAlign: TextAlign.right)
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
                left: 30,
                top: 10,
                child: Icon(Icons.done_all, size: 20, color: Colors.white)),
            Positioned(
                top: 9, left: 109, child: Image.asset(SettingsIcon, width: 22)),
            Positioned(
                top: 7, right: 106.5, child: Image.asset(CartIcon, width: 28)),
            Positioned(
                right: 30,
                top: 9,
                child: Image.asset(HomeIcon, width: 20, color: Colors.white)),
          ],
        ));
  }
}

class _OrderStatusPainter extends CustomPainter {
  final int progress;
  _OrderStatusPainter(this.progress);

  static TextPainter _genText(String text) {
    return TextPainter(
        text: TextSpan(
            text: text,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
        textDirection: TextDirection.ltr);
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

    canvas.drawLine(Offset(xOffset1, 20), Offset(xOffset2, 20),
        progress > 1 ? _donePainter : _unDonePainter);
    canvas.drawLine(Offset(xOffset2, 20), Offset(xOffset3, 20),
        progress > 2 ? _donePainter : _unDonePainter);
    canvas.drawLine(Offset(xOffset3, 20), Offset(xOffset4, 20),
        progress > 3 ? _donePainter : _unDonePainter);

    canvas.drawCircle(
        Offset(xOffset1, 20), 20, progress > 0 ? _donePainter : _unDonePainter);
    canvas.drawCircle(
        Offset(xOffset2, 20), 20, progress > 1 ? _donePainter : _unDonePainter);
    canvas.drawCircle(
        Offset(xOffset3, 20), 20, progress > 2 ? _donePainter : _unDonePainter);
    canvas.drawCircle(
        Offset(xOffset4, 20), 20, progress > 3 ? _donePainter : _unDonePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
