import 'package:haweyati_client_data_models/data.dart';

class OrdersService {
  Future<List<Order>> orders({String orderId}) async {
    // final id = AppData.instance().user?.id;
    // if (id != null) {
    //   List<dynamic> data = await _service
    //       .$getAll(endpoint: 'orders/dummy', query: {'customer': id, 'name': orderId});
    //
    //   return data.map((e) => Order.fromJson(e))?.toList();
    // } else {
    //   return [];
    // }
  }

  // Future<Order> placeOrder(final Order order) async =>
  //     Order.fromJson(await _service.$post(endpoint: 'orders/dummy', payload: order));
  //
  // Future<String> addImage(String id, String sort, String path) async {
  //   return (await Dio().patch('$apiUrl/orders/add-image', data: FormData.fromMap({
  //     'id': id, 'sort': sort,
  //     'image': await MultipartFile.fromFile(path)
  //   }))).data as String;
  //   _service.$patch(endpoint: 'orders/add-image', payload: )
  // }
}
