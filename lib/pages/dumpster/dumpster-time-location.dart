import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haweyati/models/dumpster_model.dart';
import 'package:haweyati/models/hive-models/orders/dumpster-order_model.dart';
import 'package:haweyati/models/hive-models/orders/order-details_model.dart';
import 'package:haweyati/models/hive-models/orders/order_model.dart';
import 'package:haweyati/models/hive-models/orders/transaction_model.dart';
import 'package:haweyati/models/hive-models/time-slots.dart';
import 'package:haweyati/models/order-time_and_location.dart';
import 'package:haweyati/pages/dumpster/calender/custom-datepicker.dart';
import 'package:haweyati/pages/payment/payment-method.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/services/time-slots_service.dart';
import 'package:haweyati/src/utlis/simple-future-builder.dart';
import 'package:haweyati/widgits/custom-navigator.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/emptyContainer.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../locations-map_page.dart';
import 'dumpster-order-confirmation.dart';

class DumpsterTimeAndLocation extends StatefulWidget {
  final Dumpster dumpster;
  DumpsterTimeAndLocation({this.dumpster});
  @override
  _DumpsterTimeAndLocationState createState() => _DumpsterTimeAndLocationState();
}

class _DumpsterTimeAndLocationState extends State<DumpsterTimeAndLocation> {
  Future<List<String>> timeSlots;
  SharedPreferences prefs;
  String selectedInterval;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;
  DateTime dateTime = DateTime.now();
  OrderLocation dropOffLocation;
  String start = "...";
  var key= GlobalKey<RefreshIndicatorState>();
  TextEditingController note = TextEditingController();



  Future getCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future getGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }


  @override
  void initState() {
    super.initState();
    initTimeAndLocation();
  }

  Future<List<String>> fetchTimeSlots([bool flag=true]) async {
    timeSlots = TimeSlotsService().getAvailableTimeSlots(0,flag);
    timeSlots.then((value) {
      selectedInterval = value[0];
    });
    return timeSlots;
  }

  void initTimeAndLocation() async {
    fetchTimeSlots();
    prefs = await SharedPreferences.getInstance();
    setState(() {
      dropOffLocation = OrderLocation(
          cords: LatLng(prefs.getDouble('latitude'),prefs.getDouble('latitude')),
          address: prefs.getString('address'),
          city: prefs.getString('city')
      );
    });
  }

  void addOrder(Order order) async {
    final box = await Hive.openBox('orders');
    await box.clear();
    box.add(order);
    order.save();
    print(order.city + "v");
  }

  void addTransaction(Transaction transaction) async {
    final box = await Hive.openBox('transactions');
    await box.clear();
    box.add(transaction);
    transaction.save();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: HaweyatiAppBar(
        context: context,
      ),
      body: HaweyatiAppBody(
        title: "Time & Location",
        detail: loremIpsum.substring(0, 40),
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 100),
          children: <Widget>[

            EmptyContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Drop off Location",
                        style: boldText,
                      ),
                      FlatButton.icon(
                          onPressed: () async {
                            OrderLocation location = await  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyLocationMapPage(
                                  timeAndLocation: true,
                                )));
                            setState(() {
                              dropOffLocation = location;
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).accentColor,
                          ),
                          label: Text(
                            "Edit",
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).accentColor,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(dropOffLocation?.address ?? ''),
                        ),
                      )
                    ],
                  ),
                ],
              ),
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
                        timeSlots = TimeSlotsService().getAvailableTimeSlots(0,date.day == DateTime.now().day);
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

            
            
            Text("Take a photo for contact less delivery and make sure to pay online.",style: boldText,)
           ,
            SizedBox(height: 15,),Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      getCamera();
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              width: 2, color: Theme.of(context).accentColor)),
                      child: Text(
                        "Camera",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                GestureDetector(
                    onTap: () {
                      getGallery();
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              width: 2, color: Theme.of(context).accentColor)),
                      child: Text(
                        "Gallery",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 200.0,
              width: 150,
              child: _image == null
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              width: 2, color: Theme.of(context).accentColor)),
                      child: Center(child: Text('No image selected.')))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.file(
                        _image,
                        fit: BoxFit.cover,
                      )),
            ),
            SizedBox(
              height: 25,
            ),            TextFormField(
              controller: note,
              scrollPadding: EdgeInsets.only(bottom: 150),
              maxLength: 80,
              maxLines: 2,
              decoration: InputDecoration(
                  labelText: "Note",
                  hintText: "Write note here",
                  border: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).accentColor),
                      borderRadius: BorderRadius.circular(10))),
            ),
          ],
        ),
        showButton: true,
        onTap: () async {
          if(selectedInterval==null){
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Please select drop off time'),
              behavior: SnackBarBehavior.floating,
            ));
            return;
          }
          await addOrder(Order(
            image: _image?.path,
            city: dropOffLocation.city,
            service: 'Construction Dumpster',
            dropOffDate: dateTime.toIso8601String(),
            dropOffTime: selectedInterval,
            address: dropOffLocation.address,
            latitude: dropOffLocation.cords.latitude.toString(),
            longitude: dropOffLocation.cords.longitude.toString(),
            note: note.text,
          ));

          CustomNavigator.navigateTo(context, DumpsterOrderConfirmation(item: widget.dumpster,));

        },
        btnName:tr("Continue")
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
