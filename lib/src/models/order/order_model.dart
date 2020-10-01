import 'package:haweyati/src/common/models/json_serializable.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/order/building-material/order-item_model.dart';
import 'package:haweyati/src/models/order/dumpster/order-item_model.dart';
import 'package:haweyati/src/models/order/finishing-material/order-item_model.dart';
import 'package:haweyati/src/models/order/order-location_model.dart';
import 'package:haweyati/src/models/payment_model.dart';
import 'package:haweyati/src/models/user_model.dart';
import 'package:hive/hive.dart';

import 'order-item_model.dart';

@HiveType(typeId: 0)
class Order extends HiveObject implements JsonSerializable {
  String id;

  int status;
  String city;
  String note;
  double total;
  String number;
  OrderType type;

  User customer;

  Payment payment;
  List<String> images;
  OrderLocation location;
  List<OrderItemHolder> items;

  DateTime createdAt;
  DateTime updatedAt;

  Order(this.type, {
    this.city,
    this.note,
    this.items,
    this.number,
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
    OrderItem Function(Map<String, dynamic>) _parser = null;
    final type = _typeFromString(json['service']);

    switch (type) {
      case OrderType.dumpster:
        _parser = DumpsterOrderItem.fromJson;
        break;
      case OrderType.scaffolding:
        // TODO: Handle this case.
        break;
      case OrderType.buildingMaterial:
        _parser = BuildingMaterialOrderItem.fromJson;
        break;
      case OrderType.finishingMaterial:
        _parser = FinishingMaterialOrderItem.fromJson;
        break;
    }

    return Order(_typeFromString(json['service']),
      note: json['note'],
      city: json['city'],
      total: json['total']?.toDouble(),
      status: json['status'],
      number: json['orderNo'],
      payment: Payment.fromJson(/*json['payment'] ?? */json),

      customer: json['customer'] is String
          ? AppData.instance().user
          : User.fromJson(json['customer']),

      location: OrderLocation.fromJson(json['dropoff']),

      items: (json['items'] as List)
        .map((item) => OrderItemHolder(
          supplier: item['supplier'],
          subtotal: item['subtotal']?.toDouble(),

          item: _parser != null ? _parser(item['item']) : null
        ))
        .toList(growable: false),
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

    'customer': AppData.instance().user.serialize(),
    'paymentType': payment?.type,
    'paymentIntentId': payment?.intentId,
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