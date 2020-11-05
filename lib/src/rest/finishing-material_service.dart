import 'package:haweyati/src/models/services/finishing-material/category_model.dart';

import 'haweyati-service.dart';

class FinishingMaterialService extends HaweyatiService<FinishingMaterialCategory> {
  @override
  FinishingMaterialCategory parse(Map<String, dynamic> item) => FinishingMaterialCategory.fromJson(item);

  Future<List<FinishingMaterialCategory>> getFinishingMaterial() {
    return this.getAll('finishing-material-category');
  }

}