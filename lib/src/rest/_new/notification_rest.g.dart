// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_rest.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _NotificationRest extends NotificationRest {
  _NotificationRest(this._dio, {this.baseUrl}) : super._() {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'http://192.168.10.100:4000';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<List<NotificationRequest>> _get(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/fcm/get-unseen/$id',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) =>
            NotificationRequest.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
