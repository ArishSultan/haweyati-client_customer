import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/ui/widgets/counter.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/views/order-progress_view.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:haweyati/src/models/services/dumpster/model.dart';
import 'package:haweyati/src/models/order/dumpster/order-item_model.dart';
import 'package:haweyati/src/ui/pages/services/dumpster/time-location_page.dart';

class DumpsterServiceDetailPage extends StatelessWidget {
  final Dumpster _dumpster;
  final _order = Order(OrderType.dumpster);

  DumpsterServiceDetailPage(this._dumpster) {
    _order.items = [OrderItemHolder(
      item: DumpsterOrderItem(product: _dumpster)
    )];
  }

  DumpsterOrderItem get _orderItem => _order.items.first.item;

  @override
  Widget build(BuildContext context) {
    return OrderProgressView(
      children: [
        HeaderView(
          title: 'Service Details',
          subtitle: loremIpsum.substring(0, 70),
        ),

        DarkContainer(
          padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image.network(
                HaweyatiService.resolveImage(_dumpster.image.name),
                width: 50, height: 50,
              ),
            ),

            Expanded(child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('${_dumpster.size} Yard Dumpster', style: TextStyle(
                  color: Color(0xFF313F53),
                  fontWeight: FontWeight.bold, fontFamily: ''
                )),
              ),
              Text('${_dumpster.rent.toStringAsFixed(2)} SAR/${_dumpster.days} days', style: TextStyle(
                color: Color(0xFF313F53),
              )),
            ], crossAxisAlignment: CrossAxisAlignment.start)),
          ])
        ),

        DarkContainer(
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Row(children: [
            Expanded(child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Add Extra Days', style: TextStyle(
                  color: Color(0xFF313F53),
                  fontWeight: FontWeight.bold, fontFamily: ''
                )),
              ),
              Text('${_dumpster.extraDayRent.toStringAsFixed(2)} SAR/day', style: TextStyle(
                color: Color(0xFF313F53),
              )),
            ], crossAxisAlignment: CrossAxisAlignment.start)),

            Counter(
              initialValue: _orderItem.extraDays?.toDouble() ?? 0,
              onChange: (count) => _orderItem.extraDays = count.round()
            )
          ])
        ),
      ],

      onContinue: () {
        _order.items.first.subtotal =
            _orderItem.extraDaysPrice =
            _dumpster.extraDayRent * _orderItem.extraDays;

        navigateTo(context, DumpsterTimeAndLocationPage(_order));
      },
    );
  }
}