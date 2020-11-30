// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finishing-materials_rest.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _FinishingMaterialsRest implements FinishingMaterialsRest {
  _FinishingMaterialsRest(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'http://178.128.16.246:4000';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<List<FinishingMaterial>> get(city, parent) async {
    ArgumentError.checkNotNull(city, 'city');
    ArgumentError.checkNotNull(parent, 'parent');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'city': city, r'parent': parent};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/finishing-materials/available',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) =>
            FinishingMaterial.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<FinishingMaterial>> search(keyword) async {
    ArgumentError.checkNotNull(keyword, 'keyword');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'name': keyword};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/finishing-materials/search',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) =>
            FinishingMaterial.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<FinishingMaterialBase>> getCategories() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/finishing-material-category',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) =>
            FinishingMaterialBase.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
