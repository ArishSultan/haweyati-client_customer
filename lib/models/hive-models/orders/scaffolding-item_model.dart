import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:haweyati/widgits/emptyContainer.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 19)
class ScaffoldingItemModel extends HiveObject implements OrderItem {
  @HiveField(0)
  String name;
  @HiveField(1)
  int qty;
  @HiveField(2)
  double price;
  @HiveField(3)
  double size;
  @HiveField(4)
  bool scaffoldingFixing;
  @HiveField(5)
  String meshPlateForm;
  @HiveField(6)
  double total;

  ScaffoldingItemModel({this.size,this.name,this.price,this.qty,this.total,this.meshPlateForm,this.scaffoldingFixing});

  ScaffoldingItemModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
   qty = int.parse(json['qty']);
   price = double.parse(json['price'].toString());
   total = json['total']!=null ? double.parse(json['total'].toString()) : null;
//    size = json['size'];
    scaffoldingFixing = json['scaffoldingFixing'];
    meshPlateForm = json['meshPlateForm'];
  }


  Map<String,dynamic> toJson() {
    Map<String,dynamic> data = Map();
    data['name'] =  this.name;
    data['qty'] =  this.qty;
    data['total'] =  this.total;
    if(this.size!=null){
      data['size'] =  this.size;
    }
    data['price'] =  this.price;
    if(this.scaffoldingFixing!=null){
      data['scaffoldingFixing'] = this.scaffoldingFixing;
    }
    if(this.meshPlateForm!=null){
      data['meshPlateForm'] = this.meshPlateForm;
    }
    return data;
  }

  @override
  buildWidget(context) {
    return EmptyContainer(
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
          _buildRow(type: 'Quantity',detail: qty.toString()),
          _buildRow(type: 'Price',detail: price.toString()),
        total!=null ?  _buildRow(type: 'Subtotal',detail: total.toString()) : SizedBox(),

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
  Map<String, dynamic> serialize() {
    return toJson();
  }
}

List<ScaffoldingItemModel> singleScaffoldingItems = [
  ScaffoldingItemModel(
    name: 'Main Frame',
    price: 345,
    qty: 1,
    size: 1.5,
  ),
  ScaffoldingItemModel(
    name: 'Cross Brace',
    price: 345,
    qty: 1,
    size: 1.5,
  ),
  ScaffoldingItemModel(
    name: 'Connecting Bar',
    price: 345,
    qty: 1,
    size: 1.5,
  ),
  ScaffoldingItemModel(
    name: 'Adjustable Base',
    price: 345,
    qty: 1,
    size: 1.5,
  ),
  ScaffoldingItemModel(
    name: 'Stabilizer',
    price: 345,
    qty: 1,
    size: 1.5,
  ),
  ScaffoldingItemModel(
    name: 'Wood Planks',
    price: 345,
    qty: 1,
    size: 1.5,
  ),
];