import 'package:easy_localization/easy_localization.dart';
import 'package:haweyati/models/hive-models/orders/order-details_model.dart';
import 'package:haweyati/models/hive-models/orders/scaffolding-item_model.dart';
import 'package:haweyati/models/order-time_and_location.dart';
import 'package:haweyati/src/ui/widgets/date-picker-field.dart';
import 'package:haweyati/pages/scaffolding/order.dart';
import 'package:haweyati/services/time-slots_service.dart';
import 'package:haweyati/src/utlis/simple-future-builder.dart';
import 'package:haweyati/widgits/order-location-picker.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/models/temp-model.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';

class ScaffoldingTimeAndLocation extends StatefulWidget {
  final OrderDetail orderDetail;
  final List<ScaffoldingItemModel> order;
  final ConstructionService constructionService;
  ScaffoldingTimeAndLocation({this.constructionService,this.order,this.orderDetail});
  @override
  _ScaffoldingTimeAndLocationState createState() => _ScaffoldingTimeAndLocationState();
}

class _ScaffoldingTimeAndLocationState extends State<ScaffoldingTimeAndLocation> {
  DateTime dateTime = DateTime.now();
  Future<List<String>> timeSlots;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  OrderLocation dropOffLocation;
  String start = "...";
  bool scaffoldingSwitch =false;

  onSwitchValueChange(bool newVal){
    setState(() {
      scaffoldingSwitch =newVal;
    });
  }


  String selectedInterval;

  Future<List<String>> fetchTimeSlots([bool flag=true]) async {
    // timeSlots = TimeSlotsService().getAvailableTimeSlots(3,flag);
    // timeSlots.then((value) {
    //   selectedInterval = value[0];
    // });
    return timeSlots;
  }

  @override
  void initState() {
    super.initState();
    fetchTimeSlots();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: HaweyatiAppBar(context: context,),
      body: HaweyatiAppBody(
        title: "Time & Location",
        detail: loremIpsum.substring(0, 40),
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 100),
          children: <Widget>[  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              OrderLocationPicker(
                onLocationChanged: (OrderLocation location) {
                  dropOffLocation = location;
                },
              ),
            ],
          ),
            SizedBox(
              height: 20,
            ),
            _buildRow(
                dropoffdate: "Drop-off Date", dropofftime: "Drop-off Time"),
            Row(
              children: <Widget>[
                Expanded(
                  child: DatePickerField(
                    // onChanged: (date) async {
                    //   if(date!=null){
                    //     dateTime = date;
                    //     print(date?.day);
                    //     timeSlots = TimeSlotsService().getAvailableTimeSlots(3,date.day == DateTime.now().day);
                    //     await timeSlots;
                    //     setState(() {
                    //     });
                    //   }
                    // } ,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(color:Color(0xfff2f2f2f2),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                        SimpleFutureBuilder.simpler(
                          context : context,
                          future: timeSlots,
                          builder: (AsyncSnapshot<List<String>> timeSlots){
                            return DropdownButton<String>(
                              underline: SizedBox(),
                              value: selectedInterval,
                              items: timeSlots.data.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:14.0),
                                    child: Text('$value', textAlign: TextAlign.center),
                                  ),
                                );
                              }).toList(),
                              onChanged: (_) {
                                setState(() {
                                  selectedInterval = _;
                                });
                              },
                            );
                          },
                        ),
                      ],)
                  ),
                )
              ],
            ),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Text("Scaffolding Fixing",style: TextStyle(fontWeight: FontWeight.bold),),
              Switch(value: scaffoldingSwitch, onChanged: (newVal){
                onSwitchValueChange(newVal);
              })
            ],),

            Text(loremIpsum.substring(0,90))
          ],
        ),
        showButton: true,
        onTap: () {
          if(dateTime==null){
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Please select drop off date'),
              behavior: SnackBarBehavior.floating,
            ));
            return;
          }

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScaffoldingOrderConfirmation(
                  time: selectedInterval,
                order: widget.order,
                subService: 'Single Scaffolding',
                location: dropOffLocation,
                date: dateTime,

              )));
          },
        btnName: tr("Continue"),
      ),
    );
  }

  Widget _buildRow({String dropoffdate, String dropofftime}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                dropoffdate,
                style: boldText,
              ),
            )),
        SizedBox(
          width: 20,
        ),
        Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                dropofftime,
                style: boldText,
              ),
            )),
      ],
    );
  }

}
