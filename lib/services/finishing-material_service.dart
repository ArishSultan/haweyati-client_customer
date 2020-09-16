import 'package:haweyati/src/models/services/building-material/category_model.dart';
import 'package:haweyati/models/finishing-material_category.dart';
import 'package:haweyati/services/haweyati-service.dart';

class FinishingMaterialService extends HaweyatiService<FinishingMaterialCategory> {
  @override
  FinishingMaterialCategory parse(Map<String, dynamic> item) => FinishingMaterialCategory.fromJson(item);

  Future<List<FinishingMaterialCategory>> getFinishingMaterial() {
    return this.getAll('finishing-material-category');
  }

}