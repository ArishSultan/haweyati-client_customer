import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:haweyati/src/common/models/json_serializable.dart';
import 'package:haweyati/src/common/models/serializable.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/_new/customer_model.dart';
import 'package:haweyati/src/models/order/dumpster/order-item_model.dart';
import 'package:haweyati/src/models/order/order-location_model.dart';
import 'package:haweyati/src/models/order/order-status.dart';
import 'package:haweyati/src/models/order/scaffoldings/order-item_model.dart';
import 'package:haweyati/src/models/payment_model.dart';
import 'package:haweyati/src/models/user_model.dart';
import 'package:hive/hive.dart';

import 'building-material/order-item_model.dart';
import 'finishing-material/order-item_model.dart';
import 'order-item_model.dart';
import 'order-type.dart';

export 'order-type.dart';
export 'order-status.dart';

class OrderImage implements Serializable<Map<String, dynamic>> {
  String sort;
  String name;

  OrderImage({this.sort, this.name});

  @override
  Map<String, dynamic> serialize() => {'sort': sort, 'name': name};
}

class Order extends HiveObject implements JsonSerializable {
  String id;

  String city;
  String note;
  double total;
  String number;
  OrderType type;
  double deliveryFee;
  OrderStatus status;

  // User customer;

  Payment payment;
  OrderLocation location;
  List<OrderImage> images;
  List<OrderItemHolder> items;

  DateTime createdAt;
  DateTime updatedAt;

  void addItem({OrderItem item, double price}) {
    items.add(OrderItemHolder(item: item, subtotal: price));

    total += price;
  }

  Order(this.type,
      {this.id,
      this.city,
      this.note,
      this.total = 0.0,
      this.items,
      this.number,
      this.images = const [],
      this.status,
      this.payment,
      this.location,
      // this.customer,
      this.createdAt,
      this.updatedAt,
      this.deliveryFee = 50});

  factory Order.fromJson(Map<String, dynamic> json) {
    OrderItem Function(Map<String, dynamic>) _parser;
    final type = OrderType.deserialize(json['service']);

    if (type == OrderType.dumpster) {
      _parser = DumpsterOrderItem.fromJson;
    } else if (type == OrderType.scaffolding) {
      _parser = ScaffoldingOrderItem.fromJson;
    } else if (type == OrderType.buildingMaterial) {
      _parser = BuildingMaterialOrderItem.fromJson;
    } else if (type == OrderType.finishingMaterial) {
      _parser = FinishingMaterialOrderItem.fromJson;
    }

    return Order(
      OrderType.deserialize(json['service']),
      id: json['_id'],
      status: OrderStatus.pending,
      note: json['note'],
      city: json['city'],
      number: json['orderNo'],
      total: json['total']?.toDouble(),
      deliveryFee: json['deliveryFee']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
      payment: Payment.fromJson(/*json['payment'] ?? */ json),
      // customer: json['customer'] is String
      //     ? AppData.instance().user
      //     : User.fromJson(json['customer']),
      location: OrderLocation.fromJson(json['dropoff']),
      items: (json['items'] as List).map((item) {
        var supplier = item['supplier'];
        if (supplier is Map) {
          supplier = supplier['_id'];
        }

        return OrderItemHolder(
            supplier: supplier,
            subtotal: item['subtotal']?.toDouble(),
            item: _parser != null ? _parser(item['item']) : null);
      }).toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() => {
        'city': city,
        'note': note,
        'total': total,
        'status': status,
        'orderNo': number,
        'deliveryFee': deliveryFee,
        'service': type.serialize(),
        'items': items.map((e) => e.serialize()).toList(growable: false),
        'location': location.serialize(),
        // 'customer': AppData.instance().user.serialize(),
        'paymentType': payment?.type,
        'paymentIntentId': payment?.intentId,
      };

  @override
  Map<String, dynamic> serialize() => toJson();

  // static String _typeToString(OrderType type) {
  //   switch (type) {
  //     case OrderType.dumpster: return 'Construction Dumpster';
  //     case OrderType.scaffolding: return 'Scaffolding';
  //     case OrderType.buildingMaterial: return 'Building Material';
  //     case OrderType.finishingMaterial: return 'Finishing Material';
  //   }
  //
  //   throw 'Unknown type found $type';
  // }
  // static OrderType _typeFromString(String type) {
  //   switch (type) {
  //     case 'Scaffolding': return OrderType.scaffolding;
  //     case 'Building Material': return OrderType.buildingMaterial;
  //     case 'Finishing Material': return OrderType.finishingMaterial;
  //     case 'Construction Dumpster': return OrderType.dumpster;
  //   }
  //
  //   throw 'Unknown type found $type';
  // }
}

// enum UserType { admin, driver, customer, supplier }
// class OrderUpdater {
//   String id;
//   UserType type;
// }
//
// class OrderUpdate {
//   String updatedBy;
//   OrderStatus status;
//
//   String note;
//   String message;
//   DateTime timestamp;
// }

class $Order<T extends OrderItem> implements JsonSerializable {
  final String _id;
  final String _number;
  final OrderType _type;

  String _note;
  OrderStatus _status;

  Payment _payment;
  $Customer _customer;
  OrderLocation _location;

  final DateTime _createdAt;
  final DateTime _updatedAt;

  final _images = <OrderImage>[];
  final _items = <OrderItemHolder<T>>[];

  /// Value Added Tax
  static const vat = .15;

  double _subtotal = 0.0;

  double get subtotal => _subtotal;
  double get total => _subtotal + _subtotal * vat;

  List<OrderItemHolder<T>> get items =>
      List.from(_items, growable: false);

  $Order._([
    this._type,
    this._createdAt,
    this._updatedAt,
    this._id,
    this._note,
    this._status,
    this._number,
    this._payment,
    this._customer,
    this._location,
  ]);

  factory $Order.create(OrderType type) {
    final time = DateTime.now();
    return $Order._(type, time, time);
  }

  void addImage(OrderImage image) {
    assert(image != null);
    _images.add(image);
  }

  void clearImages() => _images.clear();
  void clearItems() {
    _items.clear();
    _subtotal = 0;
  }
  void addItem({@required T item, @required double price}) {
    assert(item != null);
    assert(item != null && price > 0.0);

    _items.add(OrderItemHolder(item: item, subtotal: price));
    _subtotal += price;
  }

  String get note => _note;
  set note(String note) {
    if (note != null) {
      _note = note;
    } else {
      log('NOTE CAN NOT BE NULL');
    }
  }

  set customer($Customer customer) {
    if (customer != null) {
      // _customer = customer;
    } else {
      log('CUSTOMER CAN NOT BE NULL');
    }
  }

  set payment(Payment payment) => _payment = payment;

  OrderLocation get location => _location;
  set location(OrderLocation location) {
    if (location != null) {
      _location = location;
    } else {
      log('ORDER LOCATION CAN NOT BE NULL');
    }
  }

  OrderType get type => _type;

  bool get canProceed => _customer != null && _items.isNotEmpty;

  @override
  Map<String, dynamic> serialize() => {
        'note': _note,
        'total': _subtotal,
        'status': _status,
        'orderNo': _number,
        'deliveryFee': null,
        'service': _type.serialize(),
        'items': items.map((e) => e.serialize()).toList(growable: false),
        'location': _location.serialize(),
        'customer': _customer.toJson(),
        'paymentType': _payment?.type,
        'paymentIntentId': _payment?.intentId,
      };
}
