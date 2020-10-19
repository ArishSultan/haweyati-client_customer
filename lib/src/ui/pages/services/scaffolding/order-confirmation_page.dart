import 'package:flutter/material.dart';
import 'package:haweyati/src/models/services/scaffolding/scaffolding-types.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/rich-price-text.dart';
import 'package:haweyati/src/ui/views/order-location_view.dart';
import 'package:haweyati/src/ui/widgets/buttons/edit-button.dart';
import 'package:haweyati/src/ui/views/order-confirmation_view.dart';
import 'package:haweyati/src/models/order/scaffoldings/order-item_model.dart';

class ScaffoldingOrderConfirmationPage extends StatelessWidget {
  final Order _order;

  ScaffoldingOrderItem get item =>
      _order.items.first.item as ScaffoldingOrderItem;

  ScaffoldingOrderConfirmationPage(this._order);

  @override
  Widget build(BuildContext context) {
    return OrderConfirmationView(
      order: _order,

      children: [
        HeaderView(
          title: 'Hello User,',
          subtitle: 'Please confirm your order details and your order reference number will be generated'
        ),

        _ScaffoldingOrderItemWidget(
          context: context,
          type: item.type.toString(),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: OrderLocationView(
            location: _order.location,
            onEdit: () => Navigator.of(context).pop()
          ),
        ),

        if (item.type == ScaffoldingType.single)
          SteelScaffoldingPricingDetails(_order.total),
        if (item.type == ScaffoldingType.patented)
          SteelScaffoldingPricingDetails(_order.total),
        if (item.type == ScaffoldingType.steel)
          SteelScaffoldingPricingDetails(_order.total),

        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Divider(height: 0, color: Colors.grey.shade700),
        ),

        Table(
          columnWidths: {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
          children: [
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
                fontFamily: 'Lato', height: 3
              )),
              RichPriceText(price: _order.total, fontSize: 17, fontWeight: FontWeight.bold),
            ])
          ]
        )
      ],

      preProcess: () => _order.total = _order.total
    );
  }
}

class _ScaffoldingOrderItemWidget extends DarkContainer {
  _ScaffoldingOrderItemWidget({
    BuildContext context,
    String type
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
          Image.asset('assets/images/steelscaffolding.png', height: 60),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(type, style: TextStyle(
                  color: Color(0xFF313F53),
                  fontSize: 15, fontWeight: FontWeight.bold
              )),
            ),
          )
        ]),
      ),
    ]),
  );
}

class SteelScaffoldingPricingDetails extends StatelessWidget {
  final double price;
  SteelScaffoldingPricingDetails(this.price);

  @override
  Widget build(BuildContext context) {
    return Table(children: [
      TableRow(children: [
        Text('Main Frame', style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
          fontFamily: 'Lato', height: 1.9
        )),
        RichPriceText(price: price)
      ]),

      TableRow(children: [
        Text('Cross Brace', style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
          fontFamily: 'Lato', height: 1.9
        )),
        RichPriceText(price: price)
      ]),

      TableRow(children: [
        Text('Connecting Bars', style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
          fontFamily: 'Lato', height: 1.9
        )),
        RichPriceText(price: price)
      ]),

      TableRow(children: [
        Text('Adjustable Bars', style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
          fontFamily: 'Lato', height: 1.9
        )),
        RichPriceText(price: price)
      ]),

      TableRow(children: [
        Text('Stabilizer', style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
          fontFamily: 'Lato', height: 1.9
        )),
        RichPriceText(price: price)
      ]),

      TableRow(children: [
        Text('Wood Planks', style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
          fontFamily: 'Lato', height: 1.9
        )),
        RichPriceText(price: price)
      ]),
    ]);
  }
}
