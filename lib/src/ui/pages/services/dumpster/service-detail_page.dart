import 'time-location_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/utils/const.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/counter.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/models/dumpster_model.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/flat-action-button.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/models/hive-models/orders/order_model.dart';
import 'package:haweyati/models/hive-models/orders/order-details_model.dart';
import 'package:haweyati/models/hive-models/orders/dumpster-order_model.dart';

class DumpsterServiceDetailPage extends StatelessWidget {
  final Dumpster dumpster;
  final Order _order = Order();

  DumpsterServiceDetailPage(this.dumpster) {
    _order.detail = OrderDetail(
      items: [DumpsterOrderItem(
        dumpster: dumpster,
      )],
      netTotal: 0
    );
  }

  String get _size => dumpster.size;
  int get _days => dumpster.pricing.first.days;
  double get _rent => dumpster.pricing.first.rent;
  double get _extraDayRent => dumpster.pricing.first.extraDayRent;
  DumpsterOrderItem get _item => _order.detail.items.first as DumpsterOrderItem;

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      appBar: HaweyatiAppBar(progress: .25),
      body: DottedBackgroundView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
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
                  HaweyatiService.resolveImage(dumpster.image.name),
                  width: 50,
                  height: 50,
                ),
              ),

              Expanded(child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('$_size Yard Dumpster', style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: ''
                  )),
                ),
                Text('${_rent.round()} SAR/$_days days'),
              ], crossAxisAlignment: CrossAxisAlignment.start,)),

              Icon(CupertinoIcons.right_chevron, color: Colors.grey.shade600),
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
                    fontWeight: FontWeight.bold, fontFamily: ''
                  )),
                ),
                Text('${_extraDayRent.round()} SAR/day'),
              ], crossAxisAlignment: CrossAxisAlignment.start)),

              Counter(
                initialValue: _item.extraDays.toDouble(),
                onChange: (count) => _item.extraDays = count.round()
              )
            ])
          ),
        ]),
      ),

      bottom: FlatActionButton(
        label: 'Continue',
        onPressed: () {
          navigateTo(context, DumpsterTimeAndLocationPage(_order));
          // final extraDayPrice = _extraDayRent * _extraDays;
          // final order = DumpsterOrder(
          //   dumpster: dumpster,
          //   extraDayPrice: extraDayPrice,
          //   extraDays: _extraDays,
          //   total: _rent + extraDayPrice
          // );
        }
      ),
    );
  }
}
