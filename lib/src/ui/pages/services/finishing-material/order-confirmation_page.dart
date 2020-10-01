import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/location-picker.dart';
import 'package:haweyati/src/ui/widgets/rich-price-text.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:haweyati/src/ui/widgets/buttons/edit-button.dart';
import 'package:haweyati/src/ui/views/order-confirmation_view.dart';
import 'package:haweyati/src/models/services/finishing-material/model.dart';
import 'package:haweyati/src/models/order/finishing-material/order-item_model.dart';

class FinishingMaterialOrderConfirmationPage extends StatelessWidget {
  final Order _order;
  final bool _fromCart;

  FinishingMaterialOrderConfirmationPage(this._order, [this._fromCart = false]);

  double get _delivery => 50;
  double get _total => _order.total + _delivery;

  @override
  Widget build(BuildContext context) {
    return OrderConfirmationView(
      order: _order,

      preProcess: () async {
        _order.total = _total;

        if (_fromCart) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Clear Cart After Order'),
            )
          );
        }
      },

      children: [
        HeaderView(
          title: 'Hello User,',
          subtitle: 'Please confirm your order details and your order reference number will be generated'
        ),

        LocationPicker(
          initialValue: _order.location,
          onChanged: (location) => _order.location.update(location)
        ),

        for (final item in _order.items)
          _MaterialDetailView(
            holder: item,
            item: item.item,
            context: context,
            product: item.item.product,
          ),

        Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 30),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
            children: [
              TableRow(children: [
                Text('Sub Total', style: TextStyle(
                  height: 1.6,
                  fontSize: 13,
                  fontFamily: 'Lato',
                  color: Colors.grey,
                )),

                RichPriceText(price: _order.total)
              ]),
              TableRow(children: [
                Text('Delivery Fee', style: TextStyle(
                  height: 1.6,
                  fontSize: 13,
                  fontFamily: 'Lato',
                  color: Colors.grey,
                )),

                RichPriceText(price: _delivery)
              ]),
              TableRow(children: [
                Text('Total', style: TextStyle(
                  height: 2.5,
                  fontSize: 13,
                  fontFamily: 'Lato',
                  color: Colors.grey,
                )),

                RichPriceText(price: _total, fontWeight: FontWeight.bold)
              ])
            ]
          )
        )
      ]
    );
  }
}

class _MaterialDetailView extends DarkContainer {
  _MaterialDetailView({
    BuildContext context,
    OrderItemHolder holder,
    FinishingMaterial product,
    FinishingMaterialOrderItem item
  }): super(
    margin: const EdgeInsets.only(top: 20),
    padding: const EdgeInsets.all(15),
    child: Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: Color(0xEEFFFFFF),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 1,
                  color: Colors.grey.shade300
                )
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(HaweyatiService.resolveImage(product.images.name))
              )
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(product.name, style: TextStyle(
                fontSize: 16,
                color: Color(0xFF313F53),
                fontWeight: FontWeight.bold
              )),
            ),
          ),
          SizedBox(
            height: 80,
            child: EditButton(onPressed: () => Navigator.of(context).pop())
          )
        ]),
      ),

      Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
        children: [
          ..._buildVariants(item.variants),

          TableRow(children: [
            Text('Quantity', style: TextStyle(
              height: 1.6,
              fontSize: 13,
              color: Colors.grey,
            )),

            Text('${item.qty} ${item.qty == 1 ? 'Piece' : 'Pieces'}',
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

            RichPriceText(price: item.price)
          ]),
          TableRow(children: [
            Text('Total', style: TextStyle(
              height: 2.5,
              fontSize: 13,
              color: Colors.grey,
            )),

            RichPriceText(price: holder.subtotal, fontWeight: FontWeight.bold)
          ])
        ],
      )
    ])
  );

  static _buildVariants(Map<String, dynamic> variants) {
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
}
