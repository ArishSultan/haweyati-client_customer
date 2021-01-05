import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/_new/_config.dart';
import 'package:haweyati_client_data_models/models/products/single-scaffolding_model.dart';
import 'package:retrofit/http.dart';

part 'single-scaffolding_rest.g.dart';

@RestApi(baseUrl: apiUrl)
abstract class SingleScaffoldingRest {
  factory SingleScaffoldingRest() => _SingleScaffoldingRest(defaultDio);

  @GET('/scaffoldings/available')
  Future<List<SingleScaffolding>> get(@Query('city') String city);
}
