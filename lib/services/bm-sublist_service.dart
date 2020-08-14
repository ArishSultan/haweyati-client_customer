import 'package:haweyati/models/building-material_model.dart';
import 'package:haweyati/models/building-material_sublist.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BMSublistService extends HaweyatiService<BMProduct> {
  @override
  BMProduct parse(Map<String, dynamic> item) => BMProduct.fromJson(item);

  Future<List<BMProduct>> getBMSublist(String parentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString('city');
    return this.getAll('building-materials?city=$city&parent=$parentId');
  }

}