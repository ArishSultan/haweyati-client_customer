import 'package:haweyati/src/common/models/json_serializable.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/profile_model.dart';
import 'package:hive/hive.dart';

import 'location_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: 100)
class User extends HiveObject implements JsonSerializable {
  @HiveField(0) String id;
  @HiveField(1) String status;
  @HiveField(2) String message;
  @HiveField(3) Profile profile;
  @HiveField(4) Location location;

  String get name => profile.name;
  String get image => profile.image.name;

  User({
    this.id,
    this.status,
    this.message,
    this.profile,
    this.location
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      status: json['status'],
      message: json['message'],
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      location: json['location'] != null ? Location.fromJson(json['profile']) : null,
    );
  }

  @override
  Map<String, dynamic> serialize() => {
    '_id': id,
    'status': status,
    'message': message,
    'profile': profile.serialize(),
    'location': location.serialize(),
  };
}
