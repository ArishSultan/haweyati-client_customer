import 'package:hive/hive.dart';
import 'package:haweyati/src/models/dumpster_model.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';

@HiveType(typeId: 1)
class DumpsterOrderItem extends HiveObject implements OrderItem {
  @HiveField(0) Dumpster dumpster;

  @HiveField(1) int extraDays;
  @HiveField(2) double extraDaysRent;
  @HiveField(2) double total;

  DumpsterOrderItem({
    this.dumpster,
    this.extraDays = 0,
    this.extraDaysRent = 0,
    this.total = 0
  });

  factory DumpsterOrderItem.fromJson(Map<String,dynamic> json) => DumpsterOrderItem(
    total: double.tryParse(json['total']) ?? 0.0,
    dumpster: Dumpster.fromJson(json['product'], true),
    extraDays: int.tryParse(json['extraDays']) ?? 0,
    extraDaysRent: double.tryParse(json['extraDayPrice']) ?? 0.0
  );

  Map<String, dynamic> serialize() => {
    'total': this.total,
    'product': this.dumpster.toJson(),
    'extraDays': this.extraDays,
    'extraDayPrice': this.extraDaysRent,
  };

  // @override
  // buildWidget(context) {
  //   return EmptyContainer(
  //     child: Column(
  //       children: [
  //         Row(
  //           children: <Widget>[
  //             Image.network(HaweyatiService.convertImgUrl(dumpster.image.name) ?? "",width: 60,height: 60,),
  //             SizedBox(
  //               width: 12,
  //             ),
  //             Text(
  //               dumpster.size + "Yard Dumpster",
  //               style: TextStyle(
  //                   fontSize: 16, fontWeight: FontWeight.bold),
  //             )
  //           ],
  //         ),
  //         _buildRow(type: 'Extra Days',detail: extraDays.toString()),
  //         _buildRow(type: 'Extra Price',detail: extraDaysRent.toString()),
  //         _buildRow(type: 'Subtotal',detail: total.toString()),
  //
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildtext(String text) {
  //   return Text(text,style: TextStyle(fontSize: 11),);
  // }
  //
  //
  // Widget _buildRow({
  //   String type,
  //   String detail,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     child: Row(
  //       children: <Widget>[
  //         Text(
  //           type,
  //           style: TextStyle(color: Colors.blueGrey),
  //         ),
  //         Text(
  //           detail,
  //
  //         ),
  //       ],
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     ),
  //   );
  // }
}