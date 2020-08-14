import 'package:haweyati/models/hive-models/orders/location_model.dart';
import 'package:hive/hive.dart';
import 'person_model.dart';
part 'suppliers_model.g.dart';

@HiveType(typeId: 11)
class Supplier extends HiveObject {
  @HiveField(0)
  List<String> services;
  @HiveField(1)
  String status;
  @HiveField(2)
  String sId;
  @HiveField(3)
  String city;
  @HiveField(4)
  Person person;
  @HiveField(5)
  HiveLocation location;
  @HiveField(6)
  int iV;

  Supplier(
      {this.services,
        this.status,
        this.sId,
        this.city,
        this.person,
        this.location,
        this.iV});

  Supplier.fromJson(Map<String, dynamic> json) {
    services = json['services'].cast<String>();
    status = json['status'];
    sId = json['_id'];
    city = json['city'];
    person =
    json['person'] != null ? new Person.fromJson(json['person']) : null;
    location = json['location'] != null
        ? new HiveLocation.fromJson(json['location'])
        : null;
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['services'] = this.services;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['city'] = this.city;
    if (this.person != null) {
      data['person'] = this.person.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['__v'] = this.iV;
    return data;
  }
}