import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/models/services/scaffolding/scaffolding-item_model.dart';
import 'package:haweyati/src/models/services/scaffolding/scaffolding-types.dart';
import 'package:haweyati/src/models/services/scaffolding/steel-scaffolding_model.dart';
import 'package:haweyati/src/services/scaffolding_service.dart';
import 'package:haweyati/src/ui/pages/services/scaffolding/adjustments/wrapper_page.dart';
import 'package:haweyati/src/ui/pages/services/scaffolding/calculations/ceiling-calculation_page.dart';
import 'package:haweyati/src/ui/pages/services/scaffolding/calculations/facades-calculation_page.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/widgets/counter.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/const.dart';

class SteelAdjustmentsPage extends StatefulWidget {
  final _calculations;
  SteelAdjustmentsPage(this._calculations) {
    if (_calculations != null) {
      if (_calculations is FacadesCalculation) {
      } else if (_calculations is CeilingCalculation) {
      } else throw 'Un-supported Type was provided';
    }
  }

  @override
  _SteelAdjustmentsPageState createState() => _SteelAdjustmentsPageState();
}

class _SteelAdjustmentsPageState extends State<SteelAdjustmentsPage> {
  ScaffoldingPrice _pricing;

  final data = SteelScaffolding()
    ..mainFrame = ScaffoldingItem()
    ..crossBrace = ScaffoldingItem()
    ..connectingBars = ScaffoldingItem()
    ..adjustableBase = ScaffoldingItem()
    ..stabilizers = ScaffoldingItem()
    ..woodPlanks = ScaffoldingItem();

  bool get _allow =>
      (data.mainFrame.qty > 0) &&
      (data.crossBrace.qty > 0) &&
      (data.connectingBars.qty > 0) &&
      (data.adjustableBase.qty > 0) &&
      (data.stabilizers.qty > 0) &&
      (data.woodPlanks.qty > 0);

  @override
  Widget build(BuildContext context) {
    return WrapperPage(
      type: ScaffoldingType.steel,
      builder: (val) {
        _pricing = val;

        return <Widget>[
          HeaderView(
            title: 'Scaffolding Details',
            subtitle: loremIpsum.substring(0, 50),
          ),

          _ScaffoldingItemSelector(
            text: 'Main Frame',
            price: 100,
            onChange1: (val) =>
                setState(() => data.mainFrame.qty = val.toInt()),
            onChange2: (val) => setState(() => data.mainFrame.size = val),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: _ScaffoldingItemSelector(
              text: 'Cross Brace',
              price: 100,
              onChange1: (val) =>
                  setState(() => data.crossBrace.qty = val.toInt()),
              onChange2: (val) => setState(() => data.crossBrace.size = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: _ScaffoldingItemSelector(
              text: 'Connecting Bars',
              price: 100,
              onChange1: (val) =>
                  setState(() => data.connectingBars.qty = val.toInt()),
              onChange2: (val) =>
                  setState(() => data.connectingBars.size = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: _ScaffoldingItemSelector(
              text: 'Adjustable Base',
              price: 100,
              onChange1: (val) =>
                  setState(() => data.adjustableBase.qty = val.toInt()),
              onChange2: (val) =>
                  setState(() => data.adjustableBase.size = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: _ScaffoldingItemSelector(
              text: 'Stabilizers',
              price: 100,
              onChange1: (val) =>
                  setState(() => data.stabilizers.qty = val.toInt()),
              onChange2: (val) => setState(() => data.stabilizers.size = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: _ScaffoldingItemSelector(
              text: 'Wood planks',
              price: 100,
              onChange1: (val) =>
                  setState(() => data.woodPlanks.qty = val.toInt()),
              onChange2: (val) => setState(() => data.woodPlanks.size = val),
            ),
          ),
        ];
      },

      // onPressed: _allow ? () {
      //   final _price = _pricing.rent * _scaffolding.item.qty;
      //
      //   _order.items = [OrderItemHolder(
      //       item: ScaffoldingOrderItem(
      //           product: _scaffolding,
      //           type: ScaffoldingType.single
      //       ),
      //
      //       subtotal: _price
      //   )];
      //   _order.total = _price;
      //
      //   navigateTo(context, ScaffoldingTimeAndLocationPage(_order))
      // }: null
    );
  }
}

class _ScaffoldingItemSelector extends DarkContainer {
  _ScaffoldingItemSelector({
    String text,
    double price,
    Function(double) onChange1,
    Function(double) onChange2
  }): super(
    height: 86,
    padding: const EdgeInsets.all(15),
    child: Row(children: [
      Column(
        children: [
          Text(text, style: TextStyle(
            color: Color(0xFF313F53),
            fontWeight: FontWeight.bold
          )),
          Spacer(),
          Text('SAR ${price.round()}/day')
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      Column(children: [
        Counter(onChange: onChange1),
        SizedBox(height: 10),
        Counter(
          increment: .5,
          maxValue: 4.0,
          minValue: 1.0,
          allowDouble: true,
          onChange: onChange2
        )
      ])
    ], mainAxisAlignment: MainAxisAlignment.spaceBetween)
  );
}

