import 'package:dio/dio.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/_new/_config.dart';
import 'package:retrofit/retrofit.dart';

part 'availability_service.g.dart';

@RestApi(baseUrl: apiUrl)
abstract class AvailabilityService {
  factory AvailabilityService() => _AvailabilityService(defaultDio);

  @GET('/suppliers/available/{city}')
  Future<List<String>> getAvailableServices(@Path('city') String city);
}