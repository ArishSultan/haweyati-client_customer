import 'package:haweyati/src/models/location_model.dart';
import 'package:hive/hive.dart';
import 'profile_model.dart';
part 'customer-model.g.dart';

@HiveType(typeId: 4)
class Customer extends HiveObject{
  @HiveField(0)
  String id;
  @HiveField(1)
  Profile profile;
  @HiveField(2)
  Location location;
  @HiveField(3)
  String token;
  @HiveField(4)
  String message;
  @HiveField(5)
  String status;

  Customer({this.location,this.id,this.token,this.message,this.profile,this.status});

  Customer.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['_id'];
    profile =  json['profile'] !=null ? Profile.fromJson(json['profile']) : null;
    token = json['token'];
    location = json['location'] !=null ? Location.fromJson(json['location']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.id;
    data['location'] = this.location?.serialize();
    data['profile'] = this.profile?.serialize();
//    data['token'] = this.token;
    data['status'] = this.token;
    data['message'] = this.message;
    return data;
  }

}