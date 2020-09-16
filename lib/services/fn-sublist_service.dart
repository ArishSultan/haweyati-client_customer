import 'package:haweyati/models/finishing-product.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FINSublistService extends HaweyatiService<FinishingMaterial> {
  @override
  FinishingMaterial parse(Map<String, dynamic> item) => FinishingMaterial.fromJson(item);

  Future<List<FinishingMaterial>> getFinSublist(String parentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString('city');
    return this.getAll('finishing-materials?city=$city&parent=$parentId');
  }

  Future<List<FinishingMaterial>> search(String keyword) async {
    return this.getAll('finishing-materials/search?name=$keyword');
  }

}