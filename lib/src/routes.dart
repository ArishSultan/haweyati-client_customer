import 'data.dart';
import 'package:flutter/widgets.dart';
import 'package:haweyati/src/ui/pages/cart/cart_page.dart';
import 'package:haweyati/src/ui/pages/orders/my-orders_page.dart';
import 'ui/pages/auth/sign-in_page.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/location/locations-map_page.dart';
import 'ui/pages/location/pre-location_page.dart';
import 'ui/pages/miscellaneous/features_page.dart';
import 'ui/pages/miscellaneous/helpline_page.dart';
import 'ui/pages/miscellaneous/notifications_page.dart';
import 'ui/pages/miscellaneous/rate-app_page.dart';
import 'ui/pages/miscellaneous/rewards_page.dart';
import 'ui/pages/miscellaneous/settings_page.dart';
import 'ui/pages/miscellaneous/share-and-invite_page.dart';
import 'ui/pages/miscellaneous/terms-and-conditions_page.dart';
import 'ui/pages/services/building-material/categories-list_page.dart';
import 'ui/pages/services/dumpster/list_page.dart';
import 'ui/pages/services/finishing-material/categories-list_page.dart';
import 'ui/pages/services/scaffolding/calculations/ceiling-calculation_page.dart';
import 'ui/pages/services/scaffolding/calculations/facades-calculation_page.dart';
import 'ui/pages/services/scaffolding/list_page.dart';
import 'ui/pages/services/scaffolding/options/patented-options_page.dart';
import 'ui/pages/services/scaffolding/options/steel-options_page.dart';

final routes = <String, Widget Function(BuildContext)>{
  HOME_PAGE: (context) {
    /// Check whether the user is Authenticated
    final _appData = AppData.instance();

    /// Check whether user location is saved.
    if (_appData.location != null) {
      return HomePage();
    } else {
      return PreLocationPage();
    }
  },

  /// Authentication Routes.
  ///
  /// These are used for opening pages related to authentication
  /// Such as, `Signing In a user` or `Registering a User`
  SIGN_IN_PAGE: (context) => SignInPage(),
  REGISTRATION_PAGE: (context) => SignInPage(),

  PRE_LOCATION_PAGE: (context) => PreLocationPage(),
  LOCATION_PICKER_MAP_PAGE: (context) => LocationPickerMapPage(),
  
  /// Construction Dumpsters Routes.
  DUMPSTERS_LIST_PAGE: (context) => DumpstersListPage(),

  /// Scaffolding Routes.
  SCAFFOLDINGS_LIST_PAGE: (context) => ScaffoldingsListPage(),
  FACADES_CALCULATION_PAGE: (context) => FacadesCalculationPage(),
  CEILING_CALCULATION_PAGE: (context) => CeilingCalculationPage(),
  STEEL_SCAFFOLDING_OPTIONS_PAGE: (context) => SteelScaffoldingOptionsPage(),
  PATENTED_SCAFFOLDING_OPTIONS_PAGE: (context) => PatentedScaffoldingOptionsPage(),

  /// Building Material Routes.
  BUILDING_MATERIALS_LIST_PAGE: (context) => BuildingMaterialCategoriesListPage(),
  
  /// Finishing Material Routes.
  FINISHING_MATERIALS_LIST_PAGE: (context) => FinishingMaterialCategoriesListPage(),
  
  /// Miscellaneous Routes.
  ///
  /// These routes have nothing to do much with business logic,
  /// they just act as utility or a gateway / wrapper for other
  /// pages.
  REWARDS_PAGE: (context) => RewardsPage(),
  RATE_APP_PAGE: (context) => RateAppPage(),
  FEATURES_PAGE: (context) => FeaturesPage(),
  HELPLINE_PAGE: (context) => HelplinePage(),
  SETTINGS_PAGE: (context) => SettingsPage(),
  NOTIFICATIONS_PAGE: (context) => NotificationsPage(),
  SHARE_AND_INVITE_PAGE: (context) => ShareAndInvitePage(),
  TERMS_AND_CONDITIONS_PAGE: (context) => TermsAndConditionsPage(),

  /// Orders History/Status Routes.
  // ORDER_PLACED_PAGE: (context) =>
  CART_PAGE: (context) => CartPage(),
  MY_ORDERS_PAGE: (context) => MyOrdersPage(),
};

const REWARDS_PAGE = '0';
const RATE_APP_PAGE = '1';
const FEATURES_PAGE = '2';
const HELPLINE_PAGE = '3';
const SETTINGS_PAGE = '4';
const NOTIFICATIONS_PAGE = '5';
const SHARE_AND_INVITE_PAGE = '6';
const TERMS_AND_CONDITIONS_PAGE = '7';

const HOME_PAGE = '/';
const SIGN_IN_PAGE = '8';
const REGISTRATION_PAGE = '9';
const PRE_LOCATION_PAGE = '10';
const LOCATION_PICKER_MAP_PAGE = '11';

const DUMPSTERS_LIST_PAGE = 'hu';

const SCAFFOLDINGS_LIST_PAGE = '13';
const FACADES_CALCULATION_PAGE = '14';
const CEILING_CALCULATION_PAGE = '15';
const STEEL_SCAFFOLDING_OPTIONS_PAGE = '16';
const PATENTED_SCAFFOLDING_OPTIONS_PAGE = '17';

const BUILDING_MATERIALS_LIST_PAGE = '18';

const FINISHING_MATERIALS_LIST_PAGE = '19';

const MY_ORDERS_PAGE = '20';
const ORDER_PLACED_PAGE = '21';
const CART_PAGE = '22';
