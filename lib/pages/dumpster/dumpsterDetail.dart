import 'package:flutter/material.dart';
import 'package:haweyati/models/dumpster_model.dart';
import 'package:haweyati/pages/dumpster/dumpsterServicesdetail.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/custom-navigator.dart';
import 'package:haweyati/widgits/stackButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DumpsterItemDetail extends StatefulWidget {
  final Dumpster dumpster;
  DumpsterItemDetail({this.dumpster});
  @override
  _DumpsterItemDetailState createState() => _DumpsterItemDetailState();
}

class _DumpsterItemDetailState extends State<DumpsterItemDetail> {
  Dumpster dumpster;
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    dumpster = widget.dumpster;
    initDetail();
  }

  initDetail() async {
    var prefs = await SharedPreferences.getInstance();
    for (var price in dumpster.pricing) {
      if(price.city == prefs.getString('city')){
        setState(() {
          dumpster.pricing = [
            price
          ];
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xffffffff),
      appBar: HaweyatiAppBar(context: context,),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: (Image.network(HaweyatiService.convertImgUrl(dumpster.image.name),fit: BoxFit.cover,)),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  dumpster.size,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 15,
                ),
               dumpster.pricing!=null ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      dumpster.pricing[0]?.rent.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      dumpster.pricing[0]?.days.toString(),
                      style: TextStyle(color: Colors.black54),
                    )
                  ],
                ) : SizedBox(),
                SizedBox(
                  height: 20,
                ),
                Text(dumpster.description),
              ],
            ),
          ),
          StackButton(
            onTap: () {
              CustomNavigator.navigateTo(context, DumpsterServicesDetail(dumpsters: dumpster,));
            },
            buttonName: "Rent Now",
          )
        ],
      ),
    );
  }
}
