import 'time-location_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/ui/widgets/counter.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/views/order-progress_view.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:haweyati/src/models/services/building-material/model.dart';
import 'package:haweyati/src/models/order/building-material/order-item_model.dart';

class BuildingMaterialServiceDetailPage extends StatefulWidget {
  final BuildingMaterial item;
  BuildingMaterialServiceDetailPage(this.item);

  @override
  _BuildingMaterialServiceDetailPageState createState() => _BuildingMaterialServiceDetailPageState();
}

class _BuildingMaterialServiceDetailPageState extends State<BuildingMaterialServiceDetailPage> {
  final _order = Order(OrderType.buildingMaterial);

  final _item1 = BuildingMaterialOrderItem();
  final _item2 = BuildingMaterialOrderItem();

  @override
  void initState() {
    super.initState();
    
    _item1.product = _item2.product = widget.item;

    _item1.size = '12 yards';
    _item1.price = widget.item.pricing.first.price12yard;

    _item2.size = '20 yards';
    _item2.price = widget.item.pricing.first.price20yard;
  }
  
  @override
  Widget build(BuildContext context) {
    return OrderProgressView(
      children: [
        HeaderView(
          title: 'Product Details',
          subtitle: loremIpsum.substring(0, 70),
        ),

        RichText(
          text: TextSpan(
            text: 'Small Container,',
            style: TextStyle(
              color: Color(0xFF313F53),
              fontSize: 13,
              fontWeight: FontWeight.bold
            ),
            children: [
              TextSpan(
                text: ' 12 Yards',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF313F53)
                )
              )
            ]
          ),
        ),

        DarkContainer(
          height: 80,
          margin: const EdgeInsets.only(
            top: 20, bottom: 30
          ),
          padding: const EdgeInsets.all(15),
          child: Row(children: [
            Expanded(
              child: Column(children: [
                Text('Quantity', style: TextStyle(
                  color: Color(0xFF313F53),
                  fontWeight: FontWeight.bold
                )),
                Spacer(),
                Text('${widget.item.pricing.first.price12yard.toStringAsFixed(2)} SAR', style: TextStyle(
                  color: Color(0xFF313F53),
                )),
              ], crossAxisAlignment: CrossAxisAlignment.start),
            ),

            Counter(
              initialValue: _item1.qty.toDouble(),
              onChange: (count) => setState(() => _item1.qty = count.round()),
            )
          ]),
        ),

        RichText(
          text: TextSpan(
            text: 'Big Container,',
            style: TextStyle(
              color: Color(0xFF313F53),
              fontSize: 13,
              fontWeight: FontWeight.bold
            ),
            children: [
              TextSpan(
                text: ' 20 Yards',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF313F53)
                )
              )
            ]
          ),
        ),

        DarkContainer(
          height: 80,
          margin: const EdgeInsets.only(
            top: 20, bottom: 30
          ),
          padding: const EdgeInsets.all(15),
          child: Row(children: [
            Expanded(
              child: Column(children: [
                Text('Quantity', style: TextStyle(
                  color: Color(0xFF313F53),
                  fontWeight: FontWeight.bold
                )),
                Spacer(),
                Text('${widget.item.pricing.first.price20yard.toStringAsFixed(2)} SAR ', style: TextStyle(
                  color: Color(0xFF313F53),
                )),
              ], crossAxisAlignment: CrossAxisAlignment.start),
            ),

            Counter(
              initialValue: _item2.qty.toDouble(),
              onChange: (count) => setState(() => _item2.qty = count.round()),
            )
          ]),
        ),
      ],

      onContinue: _item1.qty > 0 || _item2.qty > 0 ? _submit : null,
    );
  }
  
  void _submit() {
    _order.items = [
      if (_item1.qty > 0)
        OrderItemHolder(
          item: _item1,
          subtotal: _item1.qty * _item1.price
        ),

      if (_item2.qty > 0)
        OrderItemHolder(
          item: _item2,
          subtotal: _item2.qty * _item2.price
        )
    ];

    navigateTo(context, BuildingMaterialTimeAndLocationPage(_order));
  }
}