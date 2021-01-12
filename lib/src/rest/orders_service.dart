import 'package:haweyati/src/const.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:retrofit/retrofit.dart';

import '_new/_config.dart';

part 'orders_service.g.dart';

@RestApi(baseUrl: apiUrl)
abstract class OrdersService {
  factory OrdersService() => _OrdersService(defaultDio);

  @POST('/orders/dummy')
  Future<Order> placeOrder(@Body() Order order);

  @PATCH('/orders/cancel/{id}')
  Future<void> cancelOrder(@Path('id') String id);

  @PATCH('/orders/process-payment')
  Future<void> processPayment(@Body() Map<String,dynamic> body);

  @GET('/orders/dummy')
  Future<List<Order>> orders({
    @Query('customer') String id,
    @Query('name') String orderId,
  });
}
