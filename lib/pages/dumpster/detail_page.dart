import 'package:flutter/material.dart';
import 'package:haweyati/models/dumpster_model.dart';
import 'package:haweyati/models/rent_model.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/widgits/custom-navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dumpsterServicesdetail.dart';

class DumpsterDetailPage extends StatefulWidget {
  final Dumpster dumpster;

  DumpsterDetailPage(this.dumpster)
      : assert(dumpster != null);

  @override
  _DumpsterDetailPageState createState() => _DumpsterDetailPageState();
}

class _DumpsterDetailPageState extends State<DumpsterDetailPage> {

  Rent rent;
  String userCity;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    SharedPreferences.getInstance().then((value) {
      userCity = value.getString('city');
      for(int i=0; i<widget.dumpster.pricing.length; ++i){
        if(widget.dumpster.pricing[i].city == userCity){
          setState(() {
            widget.dumpster.pricing[0] = widget.dumpster.pricing[i];
          });
          break;
        }
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(context,progress: .4),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(
            height: 250,
            child: Image.network(
                  HaweyatiService.resolveImage(widget.dumpster.image.name),
                  height: 250,
                )),

          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(widget.dumpster.size + ' Dumpster', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          SizedBox(height: 15),
//          Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 10),
//            child: Text(widget.dumpster.pricing[0].rent.toString() + ' Dumpster', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: RichText(

                text: TextSpan(
              text: widget.dumpster.pricing[0].rent.toString(),
              style: TextStyle(color: Theme.of(context).accentColor),
              children: [TextSpan(text: ' SAR', style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black))]
            )),
          ),
          SizedBox(height: 20),
          Text(widget.dumpster.description),
        ], crossAxisAlignment: CrossAxisAlignment.start),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SizedBox(
          height: 45,
          child: FlatButton(
            child: Text("Rent Now", style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              CustomNavigator.navigateTo(context, DumpsterServicesDetail(dumpsters: widget.dumpster,));
            },
            textColor: Colors.white,
            disabledColor: Colors.grey.shade400,
            color: Theme.of(context).accentColor,
            shape: StadiumBorder(),
          ),
        ),
      ),
    );
  }
}
