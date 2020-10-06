import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/rich-price-text.dart';
import 'package:haweyati/src/ui/views/order-location_view.dart';
import 'package:haweyati/src/ui/widgets/buttons/edit-button.dart';
import 'package:haweyati/src/ui/views/order-confirmation_view.dart';
import 'package:haweyati/src/models/services/building-material/model.dart';
import 'package:haweyati/src/models/order/building-material/order-item_model.dart';

class BuildingMaterialOrderConfirmationPage extends StatelessWidget {
  final Order _order;
  BuildingMaterialOrderConfirmationPage(this._order);

  double get _total => _order.items.fold(0, (previousValue, element) {
    final item = element.item as BuildingMaterialOrderItem;
    return previousValue + item.qty * item.price;
  }) + _order.deliveryFee;

  @override
  Widget build(BuildContext context) {
    return OrderConfirmationView(
      order: _order,

      children: [
        HeaderView(
          title: 'Hello User,',
          subtitle: 'Please confirm your order details and your order reference number will be generated'
        ),

        for (final item in _order.items)
          _ProductDetails(
            item: item.item,
            context: context,
            material: item.item.product,
          ),

        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: OrderLocationView(
            location: _order.location,
            onEdit: () => Navigator.of(context).pop()
          ),
        ),

        for (final item in _order.items)
          _ProductPriceDetail(
            item: item.item,
            material: item.item.product,
          ),

        Divider(height: 0, color: Colors.grey.shade700),

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
              RichPriceText(price: _total, fontSize: 17, fontWeight: FontWeight.bold),
            ])
          ]
        )
      ],

      preProcess: () => _order.total = _total
    );
  }
}

class _ProductPriceDetail extends Padding {
  _ProductPriceDetail({
    BuildingMaterial material,
    BuildingMaterialOrderItem item
  }): super(
    padding: const EdgeInsets.only(bottom: 20),
    child: Table(
      columnWidths: {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
      children: [
        TableRow(children: [
          Text('${material.name} (${item.size})', style: TextStyle(
            fontSize: 16,
            color: Color(0xFF313F53),
            fontWeight: FontWeight.bold
          )),
          Text('${item.qty} ${item.qty == 1 ? 'Piece' : 'Pieces'}', textAlign: TextAlign.right, style: TextStyle(
            fontSize: 12,
            fontFamily: 'Lato',
            color: Color(0xFF313F53),
          ))
        ]),
        TableRow(children: [
          Text('Price (${item.qty} ${item.qty == 1 ? 'Piece' : 'Pieces'})', style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontFamily: 'Lato', height: 1.9
          )),
          RichPriceText(price: item.qty * item.price),
        ])
      ]
    ),
  );
}
class _ProductDetails extends DarkContainer {
  _ProductDetails({
    BuildContext context,
    BuildingMaterial material,
    BuildingMaterialOrderItem item
  }): super(
    margin: const EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
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
            HaweyatiService.resolveImage(material.image.name),
            height: 60
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('${material.name} (${item.size} yards)', style: TextStyle(
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
                child: Text('${item.price.round()} SAR',
                  style: TextStyle(fontSize: 13, color: Color(0xFF313F53))
                ),
              ),
              Text('${item.qty} ${item.qty == 1 ? 'Piece' : 'Pieces'}', style: TextStyle(
                fontSize: 13,
                color: Color(0xFF313F53)
              )),
            ])
          ],
        ),
      )
    ]),
  );
}
