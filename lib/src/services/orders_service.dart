import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/common/services/easy-rest/easy-rest.dart';

class OrdersService {
  final _service = EasyRest();

  Future<List<Order>> orders() async {
    return _service.$getAll(endpoint: 'orders');
  }

  Future<Order> placeOrder(final Order order) async =>
    Order.fromJson(await _service.$post(endpoint: 'orders/dummy', payload: order));
}