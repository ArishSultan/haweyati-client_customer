import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoder/geocoder.dart';
import 'package:haweyati/src/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_webservice/places.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/views/localized_view.dart';
import 'package:haweyati_client_data_models/data.dart' as l;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/widgets/localization-selector.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';

const apiKey = 'AIzaSyDdNpY6LGWgHqRfTRZsKkVhocYOaER325w';

/// These are the coordinates of Saudi Arabia
const mapBounds = const [
  const LatLng(28.15730, 34.63000),
  const LatLng(29.36180, 34.95420),
  const LatLng(29.18890, 36.06910),
  const LatLng(29.50000, 36.50440),
  const LatLng(29.86850, 36.75350),
  const LatLng(30.01000, 37.49990),
  const LatLng(30.33260, 37.66550),
  const LatLng(30.50070, 37.99690),
  const LatLng(31.50004, 37.00030),
  const LatLng(31.99830, 38.99570),
  const LatLng(32.15630, 39.19760),
  const LatLng(31.94810, 40.41340),
  const LatLng(31.37320, 41.44090),
  const LatLng(31.11170, 42.08560),
  const LatLng(29.19850, 44.72190),
  const LatLng(29.06120, 46.42600),
  const LatLng(29.10110, 46.55300),
  const LatLng(29.00050, 47.46620),
  const LatLng(28.56120, 47.75130),
  const LatLng(28.57840, 48.56990),
  const LatLng(27.57450, 48.80290),
  const LatLng(27.23320, 49.23130),
  const LatLng(26.84180, 49.81000),
  const LatLng(26.44000, 50.17000),
  const LatLng(25.88000, 50.05000),
  const LatLng(25.62900, 50.18210),
  const LatLng(25.38800, 50.46300),
  const LatLng(24.78680, 50.71800),
  const LatLng(24.44700, 51.08000),
  const LatLng(24.50000, 51.31700),
  const LatLng(24.58100, 51.39900),
  const LatLng(24.39430, 51.27900),
  const LatLng(24.27050, 51.26600),
  const LatLng(24.31200, 51.42300),
  const LatLng(24.24800, 51.52000),
  const LatLng(24.27800, 51.74000),
  const LatLng(24.24820, 51.58140),
  const LatLng(24.15400, 51.58600),
  const LatLng(24.10600, 51.59200),
  const LatLng(22.93400, 52.57700),
  const LatLng(22.62900, 55.13100),
  const LatLng(22.70000, 55.20400),
  const LatLng(22.00200, 55.64900),
  const LatLng(19.99990, 55.00000),
  const LatLng(19.02000, 51.97000),
  const LatLng(18.82000, 50.77000),
  const LatLng(18.66000, 49.11000),
  const LatLng(18.21000, 48.17200),
  const LatLng(17.48000, 47.56000),
  const LatLng(17.14000, 47.45000),
  const LatLng(16.97000, 47.17000),
  const LatLng(16.97000, 47.00800),
  const LatLng(17.31000, 46.76000),
  const LatLng(17.25700, 46.36000),
  const LatLng(17.35200, 45.40900),
  const LatLng(17.45700, 45.22000),
  const LatLng(17.38100, 43.68400),
  const LatLng(17.56420, 43.33790),
  const LatLng(15.86480, 43.10200),
  const LatLng(21.24660, 38.98830),
  const LatLng(28.15730, 34.63000)
];

class LocationPickerMapPage extends StatefulWidget {
  final LatLng coordinates;

  LocationPickerMapPage([this.coordinates]);

  @override
  _LocationPickerMapPageState createState() => _LocationPickerMapPageState();
}

class _LocationPickerMapPageState extends State<LocationPickerMapPage> {
  Address _address;
  LatLng _location;
  bool _initiated = false;
  GoogleMapController _controller;

  final _utils = _MapUtilsImpl();
  final _markers = Set<Marker>();

