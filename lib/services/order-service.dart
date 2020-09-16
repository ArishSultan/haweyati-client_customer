import 'package:haweyati/models/hive-models/orders/order_model.dart';
import 'package:haweyati/services/haweyati-service.dart';

class OrdersService extends HaweyatiService {
  @override
  parse(Map<String, dynamic> item) => null/*Order.fromJson(item)*/;

  Future<List/*<Order>*/> orders() async {
    return this.getAll('orders');
  }

  Future postOrder() async {

  }

}