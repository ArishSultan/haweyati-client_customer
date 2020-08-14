import 'package:hive/hive.dart';
import '../../building-material_sublist.dart';
part 'building-material-order.g.dart';

@HiveType(typeId: 7)
class BMOrder extends HiveObject {
  @HiveField(0)
  BMProduct product;
  @HiveField(1)
  String size;
  @HiveField(2)
  int qty;
  @HiveField(3)
  double price;
  @HiveField(4)
  double total;

  BMOrder({this.product,this.size,this.qty,this.total,this.price});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product'] = this.product.toJson();
    data['size'] = this.size;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['total'] = this.total;
    return data;
  }

}