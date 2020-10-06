import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/rich-price-text.dart';
import 'package:haweyati/src/ui/views/order-location_view.dart';
import 'package:haweyati/src/models/services/dumpster/model.dart';
import 'package:haweyati/src/ui/widgets/buttons/edit-button.dart';
import 'package:haweyati/src/ui/views/order-confirmation_view.dart';
import 'package:haweyati/src/models/order/dumpster/order-item_model.dart';

class DumpsterOrderConfirmationPage extends StatelessWidget {
  final Order _order;
  DumpsterOrderConfirmationPage(this._order);

  Dumpster get _dumpster => _item.product as Dumpster;
  DumpsterOrderItem get _item => _order.items.first.item as DumpsterOrderItem;

  double get _total => _dumpster.pricing.first.rent + _item.extraDaysPrice + _order.deliveryFee;

  @override
  Widget build(BuildContext context) {
    return OrderConfirmationView(
      order: _order,

      preProcess: () {
        _order.total = _total;
        _order.items.first.subtotal = _total - _order.deliveryFee;
      },

      children: [
        HeaderView(
          title: 'Hello User,',
          subtitle: 'Please confirm your order details and your order reference number will be generated'
        ),

        DumpsterOrderItemWidget(item: _item, context: context, dumpster: _dumpster),

        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: OrderLocationView(
            location: _order.location,
            onEdit: () => Navigator.of(context).pop()
          ),
        ),

        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
          children: [
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text('${_dumpster.size} Yards Container', style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF313F53),
                  fontWeight: FontWeight.bold
                )),
              ),
              Text('1 Piece', textAlign: TextAlign.right, style: TextStyle(
                fontSize: 12,
                fontFamily: 'Lato',
                color: Color(0xFF313F53),
              ))
            ]),
            TableRow(children: [
              Text('Price (10 Days)', style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontFamily: 'Lato', height: 1.9
              )),
              RichPriceText(price: _dumpster.pricing.first.rent),
            ]),
            if (_item.extraDays > 0)
              TableRow(children: [
                Text('Extra (${_item.extraDays} Days)', style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontFamily: 'Lato', height: 1.9
                )),
                RichPriceText(price: _item.extraDaysPrice),
              ]),
            TableRow(children: [
              Text('Delivery Fee', style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontFamily: 'Lato', height: 1.9
              )),
              RichPriceText(price: _order.deliveryFee)
            ]),
            TableRow(children: [
              Text('Total', style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'Lato', height: 3.4
              )),
              RichPriceText(price: _total, fontSize: 17, fontWeight: FontWeight.bold),
            ])
          ]
        )
      ],
    );
  }
}

class DumpsterOrderItemWidget extends DarkContainer {
  DumpsterOrderItemWidget({
    Dumpster dumpster,
    BuildContext context,
    DumpsterOrderItem item,
  }): super(
    padding: const EdgeInsets.fromLTRB(15, 17, 15, 15),
    child: Column(children: [
      Row(children: [
        Text('Service Details', style: TextStyle(
            color: Color(0xFF313F53),
            fontWeight: FontWeight.bold
        )),
        Spacer(),
        EditButton(onPressed: () {
          Navigator.of(context)
            ..pop()
            ..pop();
        }),
      ]),

      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(children: [
          Image.network(
              HaweyatiService.resolveImage(dumpster.image.name),
              height: 60
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('${dumpster.size} Yard Container', style: TextStyle(
                  color: Color(0xFF313F53),
                  fontSize: 15, fontWeight: FontWeight.bold
              )),
            ),
          )
        ]),
      ),

      Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1)
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
          children: [
            TableRow(children: [
              Text('Price', style: TextStyle(fontSize: 13, color: Colors.grey)),
              Text('Quantity', style: TextStyle(fontSize: 13, color: Colors.grey)),
              Text('Days', style: TextStyle(fontSize: 13, color: Colors.grey)),
            ]),

            TableRow(children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text('${dumpster.rent.round()} SAR/${dumpster.days} days',
                    style: TextStyle(fontSize: 13, color: Color(0xFF313F53))
                ),
              ),
              Text('1 Piece', style: TextStyle(fontSize: 13, color: Color(0xFF313F53))),
              Text((dumpster.days + item.extraDays).toString(), style: TextStyle(fontSize: 13, color: Color(0xFF313F53))),
            ])
          ],
        ),
      )
    ]),
  );
}
