import 'package:flutter/material.dart';
import 'package:haweyati/src/models/order/building-material/order-item_model.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/models/services/building-material/model.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/pages/payment/payment-methods_page.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/order-location_view.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/edit-button.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/rich-price-text.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class BuildingMaterialOrderConfirmationPage extends StatelessWidget {
  final Order _order;
  BuildingMaterialOrderConfirmationPage(this._order);

  double get _delivery => 50;
  BuildingMaterial get _container => _item.product as BuildingMaterial;
  BuildingMaterialOrderItem get _item => _order.items.first.item as BuildingMaterialOrderItem;

  double get _total => (_item.qty * _item.price) + _delivery;

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

        DarkContainer(
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
                  HaweyatiService.resolveImage(_container.image.name),
                  height: 60
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(_container.name, style: TextStyle(
                    color: Color(0xFF313F53),
                    fontSize: 15, fontWeight: FontWeight.bold
                  )),
                )
              ]),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
                children: [
                  TableRow(children: [
                    Text('Price', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    Text('Container', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ]),

                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('${_item.price.round()} SAR',
                        style: TextStyle(fontSize: 13, color: Color(0xFF313F53))
                      ),
                    ),
                    Text('${_item.qty} ${_item.qty == 1 ? 'Piece' : 'Pieces'}', style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF313F53)
                    )),
                  ])
                ],
              ),
            )
          ]),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: OrderLocationView(
            location: _order.location,
            onEdit: () => Navigator.of(context).pop()
          ),
        ),

        Table(
          columnWidths: {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
          children: [
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text('${_container.name} (${_item.size})', style: TextStyle(
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
              Text('Price (${_item.qty} ${_item.qty == 1 ? 'Piece' : 'Pieces'})', style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontFamily: 'Lato', height: 1.9
              )),
              RichPriceText(price: _container.pricing.first.price12yard),
            ]),
            TableRow(children: [
              Text('Delivery Fee', style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontFamily: 'Lato', height: 1.9
              )),
              RichPriceText(price: _delivery)
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
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
      extendBody: true,
      bottom: RaisedActionButton(
        label: 'Proceed',
        onPressed: () => navigateTo(context, PaymentMethodsPage()),
      ),
    );
  }
}
