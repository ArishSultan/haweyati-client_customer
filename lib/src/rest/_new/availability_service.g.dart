// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _AvailabilityService implements AvailabilityService {
  _AvailabilityService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'http://192.168.18.4:4000';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<List<String>> getAvailableServices(city) async {
    ArgumentError.checkNotNull(city, 'city');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/suppliers/available/$city',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data.cast<String>();
    return value;
  }
}
