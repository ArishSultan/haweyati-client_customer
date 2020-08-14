import 'package:hive/hive.dart';
part 'order-details_model.g.dart';

@HiveType(typeId: 8)
class OrderDetails {
  @HiveField(0)
  List<dynamic> items;
  @HiveField(1)
  double netTotal;
  OrderDetails({this.netTotal,this.items});


  OrderDetails.fromJson(Map<String, dynamic> json) {
    netTotal = json['netTotal'];
    items = json['items'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['netTotal'] = this.netTotal;
    data['items'] = this.items.map((e) => e.toJson()).toList();
    return data;
  }

}