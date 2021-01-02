import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/_new/_config.dart';
import 'package:haweyati_client_data_models/models/products/delivery-vehicle_model.dart';
import 'package:retrofit/http.dart';

part 'delivery-vehicle_rest.g.dart';

@RestApi(baseUrl: apiUrl)
abstract class DeliveryVehicleRest {
  factory DeliveryVehicleRest() => _DeliveryVehicleRest(defaultDio);

  @GET('/vehicle-type')
  Future<List<DeliveryVehicle>> get();
}
