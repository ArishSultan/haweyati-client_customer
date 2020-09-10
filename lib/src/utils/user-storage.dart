import 'dart:async';

import 'package:haweyati/models/hive-models/customer/customer-model.dart';
import 'package:haweyati/src/common/services/jwt-auth_service.dart';
import 'package:hive/hive.dart';

class UserStorage extends JwtStorage<Customer> {
  Customer customer;

  @override
  FutureOr<void> clear() async {
    await Hive.box('customers').clear();
    await Hive.box('customers').deleteFromDisk();
  }

  @override
  FutureOr<Customer> read() {
    try {
      return Hive.box('customers').values.first;
    } catch(e) {
      return null;
    }
  }

  @override
  FutureOr<void> write(Customer customer) {
    Hive.box('customers').add(customer);
    customer.save();
  }

  @override
  FutureOr<void> refreshCache() {
  }
}