import 'package:haweyati/models/hive-models/orders/order-details_model.dart';
import 'package:hive/hive.dart';
part 'order_model.g.dart';

@HiveType(typeId: 0)
class Order extends HiveObject {
  @HiveField(0)
  String service;
  @HiveField(2)
  String dropOffDate;
  @HiveField(3)
  String dropOffTime;
  @HiveField(4)
  String note;
  @HiveField(5)
  bool helper;
  @HiveField(6)
  String customer;
  @HiveField(7)
  String image;
  @HiveField(9)
  OrderDetails order;
  @HiveField(10)
  String paymentType;
  @HiveField(11)
  String paymentIntentId;
  String latitude;
  @HiveField(13)
  String longitude;
  @HiveField(14)
  String address;
  @HiveField(15)
  String city;

  Order({
    this.customer,
    this.note,
    this.dropOffDate,
    this.dropOffTime,
    this.service,
    this.helper,
    this.image,
    this.city,
    this.order,
    this.paymentType,
    this.paymentIntentId,
    this.address,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service'] = this.service;
    data['details'] = this.order.toJson();
    data['dropoffAddress'] = this.address;
    data['dropoffDate'] = this.dropOffDate;
    data['dropoffTime'] = this.dropOffTime;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['note'] = this.note;
    data['city'] = this.city;
    data['customer'] = this.customer;
    data['paymentType'] = this.paymentType;
    data['paymentIntentId'] = this.paymentIntentId;
    return data;
  }

}

