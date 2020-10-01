import 'dart:ui';
import 'package:intl/intl.dart';
import 'outputs/messages_all.dart';
import 'package:flutter/widgets.dart';

class HaweyatiLocalizations {
  static Future<HaweyatiLocalizations> load(Locale locale) {
    final String localeName = Intl.canonicalizedLocale(locale.languageCode);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return HaweyatiLocalizations();
    });
  }

  static HaweyatiLocalizations of(BuildContext context) {
    return Localizations.of<HaweyatiLocalizations>(context, HaweyatiLocalizations);
  }

  static const delegate = const HaweyatiLocalizationsDelegate();

  /// Features Page Messages. (Start)

  /// Features Page Tab # 1
  String get ourServices => Intl.message(
    'Our Services',

    name: 'ourServices',
    desc: "A title for 'Our Services' Tab on Features Page"
  );
  String get ourServicesDescription => Intl.message(
    'Renting different sizes of construction dumpsters and '
    'different types of scaffolding. By just easy steps, it '
    'will be delivered to your site.',

    name: 'ourServicesDescription',
    desc: "A description for 'Our Services' Tab on Features Page"
  );

  /// Features Page Tab # 2
  String get ourProducts => Intl.message(
    'Our Products',

    name: 'ourProducts',
    desc: "A title for 'Our Products' Tab on Features Page"
  );
  String get ourProductsDescription => Intl.message(
    'You can buy any building & finishing materials as per '
    'your location & time schedule without contacting with any person.',

    name: 'ourProductsDescription',
    desc: "A description for 'Our Products' Tab on Features Page"
  );

  /// Features Page Tab # 3
  String get ourTrucks => Intl.message(
    'Our Trucks',

    name: 'ourTrucks',
    desc: "A title for 'Our Trucks' Tab on Features Page"
  );
  String get ourTrucksDescription => Intl.message(
    'Need to transfer your materials?Rent the right truck type '
    'to suit your materials volume with the right price',

    name: 'ourTrucksDescription',
    desc: "A description for 'Our Trucks' Tab on Features Page"
  );

  /// Features Page Tab # 4
  String get paymentAndSecurity => Intl.message(
    'Payment & Security',

    name: 'paymentAndSecurity',
    desc: "A title for 'Payment & Security' Tab on Features Page"
  );
  String get paymentAndSecurityDescription => Intl.message(
    'Please select your site location. This location will be used to '
    'show the services & delivering your items. You can edit this location at any time.',

    name: 'paymentAndSecurityDescription',
    desc: "A description for 'Payment & Security' Tab on Features Page"
  );

  /// Features Page Skip Button Text
  String get skip => Intl.message(
    'Skip',
    name: 'skip',
    desc: "Text for a 'Skip Button' on Features Page's `AppBar`"
  );

  /// Features Page Messages. (End)
  ///
  /// -------------------------------------------------------------------------------
  ///
  /// Home Page Messages. (Start)

  String get vehicles => Intl.message('Vehicles');
  String get scaffolding => Intl.message('Scaffolding');
  String get buildingMaterial => Intl.message('Building Material');
  String get finishingMaterial => Intl.message('Finishing Material');
  String get constructionDumpsters => Intl.message('Construction Dumpster');

  /// Home Page Messages. (End)
  ///
  /// -------------------------------------------------------------------------------
  ///

}

class HaweyatiLocalizationsDelegate extends LocalizationsDelegate<HaweyatiLocalizations> {
  static const _supported = ['en', 'ar'];
  const HaweyatiLocalizationsDelegate();

  @override bool shouldReload(LocalizationsDelegate<dynamic> old) => true;
  @override bool isSupported(Locale locale) => _supported.contains(locale.languageCode);
  @override Future<HaweyatiLocalizations> load(Locale locale) => HaweyatiLocalizations.load(locale);
}