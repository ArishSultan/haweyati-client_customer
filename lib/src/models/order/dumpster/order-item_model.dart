import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:haweyati/src/models/services/dumpster/model.dart';
import 'package:hive/hive.dart';

part 'order-item_model.g.dart';

@HiveType(typeId: 51)
class DumpsterOrderItem extends OrderItem<Dumpster> {
  @HiveField(1) int extraDays;
  @HiveField(2) double extraDaysPrice;
  @HiveField(3) int qty;


  DumpsterOrderItem({
    Dumpster product,
    this.qty = 1,
    this.extraDays = 0,
    this.extraDaysPrice = 0
  }): super(product);

  static DumpsterOrderItem fromJson(Map<String, dynamic> json) {
    return DumpsterOrderItem(
      product: Dumpster.fromJson(json['product']),
      qty: json['qty'],
      extraDays: json['extraDays'],
      extraDaysPrice: json['extraDaysPrice']?.toDouble()
    );
  }

  @override
  Map<String, dynamic> serialize() => super.serialize()
      ..addAll({
        'qty': qty,
        'extraDays': extraDays,
        'extraDaysPrice': extraDaysPrice
      });
}