import 'package:haweyati/models/hive-models/customer/customer-model.dart';
import 'package:haweyati/services/haweyati-service.dart';

class AuthService extends HaweyatiService<Customer> {
  @override
  Customer parse(Map<String, dynamic> item) => Customer.fromJson(item);

  Future<dynamic> getProfile() {
    return this.getOne('auth/profile');
  }

  Future<Customer> getCustomer(String contact) {
    return this.getOne('customers/getprofile/$contact');
  }


}