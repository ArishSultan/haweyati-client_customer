import 'package:dio/dio.dart';
import 'package:haweyati/src/common/models/serializable.dart';
import 'package:haweyati/src/common/services/http/basics/request-type.dart';
import 'package:haweyati/src/common/services/jwt-auth_service.dart';

Function _resolveRequestType(RequestType type) {
  switch (type) {
    case RequestType.get: return Dio().getUri;
    case RequestType.post: return Dio().postUri;
    case RequestType.patch: return Dio().patchUri;
  }

  return null;
}

Future<Response> request({
  Uri uri,
  RequestType type,
  Serializable data
}) async {
  assert(uri != null, 'Uri must be provided');
  assert(type != null, 'Type must be provided');

  Response response;

  if (type != RequestType.get) {
    print(await JwtAuthService.create().token);
    response = await _resolveRequestType(type)
      (uri, data: data?.serialize(), options: Options(
      headers: { 'Authorization': 'Bearer ${await JwtAuthService.create().token}' }
    ));
  } else {
    response = await _resolveRequestType(type)(uri, options: Options(
      headers: { 'Authorization': 'Bearer ${await JwtAuthService.create().token}' }
    ));
  }

  /// Handle Status Codes.
  /// handleStatusCode(response.statusCode);

  return response;
}
