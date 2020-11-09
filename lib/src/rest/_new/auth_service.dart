import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/_new/_config.dart';
import 'package:haweyati_client_data_models/data.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: '$apiUrl/auth')
abstract class _AuthService {
  factory _AuthService(Dio dio) => __AuthService(dio);

  @POST('/sign-in')
  Future<SignInResponse> _signIn(@Body() SignInRequest data);

  @GET('/profile')
  Future<Customer> user();

  @POST('/customers')
  Future<Customer> _createGuest(@Body() Customer customer);

  @POST('/sign-out')
  Future _signOut();

  @POST('/customers')
  Future<void> _registerCustomer(@Body() Customer customer);

  @GET('/persons/contact/{contact}')
  Future<Profile> getProfile(@Path('contact') String contact);
}

class AuthService {
  static final _service = _AuthService(defaultDio);

  static Future<Profile> getProfile(String contact) =>
      _service.getProfile(contact);

  static Future<void> registerGuest(Customer customer) =>
      _service._createGuest(customer);
  static Future<void> registerCustomer(Customer customer) =>
      _service._registerCustomer(customer);

  static Future<void> signIn(SignInRequest data) async {
    final resp = await _service._signIn(data);
    AppData().accessToken = resp.accessToken;

    final user = await _service.user();
    AppData().user = user;
  }

  static Future<void> signOut() async {
    await _service._signOut();
    AppData().accessToken = null;
  }
}
