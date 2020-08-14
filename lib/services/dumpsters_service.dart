import 'package:haweyati/models/dumpster_model.dart';
import 'package:haweyati/services/haweyati-service.dart';

class DumpstersService extends HaweyatiService<Dumpster> {
  @override
  Dumpster parse(Map<String, dynamic> item) => Dumpster.fromJson(item);

  Future<List<Dumpster>> getDumpsters(String city) {
    return this.getAll('dumpsters/available?city=$city');
  }

}