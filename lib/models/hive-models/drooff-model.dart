
import 'package:haweyati/src/models/location_model.dart';
import 'package:hive/hive.dart';

class DropOff extends HiveObject{
  String dropOffAddress;
  String dropOffTime;
  DateTime dropOffDate;
  Location dropOffLocation;

  DropOff({this.dropOffDate,this.dropOffTime,this.dropOffAddress});

  DropOff.fromJson(Map<String,dynamic> json){
    dropOffAddress = json['dropoffAddress'];
    dropOffTime = json['dropoffTime'];
    dropOffDate = json['dropoffDate']!=null ? DateTime.parse(json['dropoffDate']) : null;
    dropOffLocation = Location.fromJson(json['dropoffLocation']);
  }

}

/// Order -> Location
///   DropOff
///   PickUp
///
/// RentableOrder
/// SimpleOrder
///