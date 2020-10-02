import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;

Future<bool> _isGPSEnabled() async =>
    geolocator.isLocationServiceEnabled();

Future<bool> _isLocationAllowed() async =>
    (await geolocator.checkPermission()) == geolocator.LocationPermission.always;

Future<bool> _checkLocationServiceStatus() async {
  if (! (await _isGPSEnabled())) throw GPSError();
  if (! (await _isLocationAllowed())) throw LocationPermissionError();

  return true;
}

Future<bool> checkLocationService(BuildContext context, {
  AlertDialog gpsErrorDialog,
  Widget locationPermissionErrorDialog
}) async {
  try {
    await _checkLocationServiceStatus();
    return true;
  } on GPSError catch (_) {

    await showDialog(
      context: context,
      builder: (context) => gpsErrorDialog
    );

    return false;
  } on LocationPermissionError catch (_) {
    await showDialog(
      context: context,
      builder: (context) => locationPermissionErrorDialog
    );

    return false;
  } on Error catch (e) {
    print(e);
  }

  return false;
}

class GPSError implements Exception {}
class LocationPermissionError implements Exception {}
