import 'package:dio/dio.dart';
import 'package:haweyati/src/common/models/serializable.dart';
import 'package:haweyati/src/common/services/http/basics/http-utils.dart';
import 'package:haweyati/src/common/services/http/basics/request-type.dart';

class _EasyRestConfigurations {
  final int port;
  final String host;
  final String scheme;

  _EasyRestConfigurations({
    this.port,
    this.host,
    this.scheme,
  }): assert(port != null, 'Port number was not provided'),
      assert(host != null, 'Hostname was not provided'),
      assert(scheme != null, 'Scheme was not provided');

  createUri(String path, Map<String, dynamic> query) => Uri(
    host: host,
    path: path,
    port: port,
    scheme: scheme,
    queryParameters: query
  );
}

abstract class EasyRest {
  static _EasyRestConfigurations _config;
  static configure({
    int port = 80,
    String host,
    String scheme = 'http',
  }) => _config = _EasyRestConfigurations(
    port: port, host: host, scheme: scheme,
  );

  $delete({String route, Map<String, dynamic> query, Serializable data});
  $getAll({String endpoint, Map<String, dynamic> query});
  $getOne({String route, Map<String, dynamic> query});
  $patch({String route, Map<String, dynamic> query, Serializable data});
  $post({String endpoint, Map<String, dynamic> query, Serializable payload});
  $raw({String route, Map<String, dynamic> query, RequestType type, Serializable data});

  factory EasyRest({String endpoint, Function parser}) {
    return _EasyRestImpl(endpoint, parser);
  }
}

class _EasyRestImpl implements EasyRest {
  Function _parser;
  String _endpoint;

  _EasyRestImpl(String endpoint, this._parser): _endpoint = endpoint?.replaceAll('/', '');


  @override
  $delete({String route, Map<String, dynamic> query, Serializable<dynamic> data}) {
  }

  @override
  $getAll({String endpoint, Map<String, dynamic> query}) async {
    final data = await _request(
      query: query,
      type: RequestType.get,
      route: _resolveRoute(endpoint),
    );

    if (data is List) {
      return data/*.map((e) => _parser(e)).toList()*/;
    } else if (data is Map) {
      print('Use Get one for better support');
    }
  }

  @override
  $getOne({
    String route = '',
    Map<String, dynamic> query
  }) async {
    final data = await _request(
      query: query,
      type: RequestType.get,
      route: _resolveRoute(route),
    );

    if (data is List) {
      print('Use Get All for better support');
    } else if (data is Map) {
      return _parser(data);
    }
  }

  @override
  $patch({String route, Map<String, dynamic> query, Serializable<dynamic> data}) {
  }

  @override
  $post({String endpoint, Map<String, dynamic> query, Serializable<dynamic> payload}) {
    return _request(route: _resolveRoute(endpoint), query: query, data: payload, type: RequestType.post);
  }

  @override
  $raw({String route, Map<String, dynamic> query, RequestType type, Serializable<dynamic> data}) {
    return _request(route: _resolveRoute(route), query: query, data: data, type: type);
  }

  String _resolveRoute(String route) {
    if (route.startsWith('/') || _endpoint == null) {
      return route;
    }

    return '$_endpoint/$route';
  }

  static _request({
    String route,
    Map<String, dynamic> query,
    RequestType type,
    Serializable<dynamic> data
  }) async {
    print(EasyRest._config.createUri(route, query));
    final response = await request(
      data: data,
      type: type,
      uri: EasyRest._config.createUri(route, query)
    );

    return _analyzeResponse(response);
  }
  static _analyzeResponse(Response response) {
    print('here');
    print(response.data);

    final type = response.headers['content-type'];
    print(type);
    if (type == null) return null;

    if (type[0] == Headers.jsonContentType) {
      return response.data;
    } else {
      throw 'Unsupported Format found ${response.headers['content-type']}';
    }
  }
}
