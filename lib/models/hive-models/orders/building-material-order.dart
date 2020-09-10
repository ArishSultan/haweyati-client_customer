import 'package:flutter/material.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:haweyati/widgits/emptyContainer.dart';
import 'package:hive/hive.dart';
import '../../building-material_sublist.dart';
import 'dumpster-order_model.dart';
part 'building-material-order.g.dart';

@HiveType(typeId: 7)
class BMOrder extends HiveObject implements OrderItem {
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


  BMOrder.fromJson(Map<String, dynamic> json){
    product = BMProduct.fromJson(json['product']);
    size = json['size'];
//    price = json['price'];
   qty = int.parse(json['qty']);
   total = double.parse(json['total'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product'] = this.product.toJson();
    data['size'] = this.size;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['total'] = this.total;
    return data;
  }

  @override
  Map<String, dynamic> serialize() => toJson();

  @override
  buildWidget(context) {
    return EmptyContainer(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Image.network(HaweyatiService.convertImgUrl(product.image.name) ?? "",width: 60,height: 60,),
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
          _buildRow(type: 'Size',detail: size),
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


}