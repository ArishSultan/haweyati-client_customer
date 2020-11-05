import 'package:haweyati/src/common/models/serializable.dart';
import 'package:haweyati/src/models/image_model.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:hive/hive.dart';

import 'pricing_model.dart';

part 'model.g.dart';

@HiveType(typeId: 21)
class BuildingMaterial extends HiveObject implements Orderable {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) String parent;
  @HiveField(3) ImageModel image;
  @HiveField(4) String description;
  @HiveField(5) List<BuildingMaterialPricing> pricing;

  double get price12 => pricing.first.price12yard;
  double get price20 => pricing.first.price20yard;

  BuildingMaterial({
    this.id,
    this.name,
    this.image,
    this.parent,
    this.pricing,
    this.description,
  });

  factory BuildingMaterial.fromJson(Map<String, dynamic> json) {
    final material =  BuildingMaterial(
      id: json['_id'],
      name: json['name'],
      parent: json['parent'],
      description: json['description'],
      image: ImageModel.fromJson(json['image']),
    );

    if (json['pricing'] != null) {
      material.pricing = List<BuildingMaterialPricing>();

      json['pricing'].forEach((v) {
        material.pricing.add(BuildingMaterialPricing.fromJson(v));
      });
    }

    return material;
  }

  Map<String, dynamic> toJson() => {
    'name': this.name,
    'image': this.image.serialize(),
    'parent': this.parent,

    'pricing': pricing
      ?.map((e) => e.toJson())
      ?.toList(),

    'description': this.description,
  };

  @override
  Map<String, dynamic> serialize() => toJson();
}

@HiveType(typeId: 77)
class BuildingMaterialSize implements Serializable<String> {
  @HiveField(0)
  final String _size;
  const BuildingMaterialSize(this._size);
  const BuildingMaterialSize._(this._size);

  factory BuildingMaterialSize.deserialize(String size) {
    if (size.toLowerCase() == '12 yards') {
      return yards12;
    } else {
      return yards20;
    }
  }

  static const yards12 = BuildingMaterialSize._('12 Yards');
  static const yards20 = BuildingMaterialSize._('20 Yards');

  @override
  String serialize() => _size;

  @override
  String toString() => _size;
}
