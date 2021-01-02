import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/_new/_config.dart';
import 'package:haweyati_client_data_models/models/others/estimated-price_model.dart';
import 'package:retrofit/http.dart';
part 'estimated-price_service.g.dart';

@RestApi(baseUrl: apiUrl)
abstract class EstimatedPriceRest {
  factory EstimatedPriceRest() => _EstimatedPriceRest(defaultDio);

  @POST('/orders/estimate-price')
  Future<EstimatedPrice> getPrice(@Body() Map<String,dynamic> body);
}
