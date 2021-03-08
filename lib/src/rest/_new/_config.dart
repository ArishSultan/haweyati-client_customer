import 'dart:io';

import 'package:dio/dio.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

export 'package:dio/dio.dart';

final defaultDio = Dio(BaseOptions())
  ..interceptors.addAll([_AuthInterceptor(), PrettyDioLogger(requestBody: true, requestHeader: true)]);

class _AuthInterceptor implements Interceptor {
  @override
  Future onError(DioError err) async => err;

  @override
  Future onRequest(RequestOptions options) async {
    final _appData = AppData();
    if (_appData.accessToken != null) {
      options.headers[HttpHeaders.authorizationHeader] =
          'Bearer ${_appData.accessToken}';
    }

    return options;
  }

  @override
  Future onResponse(Response<dynamic> response) async => response;
}
