import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/common/services/easy-rest/easy-rest.dart';

class OrdersService {
  final _service = EasyRest();

  Future<List<Order>> orders() async {
    final id = AppData.instance().user?.id;
    if (id != null) {
      List<dynamic> data = await _service
          .$getAll(endpoint: 'orders/dummy', query: {'customer': id});

      return data.map((e) => Order.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<Order> placeOrder(final Order order) async =>
    Order.fromJson(await _service.$post(endpoint: 'orders/dummy', payload: order));
}
