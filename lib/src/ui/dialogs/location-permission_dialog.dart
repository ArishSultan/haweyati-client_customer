import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';

class LocationPermissionErrorDialog extends AlertDialog {
  LocationPermissionErrorDialog(): super(
    title: Text('Location is Turned Off'),
    actions: [
      FlatButton(
        child: Text('YES'),
        shape: StadiumBorder(),

        onPressed: () async {
          await LocationPermissions().requestPermissions();
          // final admin = await Geolocator().checkGeolocationPermissionStatus();
          // print(admin);
        }
      ),

      FlatButton(
        child: Text('NO'),
        shape: StadiumBorder(),

        onPressed: () {}
      ),
    ]
  );
}