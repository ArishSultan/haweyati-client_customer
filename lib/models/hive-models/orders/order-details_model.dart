import 'package:haweyati/models/hive-models/orders/building-material-order.dart';
import 'package:haweyati/models/hive-models/orders/finishing-material_order.dart';
import 'package:haweyati/models/hive-models/orders/scaffolding-item_model.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:hive/hive.dart';


@HiveType(typeId: 8)
class OrderDetail {
  @HiveField(0)
  List<OrderItem> items;
  @HiveField(1)
  double netTotal;
  OrderDetail({this.netTotal,this.items});

  OrderDetail.fromJson(String service, Map<String, dynamic> json) {
    netTotal = double.parse(json['netTotal']);
    items =  parseOrder(service, json['items'].cast<Map<String, dynamic>>());
    print(items);
//    scaffoldingFixing = json['scaffoldingFixing'];
//    meshPlateForm = json['meshPlateForm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['netTotal'] = this.netTotal;
    // data['items'] = this.items.map((e) => e.toJson()).toList();
    return data;
  }

  parseOrder(String service,List<Map<String, dynamic>> json) {
    print('here');
    print(json);

    switch(service) {
      case 'Construction Dumpster':
        // return json.map((e) => DumpsterOrder.fromJson(e)).toList();
      case 'Building Material':
        return json.map((e) => BMOrder.fromJson(e)).toList();
      case 'Scaffolding':
        return json.map((e) => ScaffoldingItemModel.fromJson(e)).toList();
      case 'Finishing Material':
        return json.map((e) => FMOrder.fromJson(e)).toList();
      case 'Delivery Vehicle':
        return null;
      default:
        return null;
    }
  }


}