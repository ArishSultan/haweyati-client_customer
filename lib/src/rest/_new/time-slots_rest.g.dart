// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time-slots_rest.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class __TimeSlotsRest implements _TimeSlotsRest {
  __TimeSlotsRest(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'http://192.168.10.3:4000';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<List<TimeSlot>> getTimeSlots() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/time-slots',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => TimeSlot.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
