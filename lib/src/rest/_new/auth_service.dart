import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:retrofit/http.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/_new/_config.dart';
import 'package:haweyati_client_data_models/data.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: '$apiUrl')
abstract class _AuthService {
  factory _AuthService(Dio dio) => __AuthService(dio);

  @POST('/auth/sign-in')
  Future<SignInResponse> _signIn(@Body() SignInRequest data);

  @GET('/auth/profile')
  Future<Customer> user();

  @GET('/customers/{id}')
  Future<Customer> _refreshCustomer(@Path('id') String customer);

  @POST('/customers/guest')
  Future<Customer> _createGuest(@Body() Customer customer);
  @POST('/customers/convert-guest')
  Future<Customer> _registerGuest(@Body() Customer customer);

  @POST('/auth/sign-out')
  Future _signOut();

  @POST('/customers')
  Future<Customer> _registerCustomer(@Body() Customer customer);

  @GET('/persons/contact/{contact}')
  Future<Profile> getProfile(@Path('contact') String contact);

  @GET('/customers/getprofile/{number}')
  Future<Customer> getCustomer({@Path('number') String number});

  /// Create New Customer;
  @POST('/customers/new')
  Future<void> _createNewCustomer(@Body() Customer customer);
}

class AuthService {
  static final _service = _AuthService(defaultDio);

  static Future<Profile> getProfile(String contact, [bool flag = false]) async {
    try {
      // if (flag) {
      //   return (await _service.getProfile(contact)).profile;
      // } else {
        return (await _service.getProfile(contact));
      // }
    } on DioError catch (_) {
      return null;
    }
  }

  static Future<Customer> getCustomer(String contact) =>
      _service.getCustomer(number: contact);

  static Future<void> linkProfile(Customer customer) =>
      _service._registerCustomer(customer);
  static Future<Customer> registerGuest(Customer customer) =>
      _service._registerGuest(customer);
  static Future<Customer> createGuest(Customer customer) =>
      _service._createGuest(customer);
  static Future<void> registerNewCustomer(Customer customer) =>
      _service._createNewCustomer(customer);

  static Future<Customer> refreshCustomerProfile() =>
      _service._refreshCustomer(AppData().user.id);

  static Future<void> signIn(SignInRequest data) async {
    final resp = await _service._signIn(data);
    AppData().accessToken = resp.accessToken;

    final profile = (await _service.user()).profile;
    AppData().user = await _service.getCustomer(number: profile.contact);
  }

  static Future<void> signOut() async {
    try {
      await _service._signOut();
    } catch (err) {}
    await AppData().signOut();
  }

  static Future<List> prepareForRegistration(
    BuildContext context,
    String contact,
  ) async {
    final profile = await getProfile(contact);

    if (profile != null) {
      if (profile.hasScope('guest')) {
        return [CustomerRegistrationType.fromGuest, profile];
      } else if (profile.hasScope('customer')) {
        return [CustomerRegistrationType.noNeed, profile];
      } else {
        return [CustomerRegistrationType.fromExisting, profile];
      }
    } else {
      return [CustomerRegistrationType.new_, null];
    }
  }
}

enum CustomerRegistrationType { new_, noNeed, fromGuest, fromExisting }
