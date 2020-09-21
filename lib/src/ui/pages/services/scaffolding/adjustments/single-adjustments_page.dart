import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/ui/widgets/counter.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/utils/const.dart';

class SingleAdjustmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      body: DottedBackgroundView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15
        ),
        child: Column(children: [
          HeaderView(
            title: 'Scaffolding Details',
            subtitle: loremIpsum.substring(0, 50),
          ),

          _ScaffoldingItemSelector(
            text: 'Quantity',
            price: 100,
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
                value: 1,
                groupValue: 1,
                onChanged: (value) {

                },
              ),

              Text('Half Steel')
            ], crossAxisAlignment: WrapCrossAlignment.center)),
            Expanded(child: Wrap(children: [
              Radio(
                value: 2,
                groupValue: 1,
                onChanged: (value) {

                },
              ),

              Text('Full Steel')
            ], crossAxisAlignment: WrapCrossAlignment.center)),
          ], mainAxisAlignment: MainAxisAlignment.spaceBetween)
          // Radio(
          // )
        ], crossAxisAlignment: CrossAxisAlignment.start),
      ),

      bottom: FlatActionButton(
        label: 'Rent Now',
        onPressed: () {},
      )
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

