import 'package:haweyati/src/models/dumpster_model.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/common/services/rest-http_service.dart';

class DumpstersService extends HaweyatiService<Dumpster> {
  @override
  Dumpster parse(Map<String, dynamic> item) => Dumpster.fromJson(item);

  Future<List<Dumpster>> getDumpsters(String city) {
      return this.getAll('dumpsters/available?city=$city');
  }

}
//
// class _DumpstersService {
//   final RestHttpService _service = RestHttpService.create(
//     endpoint: 'dumpsters'
//   );
//
//   Future<List<Dumpster>> getDumpsters({String city}) {
//     _service.$get(path: 'available', );
//   }
// }