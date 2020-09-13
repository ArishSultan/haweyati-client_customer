import 'package:haweyati/models/suppliers_model.dart';
import 'package:hive/hive.dart';
import 'bm-pricing.dart';
import '../src/models/image_model.dart';
// part 'building-material_sublist.g.dart';

@HiveType(typeId: 10)
class BMProduct extends HiveObject {
  @HiveField(0)
  List<Supplier> suppliers;
  @HiveField(1)
  String sId;
  @HiveField(2)
  String name;
  @HiveField(3)
  String description;
  @HiveField(4)
  String parent;
  @HiveField(5)
  List<BMPricing> pricing;
  @HiveField(6)
  ImageModel image;
  @HiveField(7)
  int iV;

  BMProduct(
      {this.suppliers,
        this.sId,
        this.name,
        this.parent,
        this.description,
        this.pricing,
        this.image,
        this.iV});

  BMProduct.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    parent = json['parent'];
    if (json['pricing'] != null) {
      pricing = List<BMPricing>();
      json['pricing'].forEach((v) {
        pricing.add( BMPricing.fromJson(v));
      });
    }

    image = ImageModel.fromJson(json['image']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.suppliers != null) {
      data['suppliers'] = this.suppliers.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image.serialize();
    data['parent'] = this.parent;
    if (this.pricing != null) {
      data['pricing'] = this.pricing.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    return data;
  }
}



