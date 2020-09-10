import '../src/models/image_model.dart';

class BuildingMaterials {
  String sId;
  String name;
  String description;
  ImageModel image;
  int iV;

  BuildingMaterials(
      {this.sId, this.name, this.description, this.image, this.iV});

  BuildingMaterials.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    image = ImageModel.fromJson(json['image']);
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['__v'] = this.iV;
    return data;
  }
}