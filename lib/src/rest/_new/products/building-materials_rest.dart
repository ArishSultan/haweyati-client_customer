import 'package:retrofit/http.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/_new/_config.dart';
import 'package:haweyati_client_data_models/data.dart';

part 'building-materials_rest.g.dart';

@RestApi(baseUrl: apiUrl)
abstract class BuildingMaterialsRest {
  factory BuildingMaterialsRest() => _BuildingMaterialsRest(defaultDio);

  @GET('/building-materials')
  Future<List<BuildingMaterial>> get(
    @Query('city') String city,
    @Query('parent') String parent,
  );

  @GET('/building-material-category')
  Future<List<BuildingMaterialBase>> getCategories();
}
