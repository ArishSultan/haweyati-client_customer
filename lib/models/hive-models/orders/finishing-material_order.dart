import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/models/hive-models/orders/dumpster-order_model.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:haweyati/widgits/emptyContainer.dart';
import 'package:hive/hive.dart';
import '../../finishing-product.dart';
part 'finishing-material_order.g.dart';

@HiveType(typeId: 14)
class FMOrder extends HiveObject implements OrderItem {
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

  FMOrder.fromJson(Map<String, dynamic> json){
    product = FinProduct.fromJson(json['product']);
    variant = json['variant'];
    price = double.parse(json['price'].toString());
    qty = int.parse(json['qty']);
    total = double.parse(json['total'].toString());
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product'] = this.product.toJson();
    data['variant'] = this.variant;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['total'] = this.total;
    return data;
  }

  @override
  buildWidget(context) {
    return EmptyContainer(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Image.network(HaweyatiService.convertImgUrl(product.images.name) ?? "",width: 60,height: 60,),
              SizedBox(
                width: 12,
              ),
              Text(
                product.name,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
         price!=null ? _buildRow(type: 'Price',detail: price.toString()) : SizedBox(),
         variant!=null ? _buildRow(type: 'Selected Variant',detail: variant.toString()) : SizedBox(),
          _buildRow(type: 'Quantity',detail: qty.toString()),
          _buildRow(type: 'Subtotal',detail: total.toString()),
        ],
      ),
    );
  }


  Widget _buildtext(String text) {
    return Text(text,style: TextStyle(fontSize: 11),);
  }


  Widget _buildRow({
    String type,
    String detail,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Text(
            type,
            style: TextStyle(color: Colors.blueGrey),
          ),
          Text(
            detail,

          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  @override
  Map<String, dynamic> serialize() => toJson();

}
