import 'package:haweyati/src/models/user_model.dart';

import 'haweyati-service.dart';

class AuthService extends HaweyatiService<User> {
  @override
  User parse(Map<String, dynamic> item) => User.fromJson(item);

  Future<dynamic> getProfile() => this.getOne('auth/profile');

  Future<User> getCustomer(String contact) =>
    this.getOne('customers/getprofile/$contact');
}