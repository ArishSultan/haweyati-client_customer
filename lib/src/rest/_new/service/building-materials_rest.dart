import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/models/services/building-material/category_model.dart';
import 'package:haweyati/src/models/services/building-material/model.dart';
import 'package:retrofit/http.dart';

@RestApi(baseUrl: apiUrl)
abstract class BuildingMaterialsRest {
  @GET('/building-materials')
  Future<List<BuildingMaterial>> get(
    @Query('city') String city,
    @Query('parent') String parent,
  );

  @GET('/building-material-category')
  Future<List<BuildingMaterialCategory>> getCategories();
}
