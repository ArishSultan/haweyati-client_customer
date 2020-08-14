import 'package:hive/hive.dart';
part 'transaction_model.g.dart';


@HiveType(typeId: 6)
class Transaction extends HiveObject {
  @HiveField(0)
  String paymentType;
  @HiveField(1)
  double paymentAmount;
  @HiveField(2)
  String paymentIntentId;
  Transaction({this.paymentType,this.paymentAmount,this.paymentIntentId});

  Transaction.fromJson(Map<String, dynamic> json) {
    paymentType = json['paymentType'];
    paymentAmount = json['paymentAmount'];
    paymentIntentId = json['paymentIntentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentType'] = this.paymentType;
    data['paymentAmount'] = this.paymentAmount;
    data['paymentIntentId'] = this.paymentIntentId;
    return data;
  }

}