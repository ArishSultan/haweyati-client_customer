
import 'dart:async';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: 0.16.1
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : assert(locale != null), localeName = intl.Intl.canonicalizedLocale(locale.toString());

  // ignore: unused_field
  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @ourServices.
  ///
  /// In en, this message translates to:
  /// **'Our Services'**
  String get ourServices;

  /// No description provided for @ourServicesDescription.
  ///
  /// In en, this message translates to:
  /// **'Renting different sizes of construction dumpsters and different types of scaffolding. By just easy steps, it will be delivered to your site.'**
  String get ourServicesDescription;

  /// No description provided for @ourProducts.
  ///
  /// In en, this message translates to:
  /// **'Our Products'**
  String get ourProducts;

  /// No description provided for @ourProductsDescription.
  ///
  /// In en, this message translates to:
  /// **'You can buy any building & finishing materials as per your location & time schedule without contacting with any person.'**
  String get ourProductsDescription;

  /// No description provided for @ourTrucks.
  ///
  /// In en, this message translates to:
  /// **'Our Trucks'**
  String get ourTrucks;

  /// No description provided for @ourTrucksDescription.
  ///
  /// In en, this message translates to:
  /// **'Need to transfer your materials?Rent the right truck type to suit your materials volume with the right price'**
  String get ourTrucksDescription;

  /// No description provided for @paymentAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Payment & Security'**
  String get paymentAndSecurity;

  /// No description provided for @paymentAndSecurityDescription.
  ///
  /// In en, this message translates to:
  /// **'Pay with Mada, Visa/Mater Card and Apple pay for a secure & hands free deals, or choose cash on delivery option.'**
  String get paymentAndSecurityDescription;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locationDescription.
  ///
  /// In en, this message translates to:
  /// **'Please select your site location. This location will be used to show the services & delivering your items. You can edit this location at any time.'**
  String get locationDescription;

  /// No description provided for @setYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Set Your Location'**
  String get setYourLocation;

  /// No description provided for @useLocation.
  ///
  /// In en, this message translates to:
  /// **'Use Location?'**
  String get useLocation;

  /// No description provided for @useLocationMessage1.
  ///
  /// In en, this message translates to:
  /// **'This app wants to change your device settings.'**
  String get useLocationMessage1;

  /// No description provided for @useLocationMessage2.
  ///
  /// In en, this message translates to:
  /// **'Use Wifi and mobile networks for location'**
  String get useLocationMessage2;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @fetchingCurrentCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Fetching Current Coordinates'**
  String get fetchingCurrentCoordinates;

  /// No description provided for @fetchingLocationData.
  ///
  /// In en, this message translates to:
  /// **'Fetching Location Data'**
  String get fetchingLocationData;

  /// No description provided for @changingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Changing Language'**
  String get changingLanguage;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get no;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore our products and services'**
  String get explore;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Order'**
  String get myOrders;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @inviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get inviteFriends;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @enterCredentials.
  ///
  /// In en, this message translates to:
  /// **'Enter your Credentials'**
  String get enterCredentials;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing In'**
  String get signingIn;

  /// No description provided for @signingOut.
  ///
  /// In en, this message translates to:
  /// **'Signing Out'**
  String get signingOut;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @yourPhone.
  ///
  /// In en, this message translates to:
  /// **'Your Phone'**
  String get yourPhone;

  /// No description provided for @yourPassword.
  ///
  /// In en, this message translates to:
  /// **'Your Password'**
  String get yourPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @scaffoldings.
  ///
  /// In en, this message translates to:
  /// **'Scaffoldings'**
  String get scaffoldings;

  /// No description provided for @buildingMaterials.
  ///
  /// In en, this message translates to:
  /// **'Building Materials'**
  String get buildingMaterials;

  /// No description provided for @finishingMaterials.
  ///
  /// In en, this message translates to:
  /// **'Finishing Materials'**
  String get finishingMaterials;

  /// No description provided for @constructionDumpsters.
  ///
  /// In en, this message translates to:
  /// **'Construction Dumpsters'**
  String get constructionDumpsters;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'{price}'**
  String price(double price);

  /// No description provided for @nProducts.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{1 Product} other{{count} Products}}'**
  String nProducts(int count);

  /// No description provided for @nItem.
  ///
  /// In en, this message translates to:
  /// **'{count,plural,=0{No Items} =1{1 Item} other{{count} Items}}'**
  String nItem(int count);

  /// No description provided for @nPieces.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{None} =1{1 Piece} other{{count} Pieces}}'**
  String nPieces(int count);

  /// No description provided for @nDays.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{None} =1{1 Day} other{{count} Days}}'**
  String nDays(int count);

  /// No description provided for @orderConfirmationPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Hello User,'**
  String get orderConfirmationPageTitle;

  /// No description provided for @orderConfirmationPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your order details and your order reference number will be generated'**
  String get orderConfirmationPageSubtitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(_lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations _lookupAppLocalizations(Locale locale) {
  


// Lookup logic when only language code is specified.
switch (locale.languageCode) {
  case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
}

  assert(false, 'AppLocalizations.delegate failed to load unsupported locale "$locale"');
  return null;
}
