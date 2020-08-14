import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haweyati/models/order-time_and_location.dart';
import 'package:haweyati/pages/locations-map_page.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'emptyContainer.dart';

class OrderLocationPicker extends StatefulWidget {
  final OrderLocation previousLocation;
  final Function(OrderLocation) onLocationChanged;
  OrderLocationPicker({this.onLocationChanged,this.previousLocation});

  @override
  _OrderLocationPickerState createState() => _OrderLocationPickerState();
}

class _OrderLocationPickerState extends State<OrderLocationPicker> {

  SharedPreferences prefs;
  OrderLocation dropOffLocation;

  @override
  void initState() {
    super.initState();
    if(widget.previousLocation!=null){
      dropOffLocation = widget.previousLocation;
    }else {
      initTimeAndLocation();
    }
  }

  void initTimeAndLocation() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      dropOffLocation = OrderLocation(
          cords: LatLng(prefs.getDouble('latitude'),prefs.getDouble('latitude')),
          address: prefs.getString('address'),
          city: prefs.getString('city')
      );
      widget.onLocationChanged(dropOffLocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EmptyContainer(
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
                    print(location);
                    widget.onLocationChanged(location);
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
    );
  }
}
