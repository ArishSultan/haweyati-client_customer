import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/_new/_config.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:haweyati_client_data_models/models/user/supplier_model.dart';
import 'package:retrofit/retrofit.dart';
part 'finishing-materials_rest.g.dart';

@RestApi(baseUrl: apiUrl)
abstract class FinishingMaterialsRest {
  factory FinishingMaterialsRest() => _FinishingMaterialsRest(defaultDio);

  @GET('/finishing-materials/available')
  Future<List<FinishingMaterial>> get(
    @Query('city') String city,
    @Query('parent') String parent,
  );

  @GET('/finishing-materials/search')
  Future<List<FinishingMaterial>> search(@Query('name') String keyword);

  @GET('/finishing-materials/categories-supplier/{id}')
  Future<List<FinishingMaterialBase>> getCategories(@Path('id') String supplier);

  @GET('/suppliers/fm-suppliers')
  Future<List<Supplier>> getShops(@Query('city') String city,
      @Query('lat') double lat,
      @Query('lng') double lng,);
}
