// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:haweyati/src/common/models/serializable.dart';
//
// void _printResponseCode(int status) {
//   print('ResponseText($status)');
// }
//
// /// TODO: Remove Dio completely and use native dart:io features.
// void _SendRequest_({
//   String url, /// TODO: Change this to [Uri]
//   RequestType type,
//   Serializable serializable,
//   Map<String, dynamic> query
// }) async {
//   final response = await Dio().get(url, queryParameters: query);
//
//   _mapCodeToStatus(response.statusCode);
// }
//
// class test {
//   test() {
//     // _$SendRequest_();
//   }
// }
//
// // import 'package:dio/dio.dart';
// // import 'package:haweyati/src/common/models/serializable.dart';
// // import 'package:haweyati/src/common/services/jwt-auth_service.dart';
// //
// // enum RequestType {
// //   get, post, put, patch, delete, head
// // }
// //
// // class ServiceConfiguration {
// //   final int port;
// //   final String host;
// //   final String scheme;
// //
// //   const ServiceConfiguration({
// //     this.port,
// //     this.host,
// //     this.scheme
// //   }): assert(port != null),
// //       assert(host != null),
// //       assert(scheme != null);
// //
// //   Uri createUri({String path, Map<String, dynamic> query}) {
// //     return Uri(
// //       host: host,
// //       port: port,
// //       path: path,
// //       scheme: scheme,
// //       queryParameters: query
// //     );
// //   }
// // }
// //
// // abstract class RestHttpService<T extends Serializable> {
// //   static ServiceConfiguration _config;
// //   static void configure({
// //     int port,
// //     String host,
// //     String scheme
// //   }) => _config = ServiceConfiguration(
// //     port: port,
// //     host: host,
// //     scheme: scheme
// //   );
// //
// //   $get({String path, Map<String, dynamic> query});
// //   $put({String path, Serializable payload});
// //   $post({String path, Serializable payload});
// //   $patch({String path, Serializable payload});
// //   $delete();
// //
// //   $raw({String path, Serializable payload, RequestType type});
// //
// //   factory RestHttpService.create({String endpoint, T Function(Map<String, dynamic>) parser}) {
// //     if (_config != null) {
// //       return _RestHttpServiceImpl(endpoint, parser);
// //     } else {
// //       /// TODO: Throw a Proper Error
// //       throw Error();
// //     }
// //   }
// // }
// //
// // class _RestHttpServiceImpl<T extends Serializable> implements RestHttpService<T> {
// //   final String _endpoint;
// //   final T Function(Map<String, dynamic>) _parser;
// //
// //   const _RestHttpServiceImpl(
// //     this._endpoint, this._parser
// //   );
// //
// //   @override
// //   $delete() {
// //   }
// //
// //   @override
// //   $get({String path, Map<String, dynamic> query}) async {
// //     final uri = RestHttpService._config.createUri(path: path);
// //     final resp = _parseResponse(await Dio().getUri(uri), _parser);
// //
// //     if (resp is List) {
// //       throw 'A List was received, Use `\$getMany` instead';
// //     }
// //
// //     return resp;
// //   }
// //
// //   @override
// //   $put({String path, Serializable payload}) {
// //   }
// //
// //   @override
// //   $patch({String path, Serializable payload}) {
// //   }
// //
// //   @override
// //   $post({String path, Serializable payload}) {
// //   }
// //
// //   @override
// //   $raw({
// //     String path,
// //     RequestType type,
// //     Serializable payload,
// //     Map<String, dynamic> query,
// //   }) {
// //     return _request(
// //       path: path,
// //       type: type,
// //       query: query,
// //       payload: payload,
// //     );
// //   }
// //
// //   _request({
// //     String path,
// //     RequestType type,
// //     Serializable payload,
// //     Map<String, dynamic> query,
// //   }) async {
// //     final token = await JwtAuthService.create().token;
// //
// //     final _dio = Dio(BaseOptions(
// //       headers: { 'Authorization': 'Bearer $token' }
// //     ));
// //
// //     if (path[0] != '/') {
// //       path = '$_endpoint/$path';
// //     }
// //
// //     print(path);
// //     switch (type) {
// //       case RequestType.get:
// //         return _parseResponse(
// //           await _dio.requestUri(
// //             RestHttpService._config.createUri(
// //               path: path, query: query
// //             ),
// //             options: Options(method: 'GET')
// //           ),
// //           _parser
// //         );
// //       case RequestType.post:
// //         return _parseResponse(
// //           await _dio.requestUri(
// //             RestHttpService._config.createUri(
// //               path: path, query: query
// //             ),
// //             options: Options(method: 'POST')
// //           ),
// //           _parser
// //         );
// //       case RequestType.put:
// //         return _parseResponse(
// //           await _dio.requestUri(
// //             RestHttpService._config.createUri(
// //               path: path, query: query
// //             ),
// //             options: Options(method: 'PUT')
// //           ),
// //           _parser
// //         );
// //       case RequestType.patch:
// //         return _parseResponse(
// //           await _dio.requestUri(
// //             RestHttpService._config.createUri(
// //               path: path, query: query
// //             ),
// //             options: Options(method: 'PATCH')
// //           ),
// //           _parser
// //         );
// //       case RequestType.delete:
// //         return _parseResponse(
// //           await _dio.requestUri(
// //             RestHttpService._config.createUri(
// //               path: path, query: query
// //             ),
// //             options: Options(method: 'DELETE')
// //           ),
// //           _parser
// //         );
// //       case RequestType.head:
// //         return _parseResponse(
// //           await _dio.requestUri(
// //             RestHttpService._config.createUri(
// //               path: path, query: query
// //             ),
// //             options: Options(method: 'HEAD')
// //           ),
// //           _parser
// //         );
// //     }
// //   }
// // }
// //
// // Future<Response> _sendRequest({
// //   String path,
// //   RequestType type,
// //   Map<String, dynamic> query
// // }) async {
// //   final dio = Dio();
// //
// //   switch (type) {
// //     case RequestType.get: return dio.get(path, queryParameters: query);
// //     case RequestType.post: return dio.post(path, queryParameters: query);
// //     case RequestType.put: return dio.put(path, queryParameters: query);
// //     case RequestType.patch: return dio.patch(path, queryParameters: query);
// //     case RequestType.delete: return dio.delete(path, queryParameters: query);
// //     case RequestType.head: return dio.head(path, queryParameters: query);
// //     default: return null;
// //   }
// // }
// //
// // void _checkStatusCode(int statusCode) {
// //   switch (statusCode) {
// //     case 200:
// //       print('Success');
// //       break;
// //     case 401:
// //       print('Un Authorized');
// //       break;
// //   }
// // }
// //
// // dynamic makeRequest(String path, RequestType type, Map<String, dynamic> query) async {
// //   final response = await _sendRequest(path: path, query: query, type: type);
// //   _checkStatusCode(response.statusCode);
// //   return response.data;
// // }
// //
// // _parseResponse<T>(Response response, T Function(Map<String, dynamic>) parser) {
// //   print(response.data);
// //
// //   if (response.data is Map) {
// //     return parser(response.data);
// //   } else if (response.data is List<Map>) {
// //     return response.data.map((item) => parser(item)).toList();
// //   } else {
// //     throw 'Unknown response type';
// //   }
// // }
