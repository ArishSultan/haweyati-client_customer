import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haweyati/src/ui/pages/location/locations-map_page.dart';
import 'package:hive/hive.dart';
// import 'package:haweyati/models/bm-pricing.dart';
import 'package:haweyati/models/hive-models/customer/customer-model.dart';
import 'package:haweyati/models/hive-models/notifications_model.dart';
import 'package:haweyati/src/models/location_model.dart';
import 'package:haweyati/models/hive-models/orders/order_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:haweyati/models/hive-models/orders/transaction_model.dart';
import 'package:haweyati/models/hive-models/orders/order-details_model.dart';
import 'package:haweyati/models/hive-models/orders/dumpster-order_model.dart';
import 'package:haweyati/models/hive-models/orders/scaffolding-item_model.dart';
import 'package:haweyati/models/hive-models/orders/building-material-order.dart';
import 'package:haweyati/models/hive-models/orders/finishing-material_order.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppData {
  /// Address specific Data
  String get city;
  String get address;
  LatLng get coordinates;

  Location get location;
  void set location(Location details);

  /// These controls determine weather the
  /// app has been launched before or not.
  Future<void> burnFuse();
  Future<bool> get isFuseBurnt;

  /// User Specific Information.
  /// ValueListenable<bool> get authentication;


  factory AppData.instance() {
    if (_initiated) {
      return _instance;
    } else {
      throw Error();
    }
  }

  static bool _initiated;
  static _AppDataImpl _instance;

  static Future initiate() async {
    await Hive.initFlutter();

    final adapters = [
      // RentAdapter(),
      // OrderAdapter(),
      // PersonAdapter(),
      // ImagesAdapter(),
      // FMOrderAdapter(),
      // BMOrderAdapter(),
      // ProfileAdapter(),
      CustomerAdapter(),
      // DumpsterAdapter(),
      // SupplierAdapter(),
      // BMPricingAdapter(),
      // BMProductAdapter(),
      // FinProductAdapter(),
      TransactionAdapter(),
      // OrderDetailsAdapter(),
      // HiveLocationAdapter(),
      NotificationsAdapter(),
      // DumpsterOrderAdapter(),
      // ProductOptionAdapter(),
      // ScaffoldingItemModelAdapter()
    ];

    /// Register Hive Adapters;
    for (final adapter in adapters) {
      await Hive.registerAdapter(adapter);
    }

    await Hive.openBox('customers');

    _initiated = true;
    _instance = _AppDataImpl();
    await _instance._loadCache();
  }
}

class _AppDataImpl implements AppData {
  String _city;
  String _address;
  LatLng _coordinates;
  ValueListenable _authentication;

  Future _loadCache() async {
    final prefs = await SharedPreferences.getInstance();

    _city = prefs.getString('city');
    _address = prefs.getString('address');
    // _authentication = ValueNotifier<bool>(
    //   JwtAuthService.create().token != null ?? false
    // );

    try {
      _coordinates = LatLng(
        prefs.getDouble('latitude'),
        prefs.getDouble('longitude')
      );
    } catch(e) {
      _coordinates = null;
    }
  }

  @override
  Future<void> burnFuse() async =>
    (await SharedPreferences.getInstance()).setBool('fuseBurnt', true);

  @override
  Future<bool> get isFuseBurnt async =>
    (await SharedPreferences.getInstance()).getBool('fuseBurnt') ?? false;

  @override String get city => _city;
  @override String get address => _address;
  @override LatLng get coordinates => _coordinates;

  @override
  void set location(Location details) {
    // _coordinates = /*details.coordinates*/;
    _address = details.address;
    _city = details.city;

    SharedPreferences.getInstance().then((value) {
      value.setString('city', _city);
      value.setString('address', _address);
      value.setDouble('latitude', _coordinates.latitude);
      value.setDouble('latitude', _coordinates.latitude);
      value.setDouble('longitude', _coordinates.longitude);
    });
  }

  @override
  Location get location => Location(
    city: city, address: address, /*coordinates: coordinates*/
  );


  // Future<bool> get isFirstRun async =>
  //   (await SharedPreferences.getInstance()).getBool('firstTime') ?? true;
  //
  // Customer get user => Hive.box('customer').values?.first;
  // bool get isAuthenticated => Hive.box('customer').isNotEmpty;
  //
  // Future<String> get city async => (await SharedPreferences.getInstance()).getString('city');
  //
  // Future<void> signIn(Customer customer) async {
  //   await Hive.box('customer').add(customer);
  //   await customer.save();
  // }
  //
  // Future<void> signOut() async => await Hive.box('customer').clear();
  //
  // @override
  // Future<bool> get newNotificationAvailable async {
  //   return (await SharedPreferences.getInstance())
  //       .getBool('newNotificationAvailable');
  // }
}