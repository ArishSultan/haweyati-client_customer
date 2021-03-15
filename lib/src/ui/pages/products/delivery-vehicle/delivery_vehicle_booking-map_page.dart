import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoder/geocoder.dart';
import 'package:haweyati/src/common/modals/confirmation-dialog.dart';
import 'package:haweyati/src/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:haweyati/src/rest/_new/estimated-price_service.dart';
import 'package:haweyati/src/rest/_new/products/delivery-vehicle_rest.dart';
import 'package:haweyati/src/services/hyerptrack_service.dart';
import 'package:haweyati/src/ui/pages/location/locations-map_page.dart';
import 'package:haweyati/src/ui/widgets/details-table.dart';
import 'package:haweyati/src/ui/widgets/table-rows.dart';
import 'package:haweyati/src/utils/lazy_task.dart';
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati/src/utils/simple-future-builder.dart';
import 'package:haweyati_client_data_models/models/order/order_model.dart';
import 'package:haweyati_client_data_models/models/order/products/delivery-vehicle_orderable.dart';
import 'package:haweyati_client_data_models/models/products/delivery-vehicle_model.dart';
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
import 'package:http/http.dart' as http;
import 'delivery-vehicle_pages.dart';
import 'select-vehicle_page.dart';

enum SelectionMode{
  pickUp,
  dropOff,
  vehicle
}

class DeliveryVehicleMapPage extends StatefulWidget {
  @override
  _DeliveryVehicleMapPageState createState() => _DeliveryVehicleMapPageState();
}

class _DeliveryVehicleMapPageState extends State<DeliveryVehicleMapPage> {
  Address _pickUpAddress;
  Address _dropOffAddress;
  LatLng pickUpLocation;
  LatLng dropOffLocation;
  bool _initiated = false;
  GoogleMapController _controller;
  SelectionMode mode = SelectionMode.pickUp;
  final _utils = _MapUtilsImpl();
  final _markers = Set<Marker>();
  Future<List<DeliveryVehicle>> vehicleTypes;
  var _rest = DeliveryVehicleRest();
  GoogleMapsServices _googleMapServices = GoogleMapsServices();
  DeliveryVehicle selectedVehicle;
  BitmapDescriptor pickUpLocationBitmap;
  BitmapDescriptor mapCarMarker;
  var PersonMarkerIcon = 'assets/map-icons/mapicons-person.png';
  var CarMarkerIcon = 'assets/map-icons/map-car-marker.png';
  Future<List> nearbyVehicles;
  List<LatLng> vehicleCords = [];
  final Set<Polyline> _polyLines = {};
  final _order = Order<DeliveryVehicleOrderable>(OrderType.deliveryVehicle);
  final _item = DeliveryVehicleOrderable();

  Future createRoute() async {
    print("Route was created again");
    String route = await _googleMapServices.getRouteCoordinates(pickUpLocation,dropOffLocation);
      _polyLines.clear();
      _polyLines.add(Polyline(
          polylineId: PolylineId('route'),
          width: 3,
          points: convertToLatLng(decodePoly(route)),
          color: Colors.blue
      ));
      setState(() {});
  }

