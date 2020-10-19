import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/common/services/easy-rest/easy-rest.dart';

class ScaffoldingPrice {
  int days;
  double rent;
  double extraDayRent;

  ScaffoldingPrice({
    this.days,
    this.rent,
    this.extraDayRent
  });

  factory ScaffoldingPrice.fromJson(Map<String, dynamic> json) {
    return ScaffoldingPrice(
      days: json['days'],
      rent: json['rent'].toDouble(),
      extraDayRent: json['extraDayRent'].toDouble()
    );
  }
}

class ScaffoldingService {
  final _service = EasyRest();
  final _appData = AppData.instance();

  Future<ScaffoldingPrice> steelScaffoldingPrice() async =>
      _parsePricing(await _getTypedScaffolding('Steel Scaffolding'));

  Future<ScaffoldingPrice> singleScaffoldingPrice() async =>
      _parsePricing(await _getTypedScaffolding('Single Scaffolding'));

  Future<ScaffoldingPrice> patentedScaffoldingPrice() async =>
      _parsePricing(await _getTypedScaffolding('Patented Scaffolding'));


  _getTypedScaffolding(String type) async {
    final data = await _service.$getAll(endpoint: 'scaffoldings') as List;
    return data.firstWhere((element) => element['type'] == type);
  }

  ScaffoldingPrice _parsePricing(Map<String, dynamic> json) {
    final pricing = (json['pricing'] as List)
        .firstWhere((element) => element['city'] == _appData.city);

    return ScaffoldingPrice.fromJson(pricing);
  }
}