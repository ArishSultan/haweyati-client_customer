import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/ui/widgets/counter.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/views/order-progress_view.dart';
import 'package:haweyati/src/models/services/building-material/model.dart';
import 'package:haweyati/src/models/order/building-material/order-item_model.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

import 'time-location_page.dart';

class BuildingMaterialServiceDetailPage extends StatefulWidget {
  final BuildingMaterial item;
  BuildingMaterialServiceDetailPage(this.item);

  @override
  _BuildingMaterialServiceDetailPageState createState() =>
      _BuildingMaterialServiceDetailPageState();
}

class _BuildingMaterialServiceDetailPageState
    extends State<BuildingMaterialServiceDetailPage> {
  final _item1 = BuildingMaterialOrderItem(BuildingMaterialSize.yards12);
  final _item2 = BuildingMaterialOrderItem(BuildingMaterialSize.yards20);
  final _order =
      $Order<BuildingMaterialOrderItem>.create(OrderType.buildingMaterial);

  @override
  void initState() {
    super.initState();

    _item1.product = _item2.product = widget.item;

    _item1.price = widget.item.price12;
    _item2.price = widget.item.price20;
  }

  @override
  Widget build(BuildContext context) {
    return OrderProgressView(
      order: _order,
      builder: (order) {
        return <Widget>[
          HeaderView(
            title: 'Product Details',
            subtitle: loremIpsum.substring(0, 70),
          ),
          _ContainerDescription(text: 'Small Container', size: '12 Yards'),
          _ContainerSelection(
            price: _item1.price,
            qty: _item1.qty.toDouble(),
            onChanged: (count) => setState(() => _item1.qty = count.toInt()),
          ),
          _ContainerDescription(text: 'Big Container', size: '20 Yards'),
          _ContainerSelection(
            price: _item2.price,
            qty: _item2.qty.toDouble(),
            onChanged: (count) => setState(() => _item2.qty = count.toInt()),
          ),
        ];
      },
      $onContinue: _item1.qty > 0 || _item2.qty > 0 ? _submit : null,
    );
  }

  void _submit($Order order) {
    order.clearItems();

    if (_item1.qty > 0) {
      order.addItem(item: _item1, price: _item1.price * _item1.qty);
    }

    if (_item2.qty > 0) {
      order.addItem(item: _item2, price: _item2.price * _item2.qty);
    }

    navigateTo(context, BuildingMaterialTimeAndLocationPage(_order));
  }
}

class _ContainerDescription extends RichText {
  _ContainerDescription({String text, String size})
      : super(
          text: TextSpan(
            text: text,
            style: TextStyle(
              color: Color(0xFF313F53),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: ' ' + size,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF313F53),
                ),
              )
            ],
          ),
        );
}

class _ContainerSelection extends DarkContainer {
  _ContainerSelection({
    double qty,
    double price,
    void Function(double qty) onChanged,
  }) : super(
          height: 80,
          margin: const EdgeInsets.only(top: 20, bottom: 30),
          padding: const EdgeInsets.all(15),
          child: Row(children: [
            Expanded(
              child: Column(children: [
                Text('Quantity',
                    style: TextStyle(
                        color: Color(0xFF313F53), fontWeight: FontWeight.bold)),
                Spacer(),
                Text('${price.toStringAsFixed(2)} SAR',
                    style: TextStyle(
                      color: Color(0xFF313F53),
                    )),
              ], crossAxisAlignment: CrossAxisAlignment.start),
            ),
            Counter(initialValue: qty, onChange: onChanged)
          ]),
        );
}
