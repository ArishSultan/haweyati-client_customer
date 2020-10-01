import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haweyati/src/models/location_model.dart';
import 'package:haweyati/src/ui/pages/location/locations-map_page.dart';
import 'package:haweyati/src/ui/widgets/buttons/edit-button.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

import 'dark-container.dart';

class LocationPicker extends StatefulWidget {
  final Location initialValue;
  final Function(Location location) onChanged;

  LocationPicker({
    this.initialValue,
    @required this.onChanged
  });

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  var _address;

  @override
  void initState() {
    super.initState();

    _address = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DarkContainer(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 15),
      child: Wrap(children: [
        Row(children: [
          Text('Drop Off Location', style: TextStyle(
            color: Color(0xFF313F53),
            fontWeight: FontWeight.bold
          )),
          Spacer(),
          EditButton(onPressed: () async {
            final location = await navigateTo(context, LocationPickerMapPage(
              LatLng(widget.initialValue.latitude, widget.initialValue.longitude)
            ));
            if (location != null) {
              _address = location;
              widget.onChanged(_address);

              setState(() {});
            }
          })
        ]),
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Image.asset(LocationIcon, height: 18),
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(_address.address, style: TextStyle(
                height: 1.2,
                color: Color(0xFF313F53),
              )),
            ))
          ], crossAxisAlignment: CrossAxisAlignment.start),
        )
      ]),
    );
  }
}
