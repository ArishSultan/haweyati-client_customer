import 'package:haweyati/pages/building-material/building-material-List.dart';
import 'package:haweyati/pages/dumpster/list_page.dart';
import 'package:haweyati/pages/finishing-material/finishing-material-List.dart';
import 'package:haweyati/pages/helpline_page.dart';
import 'package:haweyati/pages/locations-map_page.dart';
import 'package:haweyati/pages/map/location.dart';
import 'package:haweyati/pages/scaffolding/scaffoldings/computed/ceiling-caculation_page.dart';
import 'package:haweyati/pages/scaffolding/scaffoldings/computed/facades-calculation_page.dart';
import 'package:haweyati/pages/scaffolding/scaffoldings/list_page.dart';
import 'package:haweyati/pages/scaffolding/scaffoldings/patented-options_page.dart';
import 'package:haweyati/pages/scaffolding/scaffoldings/steel-options_page.dart';
import 'package:haweyati/pages/vehicles-map_page.dart';
import 'package:haweyati/src/ui/pages/customer-registration_page.dart';
import 'package:haweyati/src/ui/pages/features_page.dart';
import 'package:haweyati/src/ui/pages/notification.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/location/pre-location_page.dart';
import 'ui/pages/signin_page.dart';

final routes = {
  "/": (context) => AppHomePage(),
  "/features": (context) => FeaturesPage(),
  "/helpline": (context) => HelplinePage(),
  "/pre-location": (context)=> Location(),
  "/select-location": (context)=> MyLocationMapPage(),
  "/dumpsters-list": (context) => DumpstersListPage(),
  "/registration": (context) => CustomerRegistration(),
  "/sign-in": (context) => SignInPage(),

  "/pre-location": (context) => PreLocationPage(),
  "/notifications": (context) => NotificationsPage(),

  /// Construction Dumpsters.
  "/vehicles-list": (context) => VehiclesMapPage(),
  "/dumpsters-list": (context) => DumpstersListPage(),
  "/building-materials-list": (context) => BuildingMaterialListing(),
  "/finishing-materials-list": (context) => FinishingMaterialListing(),

  /// Scaffolding
  "/scaffoldings-list": (context) => ScaffoldingsListPage(),
//  "/scaffolding-details": (context) => ,
  "/scaffoldings-facades": (context) => FacadesCalculationPage(),
  "/scaffoldings-ceiling": (context) => CeilingCalculationPage(),
  "/steel-scaffolding-options": (context) => SteelOptionsPage(),
  "/patented-scaffolding-options": (context) => PatentedOptionsPage(),

//  "/payments": (context)=> HomePage(),
//  "/existing-cards": (context)=> HomePage(),
};