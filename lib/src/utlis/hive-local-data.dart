import 'package:haweyati/models/bm-pricing.dart';
import 'package:haweyati/models/building-material_sublist.dart';
import 'package:haweyati/models/finishing-product.dart';
import 'package:haweyati/models/hive-models/customer/customer-model.dart';
import 'package:haweyati/models/hive-models/customer/profile_model.dart';
import 'package:haweyati/models/hive-models/notifications_model.dart';
import 'package:haweyati/models/hive-models/orders/building-material-order.dart';
import 'package:haweyati/models/hive-models/orders/dumpster-order_model.dart';
import 'package:haweyati/models/hive-models/orders/finishing-material_order.dart';
import 'package:haweyati/models/hive-models/orders/location_model.dart';
import 'package:haweyati/models/hive-models/orders/order-details_model.dart';
import 'package:haweyati/models/hive-models/orders/order_model.dart';
import 'package:haweyati/models/hive-models/orders/transaction_model.dart';
import 'package:haweyati/models/hive-models/time-slots.dart';
import 'package:haweyati/models/images_model.dart';
import 'package:haweyati/models/dumpster_model.dart';
import 'package:haweyati/models/options_model.dart';
import 'package:haweyati/models/person_model.dart';
import 'package:haweyati/models/rent_model.dart';
import 'package:haweyati/models/suppliers_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HaweyatiData {
  static Box<Customer> _auth;

  static init() async {
    var dir = await getApplicationDocumentsDirectory();
    await Hive.init(dir.path);
//    await Hive.deleteBoxFromDisk('customer');
    await Hive.registerAdapter(DumpsterAdapter());
    await Hive.registerAdapter(DumpsterOrderAdapter());
    await Hive.registerAdapter(OrderAdapter());
    await Hive.registerAdapter(SupplierAdapter());
    await Hive.registerAdapter(HiveLocationAdapter());
    await Hive.registerAdapter(BMProductAdapter());
    await Hive.registerAdapter(BMOrderAdapter());
    await Hive.registerAdapter(PersonAdapter());
    await Hive.registerAdapter(BMPricingAdapter());
    await Hive.registerAdapter(ImagesAdapter());
    await Hive.registerAdapter(CustomerAdapter());
    await Hive.registerAdapter(TimeSlotAdapter());
    await Hive.registerAdapter(ProfileAdapter());
    await Hive.registerAdapter(OrderDetailsAdapter());
    await Hive.registerAdapter(NotificationsAdapter());
    await Hive.registerAdapter(TransactionAdapter());
    await Hive.registerAdapter(RentAdapter());
    await Hive.registerAdapter(FMOrderAdapter());
    await Hive.registerAdapter(ProductOptionAdapter());
    await Hive.registerAdapter(FinProductAdapter());

    _auth = await Hive.openBox('customer');
//    await Hive.deleteBoxFromDisk('customer');
    print(_auth.values);
  }

  static void signIn (Customer customer) async {
    await _auth.clear();
    await _auth.add(customer);
    await customer.save();
  }

  static bool get isSignedIn => _auth.values.isNotEmpty;

  static Customer get customer => _auth.values?.first;

  static void signOut() async {
    await _auth.clear();
  }

  static void addToOrders(Order order) async {
    var orders = await Hive.openBox('orders');
    orders.add(order);
    order.save();
  }

}