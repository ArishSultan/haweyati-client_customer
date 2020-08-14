import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/models/dumpster_model.dart';
import 'package:haweyati/models/hive-models/orders/dumpster-order_model.dart';
import 'package:haweyati/pages/dumpster/dumpster-time-location.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/container-with-add-remove-item.dart';
import 'package:haweyati/widgits/container-with-subtitle.dart';
import 'package:haweyati/widgits/custom-navigator.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';
import 'package:hive/hive.dart';

class DumpsterServicesDetail extends StatefulWidget {
 final Dumpster dumpsters;
 DumpsterServicesDetail({this.dumpsters});
  @override
  _DumpsterServicesDetailState createState() => _DumpsterServicesDetailState();
}

class _DumpsterServicesDetailState extends State<DumpsterServicesDetail> {

  int extraDay = 0;
  double extraDayPrice;

  @override
  void initState() {
    super.initState();
    extraDayPrice = widget.dumpsters.pricing[0].extraDayRent;
  }

  void orderDumpster(DumpsterOrder order) async {
    final box = await Hive.openBox('dumpster');
    await box.clear();
    box.add(order);
    order.save();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(context: context,),
      body: HaweyatiAppBody(
        title: "Services Detail",
        detail: widget.dumpsters.description,
        btnName: tr("Continue"),
        onTap: () async {
         await orderDumpster(DumpsterOrder(
           dumpster: widget.dumpsters,
             extraDayPrice: extraDayPrice * extraDay,
             extraDays: extraDay,
           total: extraDay == 0 ? widget.dumpsters.pricing[0].rent : (extraDayPrice * extraDay) + widget.dumpsters.pricing[0].rent
         ));
          CustomNavigator.navigateTo(context, DumpsterTimeAndLocation(dumpster: widget.dumpsters,));
          },
        showButton: true,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            SubtileContainer(
              image: widget.dumpsters.image.name,
              name: widget.dumpsters.size + " Yard Dumpster",
              onTap: () {

              },
              subtitle: "${widget.dumpsters.pricing[0].rent} SR / ${widget.dumpsters.pricing[0].days} days",
            ),
            QuantitySelector(
              canBeZero: true,
              onValueChange: (int val){
                setState(() {
                  extraDay=val;
                });
              },
              subtitle: "Add Extra Days",
              title: 'Price: ' + (extraDayPrice * extraDay).toString() + ' SR',
            )
          ],
        ),
      ),
      backgroundColor: Color(0xffffffff),
    );
  }
}