  @override
  void initState() {
    super.initState();
    pickUpLocation = l.AppData().coordinates;
    vehicleTypes = _rest.get();
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(9, 9)), PersonMarkerIcon)
        .then((onValue) {
          setState(() {
            pickUpLocationBitmap = onValue;
          });
        });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(9, 9)), CarMarkerIcon)
        .then((onValue) {
          setState(() {
            mapCarMarker = onValue;
          });
    });
  }

  Future showNearbyDrivers() async {
    if(selectedVehicle!=null){
      HyperRequestService().fetchNearby(pickUpLocation,selectedVehicle.id).then((value){
        vehicleCords.clear();
        if(this.mounted){
          for(var loc in value){
            var l = LatLng(loc['location']['geometry']['coordinates'][1],
                loc['location']['geometry']['coordinates'][0]);
            vehicleCords.add(l);
            _markers
              ..add(Marker(
                  draggable: false,
                  position: l,
                  markerId: MarkerId( (l.latitude+l.longitude).toString() ),
                  icon: mapCarMarker
              ));
          }
        }
        setState(() {});
      });
    }
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
                            text: mode == SelectionMode.pickUp ? _pickUpAddress?.addressLine ?? 'Tap To Search' :
                            _dropOffAddress?.addressLine ?? 'Tap To Search'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: _resolveMap(),
        bottom: BottomAction(
          dropOffAddress: _dropOffAddress,
          dropOff: dropOffLocation,
          pickup: pickUpLocation,
          pickUpAddress: _pickUpAddress,
          initiated: _initiated,
          onConfirmedDropOff: createRoute,
          mode: mode,
          vehicle: selectedVehicle,
          onChanged: (SelectionMode _mode)=> mode = _mode,
          proceedOrder: () async {
            _order.clearProducts();
            _item.product = selectedVehicle;
            _item.pickUpLocation = l.Location(
              city : _pickUpAddress.locality,
              address : _pickUpAddress.addressLine,
              latitude : pickUpLocation.latitude,
              longitude : pickUpLocation.longitude,
            );
            _order.location = l.OrderLocation(
              latitude : dropOffLocation.latitude,
              longitude : dropOffLocation.longitude,
            )..address = _dropOffAddress.addressLine
              ..city =  _dropOffAddress.locality
              ..latitude = dropOffLocation.latitude
              ..longitude = dropOffLocation.longitude;

            await performLazyTask(context, () async {
              var _rest = await EstimatedPriceRest().getPrice({
                'vehicle' : selectedVehicle.id,
                'pickUpLat' : _item.pickUpLocation.latitude,
                'pickUpLng' : _item.pickUpLocation.longitude,
                'dropOffLat' : _order.location.latitude,
                'dropOffLng' : _order.location.longitude,
              });
              if(_rest == null ) return;
              final location = await showDialog(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                    title: Text('Proceed'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DetailsTable([
                          PriceRow(
                            'Estimated Price',
                            _rest.price,
                          ),
                          TableRow(
                              children: [
                                Text("Distance",style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontFamily: 'Lato',
                                  height: 1.9,
                                ),),
                                Text(_rest.distance.toString() + " km",textAlign: TextAlign.right,),
                              ]
                          )
                        ]),
                      ],
                    ),
                  ));

              if (location != true) return;
              _item.distance = _rest.distance;
              _order.addProduct(
                _item, _rest.price,
              );
              navigateTo(context, DeliveryVehicleOrderConfirmationPage(_order));

            },message: 'Processing');


          },
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
          initialCameraPosition: CameraPosition(target: mode == SelectionMode.pickUp ? pickUpLocation : dropOffLocation ?? pickUpLocation, zoom: 15),
          onTap: _setLocationOnMap,
          polygons: _bounds,
          onMapCreated: (controller) {
            _controller = controller;
          },
          polylines: _polyLines,
          compassEnabled: true,
          markers: _markers,
        ),
        Positioned(
          right: 15,
          bottom: 125,
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
     if(mode == SelectionMode.vehicle)  Positioned(
          right: 15,
          bottom: 5,
          left: 15,
          child: SimpleFutureBuilder.simpler(
              context: context,
              future: vehicleTypes,
              noDataChild: Center(child: Text("No Vehicles Found")),
              builder: (List<DeliveryVehicle> vehicles) {
               return InkWell(
                 onTap: () async {
                  DeliveryVehicle _vehicle = await showModalBottomSheet(context: context, builder: (context){
                     return SelectVehicle(vehicles,selectedVehicle);
                   });
                   if(_vehicle!=null) setState(() {
                     selectedVehicle = _vehicle;
                   });
                  await showNearbyDrivers();
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
                          ) ,
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
      // if (pickUpLocation != null) {
      //   _setLocationOnMap(pickUpLocation);
      // } else {
      //
      // if(pickUpLocation!=null)
        _setLocationOnMap(pickUpLocation);
      // else
      //   _utils.fetchCurrentLocation().then(_setLocationOnMap);

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

  _setLocationOnMap(LatLng location,[bool fromDrag=false]) async {
   if(fromDrag) print("called from drag");
    if (_controller != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext ctx) => WaitingDialog(
          message: AppLocalizations.of(context).fetchingLocationData,
        ),
      );
    }
    if (location == null) {
      pickUpLocation = await _utils.fetchCurrentLocation();
    } else {
      if(mode == SelectionMode.pickUp){
        pickUpLocation = location;
      }
      else if(mode == SelectionMode.dropOff){
        dropOffLocation = location;
      }
      else if(mode == SelectionMode.vehicle){
        if(fromDrag && pickUpLocation!=null && dropOffLocation!=null){
          createRoute();
          if(selectedVehicle!=null)  showNearbyDrivers();
        }
      }
    }
    _markers
      ..add(Marker(
        draggable: true,
        position: mode == SelectionMode.pickUp ? pickUpLocation : dropOffLocation,
        markerId: MarkerId( mode == SelectionMode.pickUp ? 'pickup' : 'dropOff'),
        onDragEnd: (LatLng val)=> _setLocationOnMap(val,true),
        icon: mode == SelectionMode.pickUp ? pickUpLocationBitmap : null
      ));

    if(mode == SelectionMode.pickUp)
    _pickUpAddress = await _utils.fetchAddress(pickUpLocation);
    else if(mode == SelectionMode.dropOff)
      _dropOffAddress = await _utils.fetchAddress(dropOffLocation);

    if (_controller != null) {
    if(Navigator.canPop(context)) Navigator.of(context).pop();
      _controller.animateCamera(CameraUpdate.newLatLng(mode == SelectionMode.pickUp ? pickUpLocation : dropOffLocation));
    }

    if (!_initiated) _initiated = true;
    setState(() {});
  }
}

class BottomAction extends StatefulWidget {
  SelectionMode mode;
  final LatLng pickup;
  final LatLng dropOff;
  final Address pickUpAddress;
  final Address dropOffAddress;
  final bool initiated;
  final DeliveryVehicle vehicle;
  final onConfirmedDropOff;
  final Function(SelectionMode mode) onChanged;
  final Function proceedOrder;
  BottomAction({this.pickup,this.mode,
    this.onChanged,
    this.dropOffAddress,this.pickUpAddress,
    this.vehicle,
    this.proceedOrder,
    this.onConfirmedDropOff,
    this.dropOff,this.initiated});
  @override
  _BottomActionState createState() => _BottomActionState();
}

class _BottomActionState extends State<BottomAction> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if(widget.pickup!=null && widget.mode!=SelectionMode.pickUp && widget.pickUpAddress!=null)  ListTile(
          leading: Icon(CupertinoIcons.location,color: Theme.of(context).accentColor,),
          dense: true,
          title: Text("Pickup"),
          subtitle: Column(
            children: [
              Text(widget.pickUpAddress?.addressLine),
              Divider(),
            ],
          ),
        ),
        if(widget.dropOff!=null && widget.mode!=SelectionMode.dropOff && widget.dropOffAddress!=null)  ListTile(
          leading: Icon(CupertinoIcons.location,color: Colors.red,),
          dense: true,
          title: Text("Drop off"),
          subtitle: Text(widget.dropOffAddress?.addressLine),
        ),
        RaisedActionButton(
            label: _label,
            onPressed: enabled ? () {
              if(widget.mode == SelectionMode.pickUp)
                setState(() {
                  widget.mode = SelectionMode.dropOff;
                  widget.onChanged(SelectionMode.dropOff);
                });
              else if(widget.mode == SelectionMode.dropOff){
                widget.mode = SelectionMode.vehicle;
                widget.onChanged(SelectionMode.vehicle);
                widget.onConfirmedDropOff();
                setState(() {});
              }
              else if(widget.mode == SelectionMode.vehicle && widget.vehicle!=null){
                widget.proceedOrder();
                return;

                // navigateTo(context, DeliveryVehicleSelectionPage(
                //     widget.vehicle,
                //     l.Location(
                //       city : widget.pickUpAddress.locality,
                //       address : widget.pickUpAddress.addressLine,
                //       latitude : widget.pickup.latitude,
                //       longitude : widget.pickup.longitude,
                //     ),
                //     l.OrderLocation(
                //       latitude : widget.dropOff.latitude,
                //       longitude : widget.dropOff.longitude,
                //     )..address = widget.dropOffAddress.addressLine
                //       ..city =  widget.dropOffAddress.locality
                //       ..latitude = widget.dropOff.latitude
                //       ..longitude = widget.dropOff.longitude
                // ));
              }} : null
        ),
      ],
    );
  }

  String get _label=> widget.mode == SelectionMode.pickUp ? 'Confirm Pickup' :
    (widget.mode == SelectionMode.dropOff ? 'Confirm DropOff' : (widget.mode == SelectionMode.vehicle ? 'Proceed' : ''));

  bool get enabled=> !(widget.pickup == null && !widget.initiated || (widget.mode == SelectionMode.vehicle && widget.vehicle==null));

}



