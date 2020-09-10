import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haweyati/src/common/services/jwt-auth_service.dart';

class TokenStorage extends JwtStorage<String> {
  String _token;

  @override
  FutureOr<void> clear() async =>
    (await SharedPreferences.getInstance()).remove('access_token');

  @override
  FutureOr<String> read() async => _token;

  @override
  FutureOr<void> write(String token) async {
    _token = token;
    (await SharedPreferences.getInstance()).setString('access_token', token);
  }

  @override
  FutureOr<void> refreshCache() async =>
      _token = (await SharedPreferences.getInstance()).getString('access_token');
}