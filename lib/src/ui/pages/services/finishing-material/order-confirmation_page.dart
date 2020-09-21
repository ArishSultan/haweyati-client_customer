import 'package:flutter/material.dart';
import 'package:haweyati/src/models/location_model.dart';
import 'package:haweyati/src/models/order/finishing-material/order-item_model.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/models/services/finishing-material/model.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/pages/payment/payment-methods_page.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/edit-button.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/location-picker-widget.dart';
import 'package:haweyati/src/ui/widgets/rich-price-text.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class FinishingMaterialOrderConfirmationPage extends StatelessWidget {
  final Order _order;
  FinishingMaterialOrderConfirmationPage(this._order);

  double get _delivery => 50;
  double get _total => _holder.subtotal + _delivery;
  OrderItemHolder get _holder => _order.items.first;
  FinishingMaterial get _product => _holder.item.product as FinishingMaterial;
  FinishingMaterialOrderItem get _item => _holder.item as FinishingMaterialOrderItem;

  @override
  Widget build(BuildContext context) {
    return ScrollableView(
      appBar: HaweyatiAppBar(progress: .75),
      showBackground: true,
      children: [
        HeaderView(
          title: 'Hello User,',
          subtitle: 'Please confirm your order details and your order reference number will be generated'
        ),

        LocationPickerWidget(
          initialValue: _order.location,
          onChanged: (Location location) => _order.location = location
        ),

        DarkContainer(
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
                      image: NetworkImage(HaweyatiService.resolveImage(_product.images.name))
                    )
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                  child: Text(_product.name, style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF313F53),
                    fontWeight: FontWeight.bold
                  )),
                ),
                Spacer(),
                EditButton(onPressed: () => Navigator.of(context).pop())
              ], crossAxisAlignment: CrossAxisAlignment.start),
            ),

            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
              children: [
                ..._buildVariants(_item.variants),

                TableRow(children: [
                  Text('Quantity', style: TextStyle(
                    height: 1.6,
                    fontSize: 13,
                    color: Colors.grey,
                  )),

                  Text('${_item.qty} ${_item.qty == 1 ? 'Piece' : 'Pieces'}',
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

                  RichPriceText(price: _item.price)
                ]),
                TableRow(children: [
                  Text('Total', style: TextStyle(
                    height: 2.5,
                    fontSize: 13,
                    color: Colors.grey,
                  )),

                  RichPriceText(price: _holder.subtotal, fontWeight: FontWeight.bold)
                ])
              ],
            )
          ])
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

                RichPriceText(price: _holder.subtotal)
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
      ],
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
      extendBody: true,
      bottom: RaisedActionButton(
        label: 'Proceed',
        onPressed: () => navigateTo(context, PaymentMethodsPage()),
      ),
    );
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
}
