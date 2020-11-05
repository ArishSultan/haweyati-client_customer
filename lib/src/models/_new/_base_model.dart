import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

class $BaseModel {
  @JsonKey(name: '_id')
  String id;
}

class BaseModelHive extends HiveObject {
  @HiveField(0)
  @JsonKey(name: '_id')
  String id;
}