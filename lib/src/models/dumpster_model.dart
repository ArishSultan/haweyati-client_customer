import 'package:hive/hive.dart';
import 'image_model.dart';
import 'rent_model.dart';

@HiveType(typeId: 20)
class Dumpster extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String size;
  @HiveField(2) ImageModel image;
  @HiveField(3) List<Rent> pricing;
  @HiveField(4) String description;

  List<String> suppliers;

  Dumpster({
    this.id,
    this.size,
    this.image,
    this.pricing,
    this.suppliers,
    this.description
  });

  Dumpster.fromJson(Map<String, dynamic> json, [bool isOrder = false]) {
    id = json['_id'];
    size = json['size'];
    suppliers = json['suppliers'].cast<String>();
    description = json['description'];
    image = ImageModel.fromJson(json['image']);

    final _pricing = json['pricing'] as List;
    if (_pricing != null) {
      if (isOrder) {
        pricing = [Rent.fromJson(json['pricing'])];
      } else {
        pricing = _pricing
          .map((e) => Rent.fromJson(e))
          .toList(growable: false);
      }
    }
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'size': size,
    'suppliers': suppliers,
    'description': description,
    'image': image.serialize(),
    'pricing': pricing.map((e) => e.toJson()).toList()[0]
  };
}