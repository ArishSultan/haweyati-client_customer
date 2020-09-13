import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/common/services/jwt-auth_service.dart';
import 'package:haweyati/src/ui/pages/locations-map_page.dart';
import 'package:haweyati/pages/scaffolding/scaffoldings/computed/ceiling-caculation_page.dart';
import 'package:haweyati/pages/scaffolding/scaffoldings/computed/facades-calculation_page.dart';
import 'package:haweyati/src/ui/pages/services/finishing-material/categories-list_page.dart';
import 'package:haweyati/src/ui/pages/services/scaffolding/options/patented-options_page.dart';
import 'package:haweyati/src/ui/pages/services/scaffolding/options/steel-options_page.dart';
import 'package:haweyati/src/ui/pages/services/building-material/categories-list_page.dart';
import 'package:haweyati/pages/vehicles-map_page.dart';
import 'package:haweyati/src/ui/pages/contact-number_page.dart';
import 'package:haweyati/src/ui/pages/customer-registration_page.dart';
import 'package:haweyati/src/ui/pages/rate-app_page.dart';
import 'package:haweyati/src/ui/pages/dummy/rewards_page.dart';
import 'package:haweyati/src/ui/pages/dummy/settings_page.dart';
import 'package:haweyati/src/ui/pages/dummy/share-and-invite_page.dart';
import 'package:haweyati/src/ui/pages/services/dumpster/list_page.dart';
import 'package:haweyati/src/ui/pages/services/scaffolding/list_page.dart';
import 'package:haweyati/src/ui/pages/terms-and-conditions_page.dart';
import 'package:haweyati/src/ui/pages/features_page.dart';
import 'package:haweyati/src/ui/pages/helpline_page.dart';
import 'package:haweyati/src/ui/pages/home_page.dart';
import 'package:haweyati/src/utils/app-data.dart';
import 'ui/pages/location/pre-location_page.dart';
import 'ui/pages/signin_page.dart';

final routes = <String, Widget Function(BuildContext)>{
  '/': (context) {
    return HomePage();
    print(JwtAuthService.create().isAuthenticated);
    if (AppData.instance().coordinates != null) {
      if (JwtAuthService.create().isAuthenticated) {
        return HomePage();
      } else {
        return SignInPage();
      }
    } else {
      return PreLocationPage();
    }
  },
  "/features": (context) => FeaturesPage(),
  "/helpline": (context) => HelplinePage(),
  "/pre-location": (context) => PreLocationPage(),
  // "/select-location": (context) => MyLocationMapPage(),
  // "/dumpsters-list": (context) => DumpstersListPage(),
  "/registration": (context) => CustomerRegistration(),
  "/sign-in": (context) => SignInPage(),

  // "/pre-location": (context) => PreLocationPage(),
  "/location": (context) => LocationPickerMapPage(),
  // "/notifications": (context) => NotificationsPage(),

  /// Construction Dumpsters.
  '/dumpsters-list': (context) => DumpstersListPage(),

  /// Scaffolding
  '/scaffoldings-list': (context) => ScaffoldingsListPage(),
  '/scaffoldings-facades': (context) => FacadesCalculationPage(),
  '/scaffoldings-ceiling': (context) => CeilingCalculationPage(),
  '/steel-scaffolding-options': (context) => SteelScaffoldingOptionsPage(),
  '/patented-scaffolding-options': (context) => PatentedOptionsPage(),

  /// Building Materials
  '/building-materials-list': (context) => BuildingMaterialCategoriesListPage(),

  /// Finishing Materials
  '/finishing-materials-list': (context) => FinishingMaterialCategoriesListPage(),

  /// Delivery Vehicles
  '/vehicles-list': (context) => VehiclesMapPage(),
  
  /// Newly Added
  '/pick-contact': (context) => ContactNumberPage(),

  /// Drawer Routes
  '/rate': (context) => RateAppPage(),
  '/rewards': (context) => RewardsPage(),
  '/settings': (context) => SettingsPage(),
  '/share-and-invite': (context) => ShareAndInvitePage(),
  '/terms-and-conditions': (context) => TermsAndConditionsPage()
};