import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HaweyatiLocalizations {
  final Locale locale;
  HaweyatiLocalizations(this.locale);

  static HaweyatiLocalizations of(BuildContext context) {
    return Localizations.of<HaweyatiLocalizations>(context, HaweyatiLocalizations);
  }

  static const delegate = const HaweyatiLocalizationsDelegate();

  /// Here goes all the messages.
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
  String get skip => Intl.message(
    'Skip',
    name: 'skip',
    desc: "Text for a 'Skip Button' on Features Page's `AppBar`"
  );
}

class HaweyatiLocalizationsDelegate extends LocalizationsDelegate<HaweyatiLocalizations> {
  static const _supported = ['en', 'ar'];
  const HaweyatiLocalizationsDelegate();

  @override bool isSupported(Locale locale) =>
      _supported.contains(locale.languageCode);

  @override Future<HaweyatiLocalizations> load(Locale locale) {
    print(locale);
    return SynchronousFuture<HaweyatiLocalizations>(HaweyatiLocalizations(locale));
  }

  @override bool shouldReload(LocalizationsDelegate<dynamic> old) => true;
}