import 'package:hive/hive.dart';

class CreditCard extends HiveObject {
  String number;
  String ownerName;
  String securityCode;

  DateTime expiresAt;

  CreditCard({
    this.number,
    this.ownerName,
    this.securityCode,
    this.expiresAt
  });
}
