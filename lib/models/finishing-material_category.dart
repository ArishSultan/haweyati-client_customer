import '../src/models/image_model.dart';

class FinishingMaterialCategory {
  String id;
  String name;
  String description;
  ImageModel image;
  int iV;

  FinishingMaterialCategory(
      {this.id, this.name, this.description, this.image, this.iV});

  FinishingMaterialCategory.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    description = json['description'];
    image = ImageModel.fromJson(json['image']);
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['__v'] = this.iV;
    return data;
  }
}