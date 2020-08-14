import 'package:hive/hive.dart';
import '../../dumpster_model.dart';
part 'dumpster-order_model.g.dart';

@HiveType(typeId: 1)
class DumpsterOrder extends HiveObject {
  @HiveField(0)
  Dumpster dumpster;
  @HiveField(1)
  int extraDays;
  @HiveField(2)
  double extraDayPrice;
  @HiveField(3)
  double total;

  DumpsterOrder({this.dumpster,this.extraDayPrice,this.extraDays,this.total});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['product'] = this.dumpster.toJson();
    data['extraDays'] = this.extraDays;
    data['extraDayPrice'] = this.extraDayPrice;
    data['total'] = this.total;
    return data;
  }

}