class _MapUtilsImpl {
  final pickUpLocation = loc.Location();

  Future<Address> fetchAddress(final LatLng location) async {
    return (await Geocoder.google(apiKey).findAddressesFromCoordinates(
            Coordinates(location.latitude, location.longitude)))
        .first;
  }

  Future<LatLng> fetchCurrentLocation() async {
    final position = await pickUpLocation.getLocation();
    return LatLng(position.latitude, position.longitude);
  }
}

const apiKey = "AIzaSyDdNpY6LGWgHqRfTRZsKkVhocYOaER325w";

class GoogleMapsServices{

  Future<String> getRouteCoordinates(LatLng currentLocation,LatLng destination)async{
    StringBuffer query = StringBuffer('https://maps.googleapis.com/maps/api/directions/json?origin=');
    query.write('${currentLocation.latitude},${currentLocation.longitude}');
    // query.write('&waypoints=');
    // for(var waypoint in waypoints){
    //   // query.write('via:-${waypoint.latitude},${waypoint.longitude}|');
    //   query.write('${waypoint.latitude},${waypoint.longitude}|');
    // }
    query.write('&key=AIzaSyDdNpY6LGWgHqRfTRZsKkVhocYOaER325w');
    query.write('&destination=${destination.latitude},${destination.longitude}');
    print(query.toString());
    //TODO modified
    http.Response response = await http.get(Uri.parse(query.toString()));
    Map values = jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }
}

List<LatLng> convertToLatLng(List points) {
  List<LatLng> result = <LatLng>[];
  for (int i = 0; i < points.length; i++) {
    if (i % 2 != 0) {
      result.add(LatLng(points[i - 1], points[i]));
    }
  }
  return result;
}

List decodePoly(String poly) {
  var list = poly.codeUnits;
  var lList = new List();
  int index = 0;
  int len = poly.length;
  int c = 0;
// repeating until all attributes are decoded
  do {
    var shift = 0;
    int result = 0;

    // for decoding value of one attribute
    do {
      c = list[index] - 63;
      result |= (c & 0x1F) << (shift * 5);
      index++;
      shift++;
    } while (c >= 32);
    /* if value is negetive then bitwise not the value */
    if (result & 1 == 1) {
      result = ~result;
    }
    var result1 = (result >> 1) * 0.00001;
    lList.add(result1);
  } while (index < len);

/*adding to previous value as done in encoding */
  for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

  print(lList.toString());

  return lList;
}