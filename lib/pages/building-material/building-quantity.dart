import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/models/building-material_sublist.dart';
import 'package:haweyati/models/hive-models/orders/building-material-order.dart';
import 'package:haweyati/pages/building-material/building-time-location.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/container-with-add-remove-item.dart';
import 'package:haweyati/widgits/custom-navigator.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';
import 'package:hive/hive.dart';

class BuildingProductDetail extends StatefulWidget {
  final BMProduct item;
  BuildingProductDetail({this.item});
  @override
  _BuildingProductDetailState createState() => _BuildingProductDetailState();
}

class _BuildingProductDetailState extends State<BuildingProductDetail> {
  int qty20Yard = 1;
  int qty12Yard = 0;

  void addBuildingOrder(List<BMOrder> bmOrder) async {
   var box = await Hive.openBox('bmorder');
   await box.clear();
   box.addAll(bmOrder);
   bmOrder.forEach((element) {element.save();});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(
        context: context,
      ),
      body: HaweyatiAppBody(
        title: "Product Detail",
        detail: loremIpsum.substring(0, 90),
        child: ListView(
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                      text: "Small Container,",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: "     12 Yard",
                            style: TextStyle(
                              fontSize: 12,
                            ))
                      ]),
                )),
            SizedBox(
              height: 10,
            ),
            QuantitySelector(
              canBeZero: true,
              title: 'Price: ${qty12Yard == 1 ? widget.item.pricing.first.price12yard : widget.item.pricing.first.price12yard * qty12Yard.toDouble()} ',
              onValueChange: (int val){
                setState(() {
                  qty12Yard=val;
                });
              },
              subtitle: "Quantity",
            ),
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                      text: "Big Container,",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: "     20 Yard",
                            style: TextStyle(
                              fontSize: 12,
                            ))
                      ]),
                )),
            SizedBox(
              height: 10,
            ),
            QuantitySelector(
              canBeZero: false,
              title: 'Price: ${qty20Yard == 1 ? widget.item.pricing.first.price20yard :
              widget.item.pricing.first.price20yard * qty20Yard.toDouble()} ',
              onValueChange: (int val){
                setState(() {
                  qty20Yard=val;
                });
              },
              subtitle: "Quantity",
            ),
            SizedBox(
              height: 20,
            ),
          ],
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
        btnName: tr("Continue"),
        onTap: () async {
          print(widget.item.toJson());

          List<BMOrder> bmOrders = [];
          if(qty20Yard!=0){
            bmOrders.add(BMOrder(
              product: widget.item,
                qty: qty20Yard,
                size: '20 Yard',
                total: qty20Yard * widget.item.pricing.first.price20yard,
                price: widget.item.pricing.first.price20yard,
            ));
          }

          if(qty12Yard!=0){
            bmOrders.add(BMOrder(
              product: widget.item,
              qty: qty12Yard,
              size: '12 Yard',
              total: qty12Yard * widget.item.pricing.first.price12yard,
              price: widget.item.pricing.first.price12yard,
            ));
          }

        await addBuildingOrder(bmOrders);
            CustomNavigator.navigateTo(context, BuildingTimeAndLocation(bmItem: widget.item,));
        },
        showButton: true,
      ),
    );
  }
}
