import 'package:haweyati/src/common/models/json_serializable.dart';
import 'package:haweyati/src/models/order/order-location_model.dart';
import 'package:haweyati/src/models/payment_model.dart';
import 'package:haweyati/src/models/user_model.dart';
import 'package:hive/hive.dart';

import 'order-item_model.dart';

@HiveType(typeId: 0)
class Order extends HiveObject implements JsonSerializable {
  String id;
  String city;
  String note;
  double total;
  String number;
  String status;
  OrderType type;

  User customer;

  Payment payment;
  List<String> images;
  OrderLocation location;
  List<OrderItemHolder> items;

  DateTime createdAt;
  DateTime updatedAt;

  Order({
    this.city,
    this.note,
    this.type,
    this.items,
    this.images,
    this.status,
    this.location,
    this.customer,
    this.createdAt,
    this.updatedAt,
    this.payment,
    this.total
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      type: _typeFromString(json['service'])
      // items: json['items'].map((item) => )
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'note': note,
    'total': total,
    'status': status,
    'orderNo': number,
    'service': _typeToString(type),

    'items': items
        .map((e) => e.serialize())
        .toList(growable: false),

    'location': location.serialize(),

    'customer': customer.serialize(),
    'paymentType': payment.type,
    'paymentIntentId': payment.intentId,
  };

  @override Map<String, dynamic> serialize() => toJson();

  static String _typeToString(OrderType type) {
    switch (type) {
      case OrderType.dumpster: return 'Construction Dumpster';
      case OrderType.scaffolding: return 'Scaffolding';
      case OrderType.buildingMaterial: return 'Building Material';
      case OrderType.finishingMaterial: return 'Finishing Material';
    }

    throw 'Unknown type found $type';
  }
  static OrderType _typeFromString(String type) {
    switch (type) {
      case 'Scaffolding': return OrderType.scaffolding;
      case 'Building Material': return OrderType.buildingMaterial;
      case 'Finishing Material': return OrderType.finishingMaterial;
      case 'Construction Dumpster': return OrderType.dumpster;
    }

    throw 'Unknown type found $type';
  }
}

enum OrderType {
  dumpster,
  scaffolding,
  buildingMaterial,
  finishingMaterial
}
