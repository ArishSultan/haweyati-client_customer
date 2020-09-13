import 'package:flutter/cupertino.dart';
import 'package:haweyati/models/hive-models/orders/order_model.dart';
import 'package:haweyati/src/common/simple-form.dart';
import 'package:haweyati/src/models/order/order-location_model.dart';
import 'package:haweyati/src/ui/pages/locations-map_page.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/drop-off-picker.dart';
import 'package:haweyati/src/ui/widgets/image-picker-widget.dart';
import 'package:haweyati/src/ui/widgets/location-picker-widget.dart';
import 'package:haweyati/src/ui/widgets/raised-action-button.dart';
import 'package:haweyati/src/utils/app-data.dart';
import 'package:haweyati/src/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/src/utils/location-adapter.dart';

import 'order-confirmation_page.dart';

class DumpsterTimeAndLocationPage extends StatelessWidget {
  final Order _order;
  final _formKey = GlobalKey<SimpleFormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DumpsterTimeAndLocationPage(this._order) {
    final _appData = AppData.instance();

    if (_order.location == null) {
      _order.location = RentableOrderLocation()
        ..city = _appData.city
        ..address = _appData.address
        ..latitude = _appData.coordinates.latitude
        ..longitude = _appData.coordinates.longitude;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableView(
      key: _scaffoldKey,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
      showBackground: true,
      appBar: HaweyatiAppBar(progress: .5),
      children: [
        HeaderView(
          title: 'Time & Location',
          subtitle: loremIpsum.substring(0, 80),
        ),

        LocationPickerWidget(
          initialValue: LocationAdapter()
            .orderLocationToLocationDetails(_order.location),
          onChanged: (LocationDetails location) {
            _order.location = RentableOrderLocation.from(
              LocationAdapter().locationDetailsToOrderLocation(location)
                ..dropOffTime = _order.location.dropOffTime
                ..dropOffDate = _order.location.dropOffDate
            );
          }
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 20, bottom: 40
          ),
          child: DropOffPicker(
            initialDate: _order?.location?.dropOffDate,
            initialTime: _order?.location?.dropOffTime,
            onDateChanged: (date) => _order.location.dropOffDate = date,
            onTimeChanged: (time) => _order.location.dropOffTime = time
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: ImagePickerWidget(),
        ),

        SimpleForm(
          key: _formKey,
          onSubmit: () {},
          child: TextFormField(
            style: TextStyle(
              fontFamily: 'Lato'
            ),
            decoration: InputDecoration(
              labelText: 'Note',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: 'Write note here..'
            ),
            maxLines: 4,
            maxLength: 80,

            onSaved: (text) => _order.note = text,
          )
        )
      ],

      bottom: RaisedActionButton(
        label: 'Continue',
        onPressed: () async {
          await _formKey.currentState.submit();
          if (_order.location?.address?.isEmpty ?? true) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Address not specified'),
              behavior: SnackBarBehavior.floating,
            ));
          } else if (_order.location?.dropOffTime == null) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Drop-off Time Not Selected'),
              behavior: SnackBarBehavior.floating,
            ));
          } else {
            print('here');
            navigateTo(context, DumpsterOrderConfirmationPage(_order));
          }
        }
      )
    );
    // return Scaffold(
    //   key: scaffoldKey,
    //   appBar: HaweyatiAppBar(
    //     context: context,
    //   ),
    //   body: HaweyatiAppBody(
    //     title: "Time & Location",
    //     detail: loremIpsum.substring(0, 40),
    //     child: ListView(
    //       padding: EdgeInsets.fromLTRB(20, 10, 20, 100),
    //       children: <Widget>[
    //
    //         EmptyContainer(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: <Widget>[
    //                   Text(
    //                     "Drop off Location",
    //                     style: boldText,
    //                   ),
    //                   FlatButton.icon(
    //                       onPressed: () async {
    //                         OrderLocation location = await  Navigator.of(context).push(MaterialPageRoute(
    //                             builder: (context) => MyLocationMapPage(
    //                               timeAndLocation: true,
    //                             )));
    //                         setState(() {
    //                           dropOffLocation = location;
    //                         });
    //                       },
    //                       icon: Icon(
    //                         Icons.edit,
    //                         color: Theme.of(context).accentColor,
    //                       ),
    //                       label: Text(
    //                         "Edit",
    //                         style:
    //                             TextStyle(color: Theme.of(context).accentColor),
    //                       ))
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 15,
    //               ),
    //               Row(
    //                 children: <Widget>[
    //                   Icon(
    //                     Icons.location_on,
    //                     color: Theme.of(context).accentColor,
    //                   ),
    //                   Expanded(
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(left: 10),
    //                       child: Text(dropOffLocation?.address ?? ''),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //         SizedBox(
    //           height: 20,
    //         ),
    //         _buildRow(
    //             dropoffdate: "Drop-off Date", dropofftime: "Drop-off Time"),
    //         Row(
    //           children: <Widget>[
    //
    //             Expanded(
    //               child: DatePickerField(
    //                 onChanged: (date) async {
    //                   dateTime = date;
    //                   print(date?.day);
    //                   if(date!=null){
    //                     timeSlots = TimeSlotsService().getAvailableTimeSlots(0,date.day == DateTime.now().day);
    //                     await timeSlots;
    //                     setState(() {
    //                     });
    //                   }
    //                 } ,
    //               ),
    //             ),
    //             SizedBox(
    //               width: 15,
    //             ),
    //
    //             Expanded(
    //               child: Container(
    //                   padding: EdgeInsets.symmetric(vertical: 10),
    //                   decoration: BoxDecoration(color:Color(0xfff2f2f2f2),
    //                       borderRadius: BorderRadius.circular(15)),
    //                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
    //                     SimpleFutureBuilder.simpler(
    //                       context : context,
    //                       future: timeSlots,
    //                       builder: (AsyncSnapshot<List<String>> timeSlots){
    //                         return DropdownButton<String>(
    //                           underline: SizedBox(),
    //                           value: selectedInterval,
    //                           items: timeSlots.data.map((String value) {
    //                             return DropdownMenuItem<String>(
    //                               value: value,
    //                               child: Padding(
    //                                 padding: const EdgeInsets.only(left:14.0),
    //                                 child: Text('$value', textAlign: TextAlign.center),
    //                               ),
    //                             );
    //                           }).toList(),
    //                           onChanged: (_) {
    //                             setState(() {
    //                             selectedInterval = _;
    //                           });
    //                           },
    //                         );
    //                     },
    //                     ),
    //                   ],)
    //               ),
    //             )
    //           ],
    //         ),
    //
    //
    //
    //         Text("Take a photo for contact less delivery and make sure to pay online.",style: boldText,)
    //        ,
    //         SizedBox(height: 15,),Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             GestureDetector(
    //                 onTap: () {
    //                   getCamera();
    //                 },
    //                 child: Container(
    //                   padding: EdgeInsets.all(15),
    //                   decoration: BoxDecoration(color: Theme.of(context).accentColor,
    //                       borderRadius: BorderRadius.circular(30),
    //                       border: Border.all(
    //                           width: 2, color: Theme.of(context).accentColor)),
    //                   child: Text(
    //                     "Camera",
    //                     style: TextStyle(color: Colors.white),
    //                   ),
    //                 )),
    //             GestureDetector(
    //                 onTap: () {
    //                   getGallery();
    //                 },
    //                 child: Container(
    //                   padding: EdgeInsets.all(15),
    //                   decoration: BoxDecoration(color: Theme.of(context).accentColor,
    //                       borderRadius: BorderRadius.circular(30),
    //                       border: Border.all(
    //                           width: 2, color: Theme.of(context).accentColor)),
    //                   child: Text(
    //                     "Gallery",
    //                     style: TextStyle(color: Colors.white),
    //                   ),
    //                 )),
    //           ],
    //         ),
    //         SizedBox(
    //           height: 20,
    //         ),
    //         Container(
    //           height: 200.0,
    //           width: 150,
    //           child: _image == null
    //               ? Container(
    //                   decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(30),
    //                       border: Border.all(
    //                           width: 2, color: Theme.of(context).accentColor)),
    //                   child: Center(child: Text('No image selected.')))
    //               : ClipRRect(
    //                   borderRadius: BorderRadius.circular(30),
    //                   child: Image.file(
    //                     _image,
    //                     fit: BoxFit.cover,
    //                   )),
    //         ),
    //         SizedBox(
    //           height: 25,
    //         ),            TextFormField(
    //           controller: note,
    //           scrollPadding: EdgeInsets.only(bottom: 150),
    //           maxLength: 80,
    //           maxLines: 2,
    //           decoration: InputDecoration(
    //               labelText: "Note",
    //               hintText: "Write note here",
    //               border: OutlineInputBorder(borderSide: BorderSide(color:Theme.of(context).accentColor),
    //                   borderRadius: BorderRadius.circular(10))),
    //         ),
    //       ],
    //     ),
    //     showButton: true,
    //     onTap: () async {
    //       if(selectedInterval==null){
    //         scaffoldKey.currentState.showSnackBar(SnackBar(
    //           content: Text('Please select drop off time'),
    //           behavior: SnackBarBehavior.floating,
    //         ));
    //         return;
    //       }
    //       await addOrder(Order(
    //         image: _image?.path,
    //         city: dropOffLocation.city,
    //         service: 'Construction Dumpster',
    //         dropOffDate: dateTime.toIso8601String(),
    //         dropOffTime: selectedInterval,
    //         address: dropOffLocation.address,
    //         latitude: dropOffLocation.cords.latitude.toString(),
    //         longitude: dropOffLocation.cords.longitude.toString(),
    //         note: note.text,
    //       ));
    //
    //       CustomNavigator.navigateTo(context, DumpsterOrderConfirmation(item: widget.dumpster,));
    //
    //     },
    //     btnName:tr("Continue")
    //   ),
    // );
  }
}
