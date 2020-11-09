import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/_new/_config.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:retrofit/http.dart';

part 'dumpsters_rest.g.dart';

@RestApi(baseUrl: apiUrl)
abstract class DumpstersRest {
  factory DumpstersRest() => _DumpstersRest(defaultDio);

  @GET('/dumpsters/available')
  Future<List<Dumpster>> get(@Query('city') String city);
}
