import 'package:hive/hive.dart';
import 'package:haweyati/src/common/models/json_serializable.dart';

// part 'images_model.g.dart';

@HiveType(typeId: 102)
class ImageModel extends HiveObject implements JsonSerializable {
  @HiveField(0) String id;
  @HiveField(1) String name;

  ImageModel({
    this.id,
    this.name
  });

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
  }

  @override
  Map<String, dynamic> serialize() => {
    '_id': id, 'path': name
  };
}