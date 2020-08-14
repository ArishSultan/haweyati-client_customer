import 'package:hive/hive.dart';
import '../../finishing-product.dart';
part 'finishing-material_order.g.dart';

@HiveType(typeId: 14)
class FMOrder extends HiveObject {
  @HiveField(0)
  FinProduct product;
  @HiveField(1)
  Map<String, dynamic> variant = {};
  @HiveField(2)
  int qty;
  @HiveField(3)
  double total;
  @HiveField(4)
  double price;

  FMOrder({this.product,this.variant,this.qty,this.total,this.price});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product'] = this.product.toJson();
    data['variant'] = this.variant;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['total'] = this.total;
    return data;
  }

}
