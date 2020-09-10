import 'package:hive/hive.dart';
import 'location_model.dart';
import '../../models/hive-models/customer/profile_model.dart';
import 'package:haweyati/src/common/models/json_serializable.dart';

@HiveType(typeId: 100)
class User implements JsonSerializable {
  @HiveField(0) String id;
  @HiveField(1) String status;
  @HiveField(2) String message;
  @HiveField(3) Profile profile;
  @HiveField(4) Location location;

  User({
    this.id,
    this.status,
    this.message,
    this.profile,
    this.location
  });

  @override
  Map<String, dynamic> serialize() => {
    '_id': id,
    'status': status,
    'message': message,
    'profile': profile,
    'location': location,
  };
}
