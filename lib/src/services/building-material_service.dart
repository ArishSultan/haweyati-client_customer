import 'package:haweyati/src/models/services/building-material/category_model.dart';

import 'haweyati-service.dart';

class BuildingMaterialService extends HaweyatiService<BuildingMaterialCategory> {
  @override
  BuildingMaterialCategory parse(Map<String, dynamic> item) => BuildingMaterialCategory.fromJson(item);

  Future<List<BuildingMaterialCategory>> getBuildingMaterials() {
    return this.getAll('building-material-category');
  }
}