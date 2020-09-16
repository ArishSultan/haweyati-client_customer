import 'package:haweyati/models/options_model.dart';
import 'package:haweyati/models/suppliers_model.dart';
import 'package:hive/hive.dart';
import '../src/models/image_model.dart';

// part 'finishing-product.g.dart';

@HiveType(typeId: 16)
class FinishingMaterial extends HiveObject{
  @HiveField(1)
  String id;
  @HiveField(2)
  double price;
  @HiveField(3)
  String name;
  @HiveField(4)
  String description;
  @HiveField(5)
  String parent;
  @HiveField(6)
  List<ProductOption> options;
  @HiveField(7)
  List<Map<String,dynamic>> variants;
  @HiveField(8)
  ImageModel images;
  @HiveField(9)
  int iV;

  FinishingMaterial(
      {this.id,
        this.price,
        this.name,
        this.variants,
        this.parent,
        this.description,
        this.options,
        this.images,
        this.iV});

  FinishingMaterial.fromJson(Map<String, dynamic> json) {
//    print(json);
    id = json['_id'];
    name = json['name'];
    price = json['price'] !=null ? double.parse(json['price'].toString()) : null;
    description = json['description'];
    parent = json['parent'];
    if (json['options'] != null) {
      options = List<ProductOption>();
      json['options'].forEach((v) {
        options.add( ProductOption.fromJson(v));
      });
    }
    variants = json['varient']!=null ? json['varient'].cast<Map<String,dynamic>>() : null;
//    if (json['varient'] != null) {
//      variants = List<Variant>();
//      json['varient'].forEach((v) {
//        variants.add( Variant.fromJson(v));
//      });
//    }
    if (json['image'] != null) {
      images = ImageModel.fromJson(json['image']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['parent'] = this.parent;
    data['varient'] = this.variants;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
//    if (this.variants != null) {
//      data['varient'] = this.options.map((v) => v.toJson()).toList();
//    }
    if (this.images != null) {
      data['image'] = this.images.serialize();
    }
    data['__v'] = this.iV;
    return data;
  }
}



