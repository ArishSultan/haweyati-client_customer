// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _OrdersService implements OrdersService {
  _OrdersService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'http://192.168.18.4:4000';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<Order<OrderableProduct<Purchasable>>> placeOrder(order) async {
    ArgumentError.checkNotNull(order, 'order');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(order?.toJson() ?? <String, dynamic>{});
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/orders/dummy',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = Order<OrderableProduct<Purchasable>>.fromJson(_result.data);
    return value;
  }

  @override
  Future<void> cancelOrder(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    await _dio.request<void>('/orders/cancel/$id',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PATCH',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    return null;
  }

  @override
  Future<void> processPayment(body) async {
    ArgumentError.checkNotNull(body, 'body');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body ?? <String, dynamic>{});
    _data.removeWhere((k, v) => v == null);
    await _dio.request<void>('/orders/process-payment',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PATCH',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    return null;
  }

  @override
  Future<List<Order<OrderableProduct<Purchasable>>>> orders(
      {id, orderId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'customer': id,
      r'name': orderId
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/orders/dummy',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => Order<OrderableProduct<Purchasable>>.fromJson(
            i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
