import 'package:haweyati/src/models/_new/_base_model.dart';
import 'package:haweyati/src/models/_new/location_model.dart';
import 'package:haweyati/src/models/_new/profile_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_model.g.dart';

@HiveType(typeId: 128)
@JsonSerializable(includeIfNull: false)
class $Customer extends BaseModelHive {
  @HiveField(1) String status;
  @HiveField(2) String message;
  @HiveField(3) $Profile profile;
  @HiveField(4) $Location location;

  String get name => profile.name;

  $Customer();

  toJson() => _$$CustomerToJson(this);
  factory $Customer.fromJson(json) => _$$CustomerFromJson(json);
}
