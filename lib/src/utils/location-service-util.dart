import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<bool> _isGPSEnabled() async =>
  Geolocator().isLocationServiceEnabled();

Future<bool> _isLocationAllowed() async =>
    (await Geolocator().checkGeolocationPermissionStatus()) == GeolocationStatus.granted;

Future<bool> _checkLocationServiceStatus() async {
  if (! (await _isGPSEnabled())) throw GPSError();
  if (! (await _isLocationAllowed())) throw LocationPermissionError();

  return true;
}

Future<bool> checkLocationService(BuildContext context, {
  AlertDialog gpsErrorDialog,
  AlertDialog locationPermissionErrorDialog
}) async {
  try {
    await _checkLocationServiceStatus();
    return true;
  } on GPSError catch (_) {
    print('herer');

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
