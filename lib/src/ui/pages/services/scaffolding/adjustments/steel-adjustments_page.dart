import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/ui/pages/services/scaffolding/calculations/ceiling-calculation_page.dart';
import 'package:haweyati/src/ui/pages/services/scaffolding/calculations/facades-calculation_page.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/ui/widgets/counter.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/utils/const.dart';

class SteelAdjustmentsPage extends StatelessWidget {
  final _calculations;
  SteelAdjustmentsPage(this._calculations) {
    if (_calculations != null) {
      if (_calculations is FacadesCalculation) {
      } else if (_calculations is CeilingCalculation) {
      } else throw 'Un-supported Type was provided';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableView(
      showBackground: true,
      padding: const EdgeInsets.fromLTRB(
        15, 0, 15, 100
      ),
      children: [
        HeaderView(
          title: 'Scaffolding Details',
          subtitle: loremIpsum.substring(0, 50),
        ),

        _ScaffoldingItemSelector(
          text: 'Main Frame',
          price: 100,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: _ScaffoldingItemSelector(
            text: 'Cross Brace',
            price: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: _ScaffoldingItemSelector(
            text: 'Connecting Bars',
            price: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: _ScaffoldingItemSelector(
            text: 'Adjustable Base',
            price: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: _ScaffoldingItemSelector(
            text: 'Stabilizers',
            price: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: _ScaffoldingItemSelector(
            text: 'Wood planks',
            price: 100,
          ),
        ),
      ],

      bottom: RaisedActionButton(
        label: 'Rent Now',
        onPressed: () {},
      ),
    );
  }
}

class _ScaffoldingItemSelector extends DarkContainer {
  _ScaffoldingItemSelector({
    String text,
    double price
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
        Counter(onChange: (val) {}),
        SizedBox(height: 10),
        Counter(
          increment: .5,
          maxValue: 4.0,
          minValue: 1.0,
          allowDouble: true,
          onChange: (val) {}
        )
      ])
    ], mainAxisAlignment: MainAxisAlignment.spaceBetween)
  );
}

