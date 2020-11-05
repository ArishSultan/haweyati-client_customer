import 'package:haweyati/src/common/models/json_serializable.dart';
import 'package:haweyati/src/common/models/serializable.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:haweyati/src/models/services/building-material/model.dart';
import 'package:hive/hive.dart';

part 'order-item_model.g.dart';

@HiveType(typeId: 52)
class BuildingMaterialOrderItem extends OrderItem<BuildingMaterial> {
  @HiveField(1) int qty;
  @HiveField(3) double price;
  @HiveField(2) BuildingMaterialSize size;

  BuildingMaterialOrderItem(this.size, {
    BuildingMaterial product,
    this.qty = 0,
    this.price = 0.0,
  }): super(product);

  static BuildingMaterialOrderItem fromJson(Map<String, dynamic> json) {
    return BuildingMaterialOrderItem(
      BuildingMaterialSize.deserialize(json['size']),
      qty: json['qty'],
      price: json['price']?.toDouble(),
      product: BuildingMaterial.fromJson(json['product'])
    );
  }

  @override
  Map<String, dynamic> serialize() => super.serialize()
      ..addAll({
        'qty': qty,
        'size': size.serialize(),
        'price': price
      });
}
