import 'package:hive/hive.dart';
import 'package:haweyati/src/common/models/json_serializable.dart';

class ScaffoldingItem extends HiveObject implements JsonSerializable {
  int qty; double size;

  ScaffoldingItem({this.qty = 0, this.size});
  factory ScaffoldingItem.fromJson(Map<String, dynamic> json) {
    return ScaffoldingItem(qty: json['qty'], size: json['size']);
  }

  @override
  Map<String, dynamic> serialize() => {
    'qty': qty, 'size': size
  };
}