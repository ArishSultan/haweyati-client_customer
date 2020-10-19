import 'dart:ui';

import 'package:hive/hive.dart';
import 'models/image_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:haweyati/src/models/user_model.dart';
import 'package:haweyati/src/models/image_model.dart';
import 'models/services/finishing-material/model.dart';
import 'package:haweyati/src/models/profile_model.dart';
import 'package:haweyati/src/models/location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haweyati/src/models/notification_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'models/services/finishing-material/options_model.dart';
import 'package:haweyati/src/services/notifications_service.dart';
import 'package:haweyati/src/common/services/jwt-auth_service.dart';
import 'package:haweyati/src/models/services/finishing-material/model.dart';
import 'package:haweyati/src/models/services/finishing-material/options_model.dart';

abstract class AppData {
  /// Localization Specific Data
  ValueNotifier<Locale> currentLocale;
  set locale(Locale locale);

  /// Authentication Data
  User get user;
  bool get isAuthenticated;

  /// Address specific Data
  String get city;
  String get address;
  LatLng get coordinates;

  Location get location;
  set location(Location details);

  /// These controls determine weather the
  /// app has been launched before or not.
  Future<void> burnFuse();
  Future<bool> get isFuseBurnt;

  /// Products Cart.
  final ValueNotifier<int> cartSize;
  Future<void> addToCart(FinishingMaterial holder);
  Stream<List<FinishingMaterial>> getCartProducts();
  Future<bool> canAddToCart(FinishingMaterial holder);
  Future<void> removeFromCart(FinishingMaterial holder);

  /// Notifications.

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

    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ProfileAdapter());
    Hive.registerAdapter(LocationAdapter());
    Hive.registerAdapter(ImageModelAdapter());
    Hive.registerAdapter(NotificationAdapter());
    Hive.registerAdapter(NotificationDataAdapter());
    Hive.registerAdapter(FinishingMaterialAdapter());
    Hive.registerAdapter(StoreableNotificationAdapter());
    Hive.registerAdapter(FinishingMaterialOptionAdapter());

    await Hive.openBox<User>('customers');
    await Hive.openLazyBox<FinishingMaterial>('cart');
    await Hive.openBox<StoreableNotification>('notifications');

    _initiated = true;
    _instance = _AppDataImpl();
    await _instance._loadCache();
  }
}

class _AppDataImpl implements AppData {
  String _city;
  String _address;
  LatLng _coordinates;

  Future _loadCache() async {
    final preferences = await SharedPreferences.getInstance();

    currentLocale.value = Locale.fromSubtags(
      languageCode: preferences.getString('locale') ?? 'en'
    );

    _city = preferences.getString('city');
    _address = preferences.getString('address');

    try {
      _coordinates = LatLng(
        preferences.getDouble('latitude'),
        preferences.getDouble('longitude')
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
  set location(Location details) {
    _coordinates = LatLng(
      details.latitude,
      details.longitude
    );
    _city = details.city;
    _address = details.address;

    SharedPreferences.getInstance().then((value) {
      value.setString('city', _city);
      value.setString('address', _address);
      value.setDouble('latitude', _coordinates.latitude);
      value.setDouble('latitude', _coordinates.latitude);
      value.setDouble('longitude', _coordinates.longitude);
    });
  }

  @override
  Location get location {
    if (coordinates != null) {
      return Location(
        city: city, address: address,
        latitude: coordinates.latitude,
        longitude: coordinates.longitude
      );
    } else {
      return null;
    }
  }

  @override
  ValueNotifier<int> get cartSize => ValueNotifier(
    Hive.lazyBox<FinishingMaterial>('cart').length
  );

  @override
  Stream<List<FinishingMaterial>> getCartProducts() async* {
    final list = [];
    final box = Hive.lazyBox('cart');

    for (final key in box.keys) {
      list.add(await box.get(key));

      yield list;
    }
  }

  @override
  Future<void> addToCart(FinishingMaterial holder) async {
    await Hive
        .lazyBox<FinishingMaterial>('cart')
        .put(holder.id, holder);
    await holder.save();

    ++cartSize.value;
  }

  @override
  Future<void> removeFromCart(FinishingMaterial holder) async {
    await Hive
        .lazyBox<FinishingMaterial>('cart')
        .delete(holder.id);

    --cartSize.value;
  }

  @override
  Future<bool> canAddToCart(FinishingMaterial holder) async =>
    !(Hive.lazyBox<FinishingMaterial>('cart').containsKey(holder.id));

  final _authService = JwtAuthService.create();

  @override User get user => _authService.user;
  @override bool get isAuthenticated => _authService.isAuthenticated;

  @override
  ValueNotifier<Locale> currentLocale = ValueNotifier(null);

  @override
  set locale(Locale _locale) {
    SharedPreferences.getInstance().then((value) {
      value.setString('locale', currentLocale.value.languageCode);
    });

    currentLocale.value = _locale;
  }
}