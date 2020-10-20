import 'package:haweyati/src/common/models/json_serializable.dart';
import 'package:haweyati/src/common/models/serializable.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/order/building-material/order-item_model.dart';
import 'package:haweyati/src/models/order/dumpster/order-item_model.dart';
import 'package:haweyati/src/models/order/finishing-material/order-item_model.dart';
import 'package:haweyati/src/models/order/order-location_model.dart';
import 'package:haweyati/src/models/order/scaffoldings/order-item_model.dart';
import 'package:haweyati/src/models/payment_model.dart';
import 'package:haweyati/src/models/user_model.dart';
import 'package:haweyati/src/ui/pages/orders/my-orders_page.dart';
import 'package:hive/hive.dart';

import 'order-item_model.dart';

class OrderImage implements Serializable<Map<String, dynamic>> {
  String sort;
  String name;

  OrderImage({
    this.sort,
    this.name
  });

  @override
  Map<String, dynamic> serialize() => {
    'sort': sort, 'name': name
  };
}

@HiveType(typeId: 0)
class Order extends HiveObject implements JsonSerializable {
  String id;

  String city;
  String note;
  double total;
  String number;
  OrderType type;
  double deliveryFee;
  OrderStatus status;

  User customer;

  Payment payment;
  OrderLocation location;
  List<OrderImage> images;
  List<OrderItemHolder> items;

  DateTime createdAt;
  DateTime updatedAt;

  void addItem({OrderItem item, double price}) {
    items.add(OrderItemHolder(
      item: item, subtotal: price
    ));

    total += price;
  }

  Order(this.type, {
    this.id,
    this.city,
    this.note,
    this.total = 0.0,
    this.items,
    this.number,
    this.images = const [],
    this.status,
    this.payment,
    this.location,
    this.customer,
    this.createdAt,
    this.updatedAt,
    this.deliveryFee = 50
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    OrderItem Function(Map<String, dynamic>) _parser;
    final type = _typeFromString(json['service']);

    switch (type) {
      case OrderType.dumpster:
        _parser = DumpsterOrderItem.fromJson;
        break;
      case OrderType.scaffolding:
        _parser = ScaffoldingOrderItem.fromJson;
        break;
      case OrderType.buildingMaterial:
        _parser = BuildingMaterialOrderItem.fromJson;
        break;
      case OrderType.finishingMaterial:
        _parser = FinishingMaterialOrderItem.fromJson;
        break;
    }

    var status;
    switch (json['status']) {
      case 0:
        status = OrderStatus.pending;
        break;
      case 1:
        status = OrderStatus.active;
        break;
      case 2:
        status = OrderStatus.closed;
        break;
      case 3:
        status = OrderStatus.rejected;
        break;
      case 4:
        status = OrderStatus.dispatched;
        break;
    }

    return Order(_typeFromString(json['service']),
      id: json['_id'],
      status: status,
      note: json['note'],
      city: json['city'],
      number: json['orderNo'],
      total: json['total']?.toDouble(),
      deliveryFee: json['deliveryFee']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
      payment: Payment.fromJson(/*json['payment'] ?? */json),

      customer: json['customer'] is String
          ? AppData.instance().user
          : User.fromJson(json['customer']),

      location: OrderLocation.fromJson(json['dropoff']),

      items: (json['items'] as List)
        .map((item) {
          var supplier = item['supplier'];
          if (supplier is Map) {
            supplier = supplier['_id'];
          }

          return OrderItemHolder(
            supplier: supplier,
            subtotal: item['subtotal']?.toDouble(),

            item: _parser != null ? _parser(item['item']) : null
          );
        })
        .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'note': note,
    'total': total,
    'status': status,
    'orderNo': number,
    'deliveryFee': deliveryFee,
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

enum OrderStatus {
  rejected,
  pending,
  active,
  dispatched,
  closed,
}
enum OrderType {
  dumpster,
  scaffolding,
  buildingMaterial,
  finishingMaterial
}


class _Order {
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItemHolder> _items = [];

  _Order._({
    this.createdAt,
    this.updatedAt
  });

  factory _Order.create(OrderType type) {

  }

  bool canProceed() {
    return _items.isNotEmpty;
  }
}