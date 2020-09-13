import '../src/models/image_model.dart';

class BuildingMaterials {
  String id;
  String name;
  String description;
  ImageModel image;
  int iV;

  BuildingMaterials(
      {this.id, this.name, this.description, this.image, this.iV});

  BuildingMaterials.fromJson(Map<String, dynamic> json) {
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
    data['image'] = this.image;
    data['__v'] = this.iV;
    return data;
  }
}