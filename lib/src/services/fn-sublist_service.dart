import 'package:haweyati/src/models/services/finishing-material/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'haweyati-service.dart';

class FinishingMaterialsService extends HaweyatiService<FinishingMaterial> {
  @override
  FinishingMaterial parse(Map<String, dynamic> item) => FinishingMaterial.fromJson(item);

  Future<List<FinishingMaterial>> getFinSublist(String parentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString('city');
    return this.getAll('finishing-materials/available?city=$city&parent=$parentId');
  }

  Future<List<FinishingMaterial>> search(String keyword) async {
    return this.getAll('finishing-materials/search?name=$keyword');
  }
}