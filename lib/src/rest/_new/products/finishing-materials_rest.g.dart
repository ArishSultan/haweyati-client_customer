// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finishing-materials_rest.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _FinishingMaterialsRest implements FinishingMaterialsRest {
  _FinishingMaterialsRest(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'http://192.168.10.3:4000';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<List<FinishingMaterial>> get(supplier, parent) async {
    ArgumentError.checkNotNull(supplier, 'supplier');
    ArgumentError.checkNotNull(parent, 'parent');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'supplier': supplier,
      r'parent': parent
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/finishing-materials/available-supplier',
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
  Future<List<FinishingMaterialBase>> getCategories(supplier) async {
    ArgumentError.checkNotNull(supplier, 'supplier');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/finishing-materials/categories-supplier/$supplier',
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

  @override
  Future<List<Supplier>> getShops(city, lat, lng) async {
    ArgumentError.checkNotNull(city, 'city');
    ArgumentError.checkNotNull(lat, 'lat');
    ArgumentError.checkNotNull(lng, 'lng');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'city': city,
      r'lat': lat,
      r'lng': lng
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/suppliers/fm-suppliers',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => Supplier.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
