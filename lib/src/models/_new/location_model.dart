import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 127)
class $Location {
  @HiveField(0) String city;
  @HiveField(1) String address;
  @HiveField(2) double latitude;
  @HiveField(3) double longitude;

  $Location({
    this.city,
    this.address,
    this.latitude,
    this.longitude
  });

  toJson() => _$$LocationToJson(this);
  factory $Location.fromJson(json) => _$$LocationFromJson(json);
}