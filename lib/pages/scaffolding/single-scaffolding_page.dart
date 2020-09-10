import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/models/hive-models/orders/scaffolding-item_model.dart';
import 'package:haweyati/pages/scaffolding/scaffoldingTimeLocation.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/container-with-add-remove-item.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';

class SingleScaffoldingPage extends StatefulWidget {
  @override
  _SingleScaffoldingPageState createState() => _SingleScaffoldingPageState();
}

class _SingleScaffoldingPageState extends State<SingleScaffoldingPage> {
  int quantity = 1;
  String groupValue = 'Full Steel';
  String selected = 'Full Steel';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(context: context,),
      body: HaweyatiAppBody(
        title: 'Service Details',
        detail: loremIpsum.substring(0,50),
        btnName:tr("Rent Now"),
        onTap: (){
          CustomNavigator.navigateTo(context, ScaffoldingTimeAndLocation(order: [
            ScaffoldingItemModel(
              qty: quantity,
              price: (345 * quantity).toDouble(),
              name: 'Single Scaffolding',

            )
          ],

          ));
        },
        showButton: true,
        child:  ListView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: <Widget>[
            QuantitySelector(
              onValueChange: (int val){
                setState(() {
                  quantity=val;
                });
              },
              title: 'SAR ${quantity * 345} /day',
              subtitle: 'Quantity',
            ),
            Text("Mesh Plate Form",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text("Half Steel"),
                    onChanged: (String val){
                      setState(() {
                        groupValue = val;
                      });
                    },
                    groupValue: groupValue,
                    value: 'Half Steel',
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text("Full Steel"),
                    onChanged: (String val){
                      setState(() {
                        groupValue = val;
                      });
                    },
                    groupValue: groupValue,
                    value: 'Full Steel',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xffffffff),
    );
  }
}
