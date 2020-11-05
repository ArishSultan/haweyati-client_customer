import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/common/models/json_serializable.dart';
import 'package:hive/hive.dart';

abstract class Orderable extends HiveObject implements JsonSerializable {}
abstract class OrderItem<T extends Orderable> extends HiveObject implements JsonSerializable {
  @HiveField(0)
  Orderable _product;
  OrderItem(this._product);

  T get product => _product;
  set product(T t) => _product = t;

  @override
  @mustCallSuper
  Map<String, dynamic> serialize() => { 'product': product.serialize() };
}

class OrderItemHolder<T extends OrderItem> implements JsonSerializable {
  T item;
  double subtotal;
  String supplier;

  OrderItemHolder({
    this.item,
    this.supplier,
    this.subtotal
  });

  @override
  Map<String, dynamic> serialize() => {
    'item': item.serialize(),
    'subtotal': subtotal,
    'supplier': supplier,
  };
}
