import 'package:dio/dio.dart';
import 'haweyati-service.dart';
import 'package:haweyati/src/const.dart';

class AvailabilityService extends HaweyatiService<List<String>> {
  Future<List<String>> getAvailableServices(String city) async {
    Response res = await dio.get('$apiUrl/suppliers/available/$city');
    print("$apiUrl/suppliers/available/$city");
    print(city);
    return ((res.data) as List).map((item) => item.toString()).toList();
  }

  @override
  List<String> parse(Map<String, dynamic> item) {
    return null;
  }
}