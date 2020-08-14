import 'package:haweyati/models/finishing-product.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FINSublistService extends HaweyatiService<FinProduct> {
  @override
  FinProduct parse(Map<String, dynamic> item) => FinProduct.fromJson(item);

  Future<List<FinProduct>> getFinSublist(String parentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString('city');
    return this.getAll('finishing-materials?city=$city&parent=$parentId');
  }

  Future<List<FinProduct>> search(String keyword) async {
    return this.getAll('finishing-materials/search?name=$keyword');
  }

}