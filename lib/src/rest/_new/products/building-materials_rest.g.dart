// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building-materials_rest.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _BuildingMaterialsRest implements BuildingMaterialsRest {
  _BuildingMaterialsRest(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'http://192.168.18.4:4000';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<List<BuildingMaterial>> get(city, parent) async {
    ArgumentError.checkNotNull(city, 'city');
    ArgumentError.checkNotNull(parent, 'parent');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'city': city, r'parent': parent};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/building-materials',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map(
            (dynamic i) => BuildingMaterial.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<BuildingMaterialBase>> getCategories() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/building-material-category',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) =>
            BuildingMaterialBase.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<BuildingMaterialBase>> getSubCategories(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/building-material-sub-category/getbyparent/$id',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) =>
            BuildingMaterialBase.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
