import 'package:hive/hive.dart';
part 'rent_model.g.dart';

@HiveType(typeId: 21)
class Rent extends HiveObject{
  @HiveField(0)
  String id;
  @HiveField(1)
  int days;
  @HiveField(2)
  String city;
  @HiveField(3)
  double rent;
  @HiveField(4)
  double helperPrice;
  @HiveField(5)
  double extraDayRent;

  Rent({
    this.id,
    this.city,
    this.rent,
    this.days,
    this.extraDayRent,
    this.helperPrice
  });

  factory Rent.fromJson(Map<String, dynamic> json) => Rent(
    id: json['_id'],
    city: json['city'],
    days: json['days'],
    extraDayRent: json['extraDayRent'].toDouble(),
    helperPrice: json['helperPrice'].toDouble(),
    rent: json['rent'].toDouble(),
  );


  Map<String, dynamic> toJson() => {
    "_id": id,
    "city": city,
    "rent": rent,
    "days": days,
    "extraDayRent": extraDayRent
  };
}
