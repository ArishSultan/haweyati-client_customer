import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/data.dart';
import 'package:location/location.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haweyati/src/models/location_model.dart' as model;
import 'package:haweyati/src/ui/pages/location/locations-map_page.dart';
import 'package:haweyati/src/ui/modals/dialogs/errors/location-permission_error-dialog.dart';

Future<model.Location> _handleGranted({
  Location location,
  BuildContext context,
  model.Location prevLocation
}) async {
  model.Location result;

  /// Check if the gps is on.
  var status = await location.serviceEnabled();
  if (!status) {
    status = await location.requestService();
    if (!status) return null;
  }

  if (prevLocation != null) {
    result = await navigateTo(context, LocationPickerMapPage(LatLng(
      prevLocation.latitude,
      prevLocation.longitude
    )));
  } else {
    result = await navigateTo(context, LocationPickerMapPage());
  }

  return result;
}

Future<model.Location> _handleDenied({
  Location location,
  BuildContext context,
  PermissionStatus status,
  model.Location prevLocation
}) async {
  model.Location _location;

  await showDialog(
    context: context,
    builder: (context) => LocationPermissionErrorDialog(onPressed: () async {
      status = await location.requestPermission();
      if (status == PermissionStatus.deniedForever) {
        /// Close Dialog.
        Navigator.of(context).pop();

        /// Open App Settings to grant permission.
        await AppSettings.openLocationSettings();
      } else if (status == PermissionStatus.granted) {
        Navigator.of(context).pop();

        _location = await _handleGranted(
          context: context,
          location: location,
          prevLocation: prevLocation,
        );
      }
    })
  );

  return _location;
}

Future<model.Location> processLocationPicking(BuildContext context, {
  model.Location prevLocation,
}) async {
  final _location = Location();

  var _permission = await _location.hasPermission();
  switch (_permission) {
    case PermissionStatus.granted:
      return _handleGranted(
        context: context,
        location: _location,
        prevLocation: prevLocation,
      );
    case PermissionStatus.denied:
    case PermissionStatus.deniedForever:
      print('here');
      print(_permission);
      return _handleDenied(
        context: context,
        status: _permission,
        location: _location,
        prevLocation: prevLocation,
      );
  }

  return null;
}

Future<bool> processUserLocationPicking(BuildContext context, {
  Function onLocationPicked,
  model.Location prevLocation,
}) async {
  final _pickedLocation = await processLocationPicking(context,
    prevLocation: prevLocation
  );

  if (_pickedLocation != null) {
    AppData.instance().location = _pickedLocation;
    onLocationPicked();
    return true;
  }

  return false;
}
