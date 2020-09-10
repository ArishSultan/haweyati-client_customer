import 'dart:async';
import 'dart:collection';
import 'dart:ui' as intl;
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
import 'package:haweyati/src/ui/widgets/localization-selector.dart';
import 'package:shared_preferences/shared_preferences.dart';

String apiKey = 'AIzaSyDdNpY6LGWgHqRfTRZsKkVhocYOaER325w';

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
  Set<Polygon> polygons = HashSet<Polygon>();
  TextEditingController searchAddressField = TextEditingController();
  List<PlacesSearchResult> places = [];
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);
  SharedPreferences prefs;
  List<LatLng> saudiaCoordinates = const [
  ];
//  north: 32.03,
//  south: 16.72,
//  west: 34.76,
//  east: 55.24

  LatLngBounds saudiArabia = LatLngBounds(southwest: LatLng(16.57946,35.69014),northeast: LatLng(31.67252,50.20833));

  _getCurrentUserLocation([bool fromBtn=false]) async {

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      if(fromBtn){
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: currentLocation, zoom: 15.0)
          ),
        );
      }
    });
    updateAddress();
    allMarkers.clear();
    allMarkers.add(Marker(
        markerId: MarkerId('0'),
        position: currentLocation,
        draggable: true,
        onDragEnd: onMarkerDragEnd
    ));
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
        components: [Component(Component.country, "sau")]
    );
    displayPrediction(p);
  }

  Future displayPrediction(Prediction p) async {
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
        allMarkers.clear();
        allMarkers.add(Marker(
            markerId: MarkerId('0'),
            position: currentLocation,
            draggable: true,
            onDragEnd: onMarkerDragEnd
              ));
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: currentLocation, zoom: 16.0),
          ),
        );
      });
    }
  }

  void _setPolygon(){
    polygons.add(Polygon(
      polygonId: PolygonId('0'),
      points: saudiaCoordinates,
      fillColor: Colors.transparent ,
      strokeWidth: 2,
      strokeColor: Colors.red
    ));
  }

  @override
  void initState() {
    super.initState();
    _setPolygon();
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
    return Scaffold(
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
//            cameraTargetBounds: CameraTargetBounds(saudiArabia),
          zoomControlsEnabled: false,
          compassEnabled: true,
          polygons: polygons,
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

                await  prefs.setDouble("latitude", currentLocation.latitude);
                await  prefs.setDouble("longitude", currentLocation.longitude);
                await  prefs.setString("address", userAddress);
                await  prefs.setString('city', city);

                print(prefs);
                if(widget.timeAndLocation || widget.editMode){
                  OrderLocation location = OrderLocation(
                      cords: currentLocation,
                      address: userAddress,
                      city: city
                  );
                  Navigator.of(context).pop(location);
                  Navigator.of(context).pop(location);
                  return;
                }

                Navigator.pop(context);

                // HaweyatiData.isSignedIn ?   Navigator.of(context)
                //     .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false) :
                // Navigator.of(context).pushNamedAndRemoveUntil('/sign-in', (route) => false) ;

              } :  null,
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