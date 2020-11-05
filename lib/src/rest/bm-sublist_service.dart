import 'package:haweyati/src/models/services/building-material/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data.dart';
import 'haweyati-service.dart';

class BMSublistService extends HaweyatiService<BuildingMaterial> {
  @override
  BuildingMaterial parse(Map<String, dynamic> item) => BuildingMaterial.fromJson(item);

  Future<List<BuildingMaterial>> getBMSublist(String parentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString('city');

    final list = await this.getAll('building-materials?city=$city&parent=$parentId');

    list.forEach((item) {
      item.pricing.first = item.pricing
          .firstWhere((element) => element.city == AppData.instance().city);
    });

    return list;
  }

}