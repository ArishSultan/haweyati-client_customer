// import 'package:haweyati/models/hive-models/orders/order-details_model.dart';
// import 'package:haweyati/src/models/order/order-location_model.dart';
// import 'package:haweyati/src/models/payment_model.dart';
// import 'package:hive/hive.dart';
//
//
// @HiveType(typeId: 0)
// class Order extends HiveObject {
//   @HiveField(0) String id;
//   @HiveField(1) String note;
//   @HiveField(2) String status;
//   @HiveField(3) String number;
//
//   @HiveField(4) String service;
//   @HiveField(5) String subService;
//
//   @HiveField(6) Payment payment;
//   @HiveField(5) DateTime createdAt;
//
//   @HiveField(7) OrderDetail detail;
//   @HiveField(8) OrderLocation location;
//
//   Order({
//     this.id,
//     this.note,
//     this.status,
//     this.detail,
//     this.number,
//     this.service,
//     this.location,
//     this.subService,
//   });
//
//   factory Order.fromJson(Map<String,dynamic> json) {
//     return Order(
//       id: json['id'],
//       note: json['note'],
//       status: json['status'],
//       number: json['number'],
//       service: json['service'],
//       subService: json['subService'],
//     );
//     // id = json['id'];
//     // note = json['note'];
//     // status = json['status'];
//     // number = json['number'];
//     // service = json['service'];
//     // subService = json['subService'];
//     // status = json['status'];
//     // createdAt = json['createdAt'];
//     // number = json['orderNo'];
//     // paymentType = json['paymentType'];
//     // order = json['details'] !=null ? OrderDetails.fromJson(json['service'],json['details']) : null;
//     // dropOff = DropOff.fromJson(json['dropoff']);
//   }
//
//
//
//   Map<String, dynamic> toJson() => {
//     // 'customer': AppData.instance().user,
//     'note': note,
//     'status': status,
//     'number': number,
//     'payment': payment.serialize(),
//     'service': service,
//     'subService': subService
//     // final Map<String, dynamic> data = new Map<String, dynamic>();
//     // data['service'] = this.service;
//     // if(this.subService!=null){
//     //   data['subService'] = this.subService;
//     // }
//     // data['details'] = this.order.toJson();
//     // data['dropoffAddress'] = this.address;
//     // data['longitude'] = this.longitude;
//     // data['latitude'] = this.latitude;
//     // if(this.note!=null){
//     //   data['note'] = this.note;
//     // }
//     // data['city'] = this.city;
//     // data['customer'] = this.customer;
//     // data['paymentType'] = this.paymentType;
//     // if(this.paymentIntentId!=null){
//     //   data['paymentIntentId'] = this.paymentIntentId;
//     // }
//     // return data;
//   };
// }
//
