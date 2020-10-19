import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/models/order/scaffoldings/order-item_model.dart';
import 'package:haweyati/src/services/scaffolding_service.dart';
import 'package:haweyati/src/ui/pages/services/scaffolding/time-location_page.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/widgets/scaffolding-item-selector.dart';
import 'package:haweyati/src/models/services/scaffolding/scaffolding-types.dart';
import 'package:haweyati/src/models/services/scaffolding/single-scaffolding_model.dart';
import 'package:haweyati/src/ui/pages/services/scaffolding/adjustments/wrapper_page.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class SingleAdjustmentsPage extends StatefulWidget {
  @override
  _SingleAdjustmentsPageState createState() => _SingleAdjustmentsPageState();
}

class _SingleAdjustmentsPageState extends State<SingleAdjustmentsPage> {
  final _order = Order(OrderType.scaffolding);

  ScaffoldingPrice _pricing;
  final _scaffolding = SingleScaffolding();

  @override
  Widget build(BuildContext context) {
    return WrapperPage(
      type: ScaffoldingType.single,
      onPressed: _scaffolding.item.qty > 0 ? () {
        final _price = _pricing.rent * _scaffolding.item.qty;

        _order.items = [OrderItemHolder(
          item: ScaffoldingOrderItem(
            product: _scaffolding,
            type: ScaffoldingType.single
          ),

          subtotal: _price
        )];
        _order.total = _price;

        navigateTo(context, ScaffoldingTimeAndLocationPage(_order));
      } : null,
      builder: (pricing) {
        _pricing = pricing;

        return [
          HeaderView(
            title: 'Scaffolding Details',
            subtitle: loremIpsum.substring(0, 50),
          ),

          ScaffoldingItemSelector(
            text: 'Quantity',
            price: pricing.rent,
            item: _scaffolding.item,
            onChange: () => setState(() {}),
          ),

          Padding(
            padding: const EdgeInsets.only(
                left: 8, top: 20
            ),
            child: Text('Mesh Plate Form', style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
          ),

          Row(children: [
            Expanded(child: Wrap(children: [
              Radio(
                value: SingleScaffoldingType.halfSteel,
                groupValue: _scaffolding.type,
                onChanged: (value) {
                  setState(() {
                    _scaffolding.type = SingleScaffoldingType.halfSteel;
                  });
                },
              ),

              Text('Half Steel')
            ], crossAxisAlignment: WrapCrossAlignment.center)),
            Expanded(child: Wrap(children: [
              Radio(
                value: SingleScaffoldingType.fullSteel,
                groupValue: _scaffolding.type,
                onChanged: (value) {
                  setState(() {
                    _scaffolding.type = SingleScaffoldingType.fullSteel;
                  });
                },
              ),

              Text('Full Steel')
            ], crossAxisAlignment: WrapCrossAlignment.center)),
          ], mainAxisAlignment: MainAxisAlignment.spaceBetween)
        ];
      }
    );
  }
}
