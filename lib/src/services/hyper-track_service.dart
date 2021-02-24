import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haweyati_client_data_models/const.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:hypertrack_plugin/hypertrack.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class HyperTrackService {

  static String deviceName = AppData().user.name;
  static HyperTrack sdk;
  static bool isInitialised = false;

 static Future<void> initializeSdk() async {
    HyperTrack.enableDebugLogging();
    // Initializer is just a helper class to get the actual sdk instance
    try {
      sdk = await HyperTrack.initialize(hyperKey);
      isInitialised = true;
      sdk.setDeviceName(deviceName);
      sdk.setDeviceMetadata({"customer": AppData().user.id});
      sdk.onTrackingStateChanged.listen((TrackingStateChange event) {

      });
    } catch (e) {
      print(e);
    }

    final dev = (sdk == null) ? "unknown" : await sdk.getDeviceId();
    SharedPreferences.getInstance().then((value) => value.setString('deviceId', dev));

  }
}

