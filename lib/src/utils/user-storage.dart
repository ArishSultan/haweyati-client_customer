import 'dart:async';

import 'package:haweyati/src/common/services/jwt-auth_service.dart';
import 'package:haweyati/src/models/user_model.dart';
import 'package:hive/hive.dart';

class UserStorage extends JwtStorage<User> {
  User customer;

  @override
  FutureOr<void> clear() async {
    await Hive.box('customers').clear();
    await Hive.box('customers').deleteFromDisk();
  }

  @override
  FutureOr<User> read() {
    try {
      return Hive.box('customers').values.first;
    } catch(e) {
      return null;
    }
  }

  @override
  FutureOr<void> write(User customer) {
    Hive.box('customers').add(customer);
    customer.save();
  }

  @override
  FutureOr<void> refreshCache() {
  }
}