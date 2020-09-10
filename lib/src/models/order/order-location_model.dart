import 'package:haweyati/src/models/location_model.dart';
import 'package:haweyati/src/models/time-slot_model.dart';

class OrderLocation extends Location {
  TimeSlot dropOffTime;
  DateTime dropOffDate;

  @override
  Map<String, dynamic> serialize() => super.serialize()..addAll({
    'dropOffTime': dropOffTime.serialize(),
    'dropOffDate': dropOffDate.millisecondsSinceEpoch,
  });
}

class RentableOrderLocation extends OrderLocation {
  TimeSlot pickUpTime;
  DateTime pickUpDate;

  RentableOrderLocation();

  factory RentableOrderLocation.from(OrderLocation location) {
    return RentableOrderLocation()
      ..city = location?.city
      ..address = location?.address
      ..latitude = location?.latitude
      ..longitude = location?.longitude
      ..dropOffTime = location?.dropOffTime
      ..dropOffDate = location?.dropOffDate;
  }

  @override
  Map<String, dynamic> serialize() => super.serialize()..addAll({
    'pickUpTime': pickUpTime.serialize(),
    'pickUpDate': pickUpDate.millisecondsSinceEpoch,
  });
}