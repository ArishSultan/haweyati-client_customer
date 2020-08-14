import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/models/hive-models/scaffolding-item_model.dart';
import 'package:haweyati/models/temp-model.dart';
import 'package:haweyati/pages/scaffolding/ScaffoldingPlusMinusDropContainer.dart';
import 'package:haweyati/pages/scaffolding/scaffoldingTimeLocation.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';

class ScaffoldingServicesDetail extends StatefulWidget {
  ConstructionService constructionService;
  ScaffoldingServicesDetail({this.constructionService});
  @override
  _ScaffoldingServicesDetailState createState() => _ScaffoldingServicesDetailState();
}

class _ScaffoldingServicesDetailState extends State<ScaffoldingServicesDetail> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(context: context,),
      body: HaweyatiAppBody(
        title: "Services Detail",
        detail: loremIpsum.substring(0,50), btnName:tr("Continue"),onTap: (){

        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
            ScaffoldingTimeAndLocation(
          constructionService: widget.constructionService,
        )));

      },showButton: true,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: <Widget>[
//            ScaffoldingItem(
//              item: scaffoldingItems[0],
//              extra: "Main Frame",
//              dayprice: "SAR 345/day",
//            ),
//            ScaffoldingItem(
//              extra: "Cross Brace",
//              dayprice: "SAR 365/day",
//            ),
//            ScaffoldingItem(
//              extra: "Connecting Bar",
//              dayprice: "SAR 345/day",
//            ),
//            ScaffoldingItem(
//              extra: "Adjustable Base",
//              dayprice: "SAR 365/day",
//            ),ScaffoldingItem(
//              extra: "Stabilizer",
//              dayprice: "SAR 345/day",
//            ),
//            ScaffoldingItem(
//
//              extra: "Wood Planks",
//              dayprice: "SAR 365/day",
//            ),

          ],
        ),
      ),
      backgroundColor: Color(0xffffffff),
    );
  }
}