  @override
  void initState() {
    super.initState();

    _location = widget.coordinates ?? l.AppData().coordinates;
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (context, lang) => NoScrollView(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(child: LocalizationSelector()),
            )
          ],
          title: Image.asset(AppLogo, width: 40, height: 40),
          centerTitle: true,
          leading: IconButton(
            icon: Transform.rotate(
              angle: Localizations.localeOf(context).toString() == 'ar'
                  ? 3.14159
                  : 0,
              child: Image.asset(
                ArrowBackIcon,
                width: 26,
                height: 26,
              ),
            ),
            onPressed: Navigator.of(context).pop,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset(LocationIcon, width: 15),
                    ),
                    Expanded(
                      child: CupertinoTextField(
                        onTap: () async {
                          final prediction = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: apiKey,
                              components: [Component(Component.country, "sau")]
                          );

                          if (prediction != null) {
                            final detail =
                                await GoogleMapsPlaces(apiKey: apiKey)
                                    .getDetailsByPlaceId(prediction.placeId);

                            _setLocationOnMap(LatLng(
                              detail.result.geometry.location.lat,
                              detail.result.geometry.location.lng,
                            ));
                          }
                        },
                        readOnly: true,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        style: TextStyle(color: Colors.grey.shade700),
                        controller: TextEditingController(
                            text: _address?.addressLine ?? 'Tap To Search'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: _resolveMap(),
        bottom: RaisedActionButton(
          label: lang.setYourLocation,
          onPressed: (_location != null && _initiated)
              ? () {
                  Navigator.of(context).pop(l.Location(
                    city: _address.locality,
                    address: _address.addressLine,
                    latitude: _location.latitude,
                    longitude: _location.longitude,
                  ));
                }
              : null,
        ),
      ),
    );
  }

  final _bounds = Set<Polygon>()
    ..add(Polygon(
      polygonId: PolygonId('0'),
      points: mapBounds,
      fillColor: Colors.transparent,
      strokeWidth: 2,
      strokeColor: Colors.red,
    ));

  _resolveMap() {
    if (_initiated) {
      return Stack(children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _location, zoom: 15),
          onTap: _setLocationOnMap,
          polygons: _bounds,
          onMapCreated: (controller) {
            _controller = controller;
          },
          zoomGesturesEnabled: false,
          compassEnabled: true,
          markers: _markers,
        ),
        Positioned(
          right: 15,
          bottom: 15,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 2,
                blurRadius: 10,
              )
            ]),
            child: FlatButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(0),
              onPressed: () => _setLocationOnMap(null),
              child: Image.asset(MyLocationIcon, width: 24),
            ),
          ),
        )
      ]);
    } else {
      if (_location != null) {
        _setLocationOnMap(_location);
      } else {
        _utils.fetchCurrentLocation().then(_setLocationOnMap);
      }

      return Center(
        child: Row(children: [
          SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(strokeWidth: 1),
          ),
          SizedBox(width: 20),
          Text(AppLocalizations.of(context).fetchingCurrentCoordinates)
        ], mainAxisAlignment: MainAxisAlignment.center),
      );
    }
  }

  _setLocationOnMap(LatLng location) async {
    if (_controller != null) {
      showDialog(
        context: context,
        builder: (context) => WaitingDialog(
          message: AppLocalizations.of(context).fetchingLocationData,
        ),
      );
    }

    if (location == null) {
      _location = await _utils.fetchCurrentLocation();
    } else {
      _location = location;
    }
    _markers
      ..clear()
      ..add(Marker(
        draggable: true,
        position: _location,
        markerId: MarkerId('\0'),
        onDragEnd: _setLocationOnMap,
      ));

    _address = await _utils.fetchAddress(_location);
    if (_controller != null) {
      Navigator.of(context).pop();
      _controller.animateCamera(CameraUpdate.newLatLng(_location));
    }

    if (!_initiated) _initiated = true;
    setState(() {});
  }
}

class _MapUtilsImpl {
  final _location = loc.Location();

  Future<Address> fetchAddress(final LatLng location) async {
    return (await Geocoder.google(apiKey).findAddressesFromCoordinates(
            Coordinates(location.latitude, location.longitude)))
        .first;
  }

  Future<LatLng> fetchCurrentLocation() async {
    final position = await _location.getLocation();
    return LatLng(position.latitude, position.longitude);
  }
}
