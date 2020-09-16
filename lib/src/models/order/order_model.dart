import 'package:haweyati/src/common/models/json_serializable.dart';
import 'package:haweyati/src/models/drop-off-detail_model.dart';
import 'package:haweyati/src/models/payment_model.dart';
import 'package:hive/hive.dart';

import '../user_model.dart';
import 'order-item_model.dart';

@HiveType(typeId: 0)
class Order extends HiveObject implements JsonSerializable {
  String id;
  String city;
  String note;
  double total;
  String number;
  String status;
  String service;

  User customer;

  DropOff dropOff;
  Payment payment;
  List<String> images;
  List<OrderItemHolder> items;

  DateTime createdAt;
  DateTime updatedAt;

  Order({
    this.city,
    this.note,
    this.images,
    this.status,
    this.service,
    this.dropOff,
    this.customer,
    this.createdAt,
    this.updatedAt,
    this.payment,
    this.total
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
    );
    // ShapeDecoration
    // service = json['service'];
    // status = json['status'];
    // createdAt = json['createdAt'];
    // orderNo = json['orderNo'];
    // paymentType = json['paymentType'];
    // netTotal = double.tryParse(json['total'].toString()) ?? 0.0;
    // order = json['items'] !=null ? OrderDetails.fromJson(json['service'], json) : null;
    // dropOff = DropOff.fromJson(json['dropoff']);
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'note': note,
    'total': total,
    'status': status,
    'orderNo': number,
    'service': service,

    /// TODO: Change Name
    'items': items
        .map((e) => e.serialize())
        .toList(growable: false),

    'dropoff': dropOff.serialize(),

    'customer': customer.serialize(),
    'paymentType': payment.type,
    'paymentIntentId': payment.intentId,
  };

  @override Map<String, dynamic> serialize() => toJson();
}

