import 'package:hive/hive.dart';
import 'package:haweyati/src/models/dumpster_model.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';

class DumpsterOrderItem extends OrderItem {
  @HiveField(1) int extraDays;
  @HiveField(2) double extraDaysPrice;

  DumpsterOrderItem({
    Dumpster product,
    this.extraDays,
    this.extraDaysPrice
  }): super(product);

  factory DumpsterOrderItem.fromJson(Map<String, dynamic> json) {
    return DumpsterOrderItem(
      product: Dumpster.fromJson(json['product']),
      extraDays: json['extraDays'],
      extraDaysPrice: json['extraDaysPrice']
    );
  }

  @override
  Map<String, dynamic> serialize() => super.serialize()
      ..addAll({
        'extraDays': extraDays,
        'extraDaysPrice': extraDaysPrice
      });
}
// @HiveType(typeId: 1)
// class DumpsterOrder extends HiveObject implements OrderItem {
//   @HiveField(0)
//   Dumpster dumpster;
//   @HiveField(3)
//   double total;
//   @HiveField(4)
//   double subTotal;
//   DumpsterOrder({this.dumpster,this.extraDayPrice,this.extraDays,this.total});
//
//   DumpsterOrder.fromJson(Map<String,dynamic> json){
//     dumpster = Dumpster.fromJson(json['item']['product'],true);
//     extraDays = int.parse(json['item']['extraDays']);
//     extraDayPrice = double.parse(json['item']['extraDayPrice']);
//     subTotal = double.parse(json['subtotal']);
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['product'] = this.dumpster.toJson();
//     data['extraDays'] = this.extraDays;
//     data['extraDayPrice'] = this.extraDayPrice;
//     // data['total'] = this.total;
//     return data;
//   }
//
//
//   @override
//   buildWidget(context) {
//     return EmptyContainer(
//       child: Column(
//         children: [
//           Row(
//             children: <Widget>[
//               Image.network(HaweyatiService.convertImgUrl(dumpster.image.name) ?? "",width: 60,height: 60,),
//               SizedBox(
//                 width: 12,
//               ),
//               Text(
//                 dumpster.size + "Yard Dumpster",
//                 style: TextStyle(
//                     fontSize: 16, fontWeight: FontWeight.bold),
//               )
//             ],
//           ),
//           _buildRow(type: 'Extra Days',detail: extraDays.toString()),
//           _buildRow(type: 'Extra Price',detail: extraDayPrice.toString()),
//           _buildRow(type: 'Subtotal',detail: subTotal.toString()),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _buildtext(String text) {
//     return Text(text,style: TextStyle(fontSize: 11),);
//   }
//
//
//   Widget _buildRow({
//     String type,
//     String detail,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: <Widget>[
//           Text(
//             type,
//             style: TextStyle(color: Colors.blueGrey),
//           ),
//           Text(
//             detail,
//
//           ),
//         ],
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       ),
//     );
//   }
//
//   @override
//   double get subtotal => dumpster.pricing.first.rent + (extraDays * dumpster.pricing.first.extraDayRent);
//
//
//
// }