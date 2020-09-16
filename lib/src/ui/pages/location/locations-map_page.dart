import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:haweyati/models/order-time_and_location.dart';
import 'package:haweyati/src/models/location_model.dart' as l;
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/localization-selector.dart';
import 'package:haweyati/src/ui/widgets/raised-action-button.dart';
import 'package:haweyati/src/utils/app-data.dart';
import 'package:haweyati/src/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

const apiKey = 'AIzaSyDdNpY6LGWgHqRfTRZsKkVhocYOaER325w';

/// These are the coordinates of Saudi Arabia
const _mapBounds = const [
  const LatLng(28.157300, 34.630000),
  const LatLng(29.313309, 35.070000),
  const LatLng(29.121500, 36.168600),
  const LatLng(30.550000, 38.102000),
  const LatLng(31.454900, 37.223000),
  const LatLng(32.090100, 39.244800),
  const LatLng(29.179100, 44.606000),
  const LatLng(28.980000, 47.280000),
  const LatLng(28.480000, 47.630000),
  const LatLng(28.486100, 48.363400),
  const LatLng(27.574500, 48.802900),
  const LatLng(27.233200, 49.231300),
  const LatLng(26.841800, 49.810000),
  const LatLng(26.440000, 50.170000),
  const LatLng(25.880000, 50.050000),
  const LatLng(25.629000, 50.182100),
  const LatLng(25.388000, 50.463000),
  const LatLng(24.786800, 50.718000),
  const LatLng(24.447000, 51.080000),
  const LatLng(24.500000, 51.317000),
  const LatLng(24.581000, 51.399000),
  const LatLng(24.394300, 51.279000),
  const LatLng(24.270500, 51.266000),
  const LatLng(24.312000, 51.423000),
  const LatLng(24.248000, 51.520000),
  const LatLng(24.278000, 51.740000),
  const LatLng(24.248200, 51.581400),
  const LatLng(24.154000, 51.586000),
  const LatLng(24.106000, 51.592000),
  const LatLng(22.934000, 52.577000),
  const LatLng(22.629000, 55.131000),
  const LatLng(22.700000, 55.204000),
  const LatLng(22.002000, 55.649000),
  const LatLng(22.010000, 54.970000),
  const LatLng(19.020000, 51.970000),
  const LatLng(18.820000, 50.770000),
  const LatLng(18.660000, 49.110000),
  const LatLng(18.210000, 48.172000),
  const LatLng(17.480000, 47.560000),
  const LatLng(17.140000, 47.450000),
  const LatLng(16.970000, 47.170000),
  const LatLng(16.970000, 47.008000),
  const LatLng(17.310000, 46.760000),
  const LatLng(17.257000, 46.360000),
  const LatLng(17.352000, 45.409000),
  const LatLng(17.457000, 45.220000),
  const LatLng(17.381000, 43.684000),
  const LatLng(17.564200, 43.337900),
  const LatLng(16.448000, 42.790000),
  const LatLng(28.157300, 34.630000)
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

    _location = widget.coordinates ?? AppData.instance().coordinates;
  }

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: LocalizationSelector(
                selected: EasyLocalization.of(context).locale,
                onChanged: (locale) {
                  setState(() => EasyLocalization.of(context).locale = locale);
                },
              ),
            ),
          )
        ],
        title: Image.asset(AppLogo, width: 40, height: 40),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(ArrowBackIcon, width: 26, height: 26),
          onPressed: Navigator.of(context).pop
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(
              horizontal: 15, vertical: 8
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
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
                          context: context, apiKey: apiKey,
                        );

                        if (prediction != null) {
                          final detail = await GoogleMapsPlaces(apiKey: apiKey)
                            .getDetailsByPlaceId(prediction.placeId);

                          _setLocationOnMap(LatLng(
                            detail.result.geometry.location.lat,
                            detail.result.geometry.location.lng
                          ));
                        }
                      },
                      readOnly: true,
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)
                      ),
                      style: TextStyle(color: Colors.grey.shade700),
                      controller: TextEditingController(text: _address?.addressLine ?? 'Tap To Search'),
                    ),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Image.asset(MyLocationIcon, width: 24),
                    ),
                    onTap: () async => _setLocationOnMap(null)
                  ),
                ],
              ),
            )
          )
        )
      ),
      body: _resolveMap(),
      bottom: RaisedActionButton(
        label: tr('Set_Your_Location'),
        onPressed: _location != null ? () {
          Navigator.of(context).pop(l.Location(
            city: _address.locality,
            address: _address.addressLine,
            latitude: _location.latitude,
            longitude: _location.longitude
          ));
        } : null,

        // elevation: 10,
        // child: Padding(
        //   padding: const EdgeInsets.all(15),
        //   child: SizedBox(
        //     height: 45,
        //     child: FlatButton.icon(
        //       shape: StadiumBorder(),
        //       textColor: Colors.white,
        //       color: Theme.of(context).accentColor,
        //       label: Text(),

//              onPressed: currentLocation != null ? () async {
//                print(city);
//                if(widget.timeAndLocation){
//                  OrderLocation location = OrderLocation(
//                      cords: currentLocation,
//                      address: userAddress,
//                      city: city
//                  );
//
//                  Navigator.of(context).pop(location);
//                  return;
//                }
//                showDialog(
//                    context: context,
//                    builder: (context) {
//                      return AlertDialog(
//                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                        content: Row(children: <Widget>[
//                          SizedBox(
//                              width: 20,
//                              height: 20,
//                              child: CircularProgressIndicator(strokeWidth: 2)
//                          ),
//                          SizedBox(width: 20),
//                          Text('Saving your coordinates ...')
//                        ]),
//                      );
//                    }
//                );
//
//                print(prefs);
//                prefs.setDouble("latitude", currentLocation.latitude);
//                prefs.setDouble("longitude", currentLocation.longitude);
//                prefs.setString("address", userAddress);
//                prefs.setString('city', city);
//                print(city);



//                HaweyatiData.isSignedIn ? Navigator.of(context).pushNamedAndRemoveUntil('sign-in', (route) => false) :
//
//                Navigator.of(context)
//                    .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
//              } :  null,
//             )
//           )
//         )
      )
    );
  }

  final _bounds = Set<Polygon>()..add(Polygon(
    polygonId: PolygonId('0'),
    points: _mapBounds,
    fillColor: Colors.transparent,
    strokeWidth: 2,
    strokeColor: Colors.red
  ));

  _resolveMap() {
    if (_initiated) {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _location, zoom: 15
        ),
        onTap: _setLocationOnMap,
        polygons: _bounds,
        onMapCreated: (controller) {
          _controller = controller;
        },
        zoomControlsEnabled: false,
        compassEnabled: true,
        markers: _markers,
      );
    } else {
      if (_location != null) {
        _setLocationOnMap(_location);
      } else {
        _utils.fetchCurrentLocation().then(_setLocationOnMap);
      }

      return Center(child: Row(children: [
        SizedBox(
          width: 25, height: 25,
          child: CircularProgressIndicator(strokeWidth: 1)
        ),
        SizedBox(width: 20),
        Text('Fetching Current Coordinates')
      ], mainAxisAlignment: MainAxisAlignment.center));
    }
  }

  _setLocationOnMap(LatLng location) async {
    if (_controller != null) {
      showDialog(context: context, builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(children: <Widget>[
          SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(strokeWidth: 2)
          ),
          SizedBox(width: 20),
          Text('Fetching Location Data ...')
        ]),
      ));
    }

    if (location == null) {
      _location = await _utils.fetchCurrentLocation();
    } else {
      _location = location;
    }
    _markers..clear()..add(Marker(
      draggable: true,
      position: _location,
      markerId: MarkerId('\0'),
      onDragEnd: _setLocationOnMap
    ));

    _address = await _utils.fetchAddress(_location);
    if (_controller != null) {
      await Navigator.of(context).pop();
      _controller.animateCamera(CameraUpdate.newLatLng(_location));
    }

    if (!_initiated) _initiated = true;
    setState(() {});
  }
}

