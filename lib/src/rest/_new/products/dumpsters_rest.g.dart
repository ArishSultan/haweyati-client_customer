// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dumpsters_rest.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _DumpstersRest implements DumpstersRest {
  _DumpstersRest(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'http://192.168.10.100:4000';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<List<Dumpster>> get(city) async {
    ArgumentError.checkNotNull(city, 'city');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'city': city};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/dumpsters/available',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => Dumpster.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
