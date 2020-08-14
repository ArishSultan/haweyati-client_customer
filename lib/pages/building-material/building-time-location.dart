import 'package:easy_localization/easy_localization.dart';
import 'package:haweyati/models/building-material_sublist.dart';
import 'package:haweyati/models/hive-models/orders/building-material-order.dart';
import 'package:haweyati/models/hive-models/orders/order-details_model.dart';
import 'package:haweyati/models/hive-models/orders/order_model.dart';
import 'package:haweyati/models/order-time_and_location.dart';
import 'package:haweyati/pages/building-material/building-order-confirmation.dart';
import 'package:haweyati/pages/dumpster/calender/custom-datepicker.dart';
import 'package:haweyati/services/time-slots_service.dart';
import 'package:haweyati/src/utlis/simple-future-builder.dart';
import 'package:haweyati/widgits/order-location-picker.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';

class BuildingTimeAndLocation extends StatefulWidget {
  final BMProduct bmItem;
  BuildingTimeAndLocation({this.bmItem});
  @override
  _BuildingTimeAndLocationState createState() => _BuildingTimeAndLocationState();
}

class _BuildingTimeAndLocationState extends State<BuildingTimeAndLocation> {
  Future<List<String>> timeSlots;
  OrderLocation dropOffLocation;
  DateTime dateTime = DateTime.now();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String start = "...";
  bool val =false;

  void addOrder(Order order) async {
    final box = await Hive.openBox('orders');
    await box.clear();
    box.add(order);
    order.save();
  }

  onSwtich(bool newVal){
    setState(() {
      val =newVal;
    });
  }

  String selectedInterval;

  @override
  void initState() {
    super.initState();
    fetchTimeSlots();
  }

  Future<List<String>> fetchTimeSlots([bool flag=true]) async {
    timeSlots = TimeSlotsService().getAvailableTimeSlots(1,flag);
    timeSlots.then((value) {
      selectedInterval = value[0];
    });
    return timeSlots;
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
          children: <Widget>[
            OrderLocationPicker(
              onLocationChanged: (OrderLocation location) {
                dropOffLocation = location;
              },
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
                    onChanged: (date) async {
                      dateTime = date;
                      print(date?.day);
                      if(date!=null){
                        timeSlots = TimeSlotsService().getAvailableTimeSlots(1,date.day == DateTime.now().day);
                        await timeSlots;
                        setState(() {
                        });
                      }
                    } ,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
//                OrderTimePicker(
//                  onIntervalChange: (String timeInterval){
//                    selectedInterval = timeInterval;
//                  },
//                ),
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

          ],
        ),
        showButton: true,
        onTap: () async {
          if(dateTime==null){
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Please select drop off date'),
              behavior: SnackBarBehavior.floating,
            ));
            return;
          }
          var box = await Hive.box('bmorder');
          print(box.values);
          List<BMOrder> bmOrders = box.values.toList().cast<BMOrder>();

          double netTotal = 0;

          bmOrders.forEach((element) {
            netTotal += element.total;
          });

          print(netTotal);

          await addOrder(Order(
            city: dropOffLocation.city,
            dropOffTime: selectedInterval,
            order: OrderDetails(
              items: bmOrders,
              netTotal: netTotal
            ),
            address: dropOffLocation.address,
            latitude: dropOffLocation.cords.latitude.toString(),
            longitude: dropOffLocation.cords.longitude.toString(),
            service: 'Building Material',
            dropOffDate: dateTime.toIso8601String(),
          ));


          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BuildingOrderConfirmation(
                item: widget.bmItem,
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