class _MapUtilsImpl {
  Future<Address> fetchAddress(final LatLng location) async {
    return (await Geocoder.google(apiKey)
        .findAddressesFromCoordinates(Coordinates(location.latitude, location.longitude)))
        .first;
  }

  Future<LatLng> fetchCurrentLocation() async {
    final position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    return LatLng(position.latitude, position.longitude);
  }
}

class MyLocationMapPage extends StatefulWidget {
  final bool timeAndLocation;
  final bool editMode;
  MyLocationMapPage({this.editMode=false,this.timeAndLocation=false});
  @override
  State<MyLocationMapPage> createState() => MyLocationMapPageState();
}

class MyLocationMapPageState extends State<MyLocationMapPage> {
  String city;
  String userAddress;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController controller;
  LatLng currentLocation;
  LatLng rawLocation;
  List<Marker> allMarkers = [];
  TextEditingController searchAddressField = TextEditingController();
  List<PlacesSearchResult> places = [];
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);
  SharedPreferences prefs;

  _getCurrentUserLocation([bool fromBtn=false]) async {
  }
  Future updateAddress([LatLng address]) async {
    userAddress = await findAddress(address ?? currentLocation);

    setState(() {
      searchAddressField.text = userAddress;
    });
  }
  void onMapTapped(LatLng cords) async {
    setState(() {
      currentLocation= cords;
      allMarkers.clear();
      allMarkers.add(Marker(
        markerId: MarkerId('0'),
        position: currentLocation,
        draggable: true,
        onDragEnd: onMarkerDragEnd,
      ));
      updateAddress();
    });
  }
  void onMarkerDragEnd(LatLng position) async {
    currentLocation=position;
    await updateAddress(position);
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 15.0)
      ),
    );
  }
  _getPlacesPredictions() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
    );
    displayPrediction(p);
  }
  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      for (var i = 0; i < p.terms.length; ++i) {
        print('displayPrediction terms[$i]: ${p.terms[i].value}');
      }
      print('displayPrediction matchedSubstrings: ${p.matchedSubstrings}');
      LatLng tempLatLng = new LatLng(lat, lng);

      setState(()  {
        currentLocation = tempLatLng;
        updateAddress();
        searchAddressField.text = userAddress;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: currentLocation, zoom: 16.0),
          ),
        );
      });
    }
  }
  @override void initState() {
    super.initState();
    loadData();
    if(widget.editMode)
      _editPreviousLocation();
    else
      _getCurrentUserLocation();
  }
  loadData() async {
    prefs = await SharedPreferences.getInstance();
  }
  _editPreviousLocation() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
     currentLocation = LatLng(prefs.getDouble('latitude'),prefs.getDouble('longitude'));
     updateAddress();
    });
    allMarkers.clear();
    allMarkers.add(Marker(
        markerId: MarkerId('0'),
        position: currentLocation,
        draggable: true,
        onDragEnd: onMarkerDragEnd
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(widget.editMode){
          Navigator.pop(context, OrderLocation(
            cords: currentLocation,
            address: userAddress,
            city: city
          ));
        }
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: LocalizationSelector(
                    selected: EasyLocalization.of(context).locale,
                    onChanged: (locale) {
                      setState(() => EasyLocalization.of(context).locale = locale);
                    },
                  ),
                ),
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  constraints: BoxConstraints.expand(height: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(children: <Widget>[
                    Icon(Icons.location_on),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: _getPlacesPredictions,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Center(child: Text(
                              searchAddressField.text.isEmpty ?
                              'Enter Your Location' : searchAddressField.text
                            ))
                          ],
                        ),
                      ),
                    )),
                    GestureDetector(
                      onTap:()=> _getCurrentUserLocation(true),
                      child: Icon(Icons.my_location)
                    ),
                  ]),
                )
              ),
            ),
          ),
          body: currentLocation!=null ? GoogleMap(
            onCameraMove: (CameraPosition position) {
              rawLocation = position.target;
            },
            onTap: onMapTapped,
            zoomControlsEnabled: false,
            compassEnabled: true,
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(target: currentLocation, zoom: 15),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              this.controller = controller;
            },
            markers: Set.from(allMarkers),
          )
              : Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: Text('Getting your current location..'),
              ),
              Text('(Make sure you have your location enabled)',style: TextStyle(color: Colors.grey),)
            ],
          ),
        ),
        bottomNavigationBar: Material(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              height: 45,
              child: FlatButton.icon(
                shape: StadiumBorder(),
                textColor: Colors.white,
                icon: Icon(Icons.location_on),
                color: Theme.of(context).accentColor,
                label: Text(tr('Set_Your_Location')),
                onPressed: currentLocation != null ? () async {
                  print(city);
                  if(widget.timeAndLocation){
                    OrderLocation location = OrderLocation(
                      cords: currentLocation,
                      address: userAddress,
                      city: city
                    );

                    Navigator.of(context).pop(location);
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        content: Row(children: <Widget>[
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2)
                          ),
                          SizedBox(width: 20),
                          Text('Saving your coordinates ...')
                        ]),
                      );
                    }
                  );

                  print(prefs);
                  prefs.setDouble("latitude", currentLocation.latitude);
                  prefs.setDouble("longitude", currentLocation.longitude);
                  prefs.setString("address", userAddress);
                  prefs.setString('city', city);
                  print(city);



//                  ApplicationData.isSignedIn ? Navigator.of(context).pushNamedAndRemoveUntil('sign-in', (route) => false) :

                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                } :  null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> findAddress(LatLng cords) async{
    var addresses = await Geocoder.google(apiKey).findAddressesFromCoordinates(Coordinates(cords.latitude,cords.longitude));
    String formattedAddress = "";
    if (addresses.first.addressLine.contains(",")) {
      List<String> descriptionSplit = addresses.first.addressLine.split(",");
      for (var i = 0; i < descriptionSplit.length - 1; ++i) {
        if (i == descriptionSplit.length - 2) {
          formattedAddress += descriptionSplit[i];
        } else {
          formattedAddress += descriptionSplit[i] + ", ";
        }
      }
    } else {
      formattedAddress = addresses.first.addressLine;
    }
    city = addresses.first.locality;
    return formattedAddress;
  }

}