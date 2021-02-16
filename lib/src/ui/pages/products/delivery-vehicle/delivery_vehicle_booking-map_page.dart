import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoder/geocoder.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/_new/products/delivery-vehicle_rest.dart';
import 'package:haweyati/src/ui/pages/location/locations-map_page.dart';
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati/src/utils/simple-future-builder.dart';
import 'package:haweyati_client_data_models/models/order/vehicle-type.dart';
import 'package:haweyati_client_data_models/models/products/delivery-vehicle_model.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_webservice/places.dart';
import 'package:haweyati/l10n/app_localizations.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/views/localized_view.dart';
import 'package:haweyati_client_data_models/data.dart' as l;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/widgets/localization-selector.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';

import 'delivery-vehicle_pages.dart';
import 'select-vehicle_page.dart';

class DeliveryVehicleMapPage extends StatefulWidget {
  @override
  _DeliveryVehicleMapPageState createState() => _DeliveryVehicleMapPageState();
}

class _DeliveryVehicleMapPageState extends State<DeliveryVehicleMapPage> {
  Address _address;
  LatLng _location;
  bool _initiated = false;
  GoogleMapController _controller;

  final _utils = _MapUtilsImpl();
  final _markers = Set<Marker>();
  Future<List<DeliveryVehicle>> vehicleTypes;
  var _rest = DeliveryVehicleRest();
  DeliveryVehicle selectedVehicle;
  @override
  void initState() {
    super.initState();
    _location = l.AppData().coordinates;
    vehicleTypes = _rest.get();
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
          label: 'Confirm Pickup',
          onPressed: (_location != null && _initiated && selectedVehicle!=null)
              ? () {
            navigateTo(context, DeliveryVehicleSelectionPage(
                selectedVehicle,
                l.Location(
                  city : _address.locality,
                  address : _address.addressLine,
                  latitude : _location.latitude,
                  longitude : _location.longitude,
                )
            ));

                  // Navigator.of(context).pop(l.Location(
                  //   city: _address.locality,
                  //   address: _address.addressLine,
                  //   latitude: _location.latitude,
                  //   longitude: _location.longitude,
                  // ));
                  //
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
          zoomControlsEnabled: false,
          compassEnabled: true,
          markers: _markers,
        ),
        Positioned(
          right: 15,
          bottom: 65,
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
        ),
        Positioned(
          right: 15,
          bottom: 5,
          left: 15,
          child: SimpleFutureBuilder.simpler(
              context: context,
              future: vehicleTypes,
              builder: (AsyncSnapshot<List<DeliveryVehicle>> vehicles) {
               return InkWell(
                 onTap: () async {
                DeliveryVehicle _vehicle = await showModalBottomSheet(context: context, builder: (context){
                     return SelectVehicle(vehicles.data,selectedVehicle);
                   });
                   if(_vehicle!=null) setState(() =>selectedVehicle = _vehicle);
                 },
                 child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Image.asset(
                              TruckIcon,
                              scale: 4,
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                           selectedVehicle == null ? 'Choose Vehicle Type': selectedVehicle.name ,
                            style: TextStyle(fontSize: 15),
                          ),
                          Expanded(child: Container()),
                          Expanded(child: Container()),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
               );
              }),
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
