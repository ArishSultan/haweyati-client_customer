import 'package:dio/dio.dart';
import 'package:haweyati/src/models/_new/customer_model.dart';
import 'package:retrofit/http.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/_new/_config.dart';
import 'package:haweyati/src/models/_new/auth/sign-in_model.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: '$apiUrl/auth')
abstract class _AuthService {
  factory _AuthService(Dio dio) => __AuthService(dio);

  @POST('/sign-in')
  Future<SignInResponse> _signIn(@Body() SignInRequest data);

  @GET('/profile')
  Future<$Customer> user();

  @POST('/sign-out')
  Future _signOut();
}

class AuthService {
  static final _service = _AuthService(defaultDio);

  static Future<void> signIn(SignInRequest data) async {
    final resp = await _service._signIn(data);
    AppData.instance().accessToken = resp.accessToken;

    final user = await _service.user();
    await AppData.instance().setUser(user);
  }

  static Future<void> signOut() async {
    await _service._signOut();
    AppData.instance().accessToken = null;
  }
}