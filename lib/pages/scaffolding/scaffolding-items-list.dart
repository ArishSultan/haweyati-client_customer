import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/models/hive-models/orders/scaffolding-item_model.dart';
import 'package:haweyati/models/temp-model.dart';
import 'package:haweyati/pages/scaffolding/scaffolding-item-selector.dart';
import 'package:haweyati/pages/scaffolding/scaffoldingTimeLocation.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';

class ScaffoldingServicesDetail extends StatefulWidget {
  final ConstructionService constructionService;
  ScaffoldingServicesDetail({this.constructionService});
  @override
  _ScaffoldingServicesDetailState createState() => _ScaffoldingServicesDetailState();
}

class _ScaffoldingServicesDetailState extends State<ScaffoldingServicesDetail> {
  List<ScaffoldingItemModel> orderItems = [];
  int qty = 0;
  double price = 0.0;

  bool validateItems(){
    orderItems.clear();
    singleScaffoldingItems.forEach((element) {
      if(element.qty!=0){
        orderItems.add(
            element
        );
      }
      qty+=element.qty;
    });
    if(qty==0) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(context: context,),
      body: HaweyatiAppBody(
        title: "Services Detail",
        detail: loremIpsum.substring(0,50),
        btnName:tr("Rent Now"),
        onTap: (){
          if(validateItems()){

            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                ScaffoldingTimeAndLocation(
                  order: orderItems,
                  constructionService: widget.constructionService,
                )));

          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("You must select at least one item"),
              behavior: SnackBarBehavior.floating,
            ));
          }


      },showButton: true,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: <Widget>[
            ScaffoldingItem(
              item: singleScaffoldingItems[0],
              onValueChange: (ScaffoldingItemModel val){
                singleScaffoldingItems[0] = val;
              },
            ),
            ScaffoldingItem(
              item: singleScaffoldingItems[1],
              onValueChange: (ScaffoldingItemModel val){
                singleScaffoldingItems[1] = val;
              },
            ),
            ScaffoldingItem(
              item: singleScaffoldingItems[1],
              onValueChange: (ScaffoldingItemModel val){
                singleScaffoldingItems[1] = val;
              },
            ),
            ScaffoldingItem(
              item: singleScaffoldingItems[2],
              onValueChange: (ScaffoldingItemModel val){
                singleScaffoldingItems[2] = val;
              },
            ),
            ScaffoldingItem(
              item: singleScaffoldingItems[3],
              onValueChange: (ScaffoldingItemModel val){
                singleScaffoldingItems[3] = val;
              },
            ),
            ScaffoldingItem(
              item: singleScaffoldingItems[4],
              onValueChange: (ScaffoldingItemModel val){
                singleScaffoldingItems[4] = val;
                print(val.toJson());
              },
            ),
            ScaffoldingItem(
              item: singleScaffoldingItems[5],
              onValueChange: (ScaffoldingItemModel val){
                singleScaffoldingItems[5] = val;
              },
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xffffffff),
    );
  }
}
