import 'package:haweyati/src/models/services/building-material/category_model.dart';
import 'package:haweyati/src/models/services/building-material/model.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BMSublistService extends HaweyatiService<BuildingMaterial> {
  @override
  BuildingMaterial parse(Map<String, dynamic> item) => BuildingMaterial.fromJson(item);

  Future<List<BuildingMaterial>> getBMSublist(String parentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString('city');
    return this.getAll('building-materials?city=$city&parent=$parentId');
  }

}