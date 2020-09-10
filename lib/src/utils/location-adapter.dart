import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haweyati/src/models/order/order-location_model.dart';
import 'package:haweyati/src/ui/pages/locations-map_page.dart';

class LocationAdapter {
  OrderLocation locationDetailsToOrderLocation(LocationDetails details) {
    if (details != null) {
      return OrderLocation()
        ..city = details.city
        ..address = details.address
        ..latitude = details.coordinates.latitude
        ..longitude = details.coordinates.longitude;
    }

    return null;
  }

  LocationDetails orderLocationToLocationDetails(OrderLocation location) {
    if (location != null) {
      return LocationDetails(
        city: location.city,
        address: location.address,
        coordinates: LatLng(
          location.latitude,
          location.longitude
        )
      );
    }

    return null;
  }
}