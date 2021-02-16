import 'dart:ui';
import 'package:haweyati/src/common/modals/confirmation-dialog.dart';
import 'package:haweyati/src/rest/notifications_service.dart';
import 'package:haweyati/src/services/dynamic-links_service.dart';
import 'package:haweyati/src/ui/widgets/rating-bar.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/routes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:haweyati/l10n/app_localizations.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:haweyati/src/rest/_new/auth_service.dart';
import 'package:haweyati/src/ui/views/localized_view.dart';
import 'package:haweyati/src/common/widgets/badged-widget.dart';
import 'package:haweyati/src/ui/views/live-scrollable_view.dart';
import 'package:haweyati/src/rest/_new/availability_service.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/widgets/localization-selector.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _appData = AppData();
  final _service = AvailabilityService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueListenable<LazyBox<FinishingMaterial>> _cart;

  @override
  void initState() {
    super.initState();
    //Todo: Commenting dynamics link temporarily
    // DynamicLinksService.initiate(context);
    _cart = Hive.lazyBox<FinishingMaterial>('cart').listenable();
    TempNotificationService().setup(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final result = await showDialog(
            context: context,
            child: ConfirmationDialog(
              title: Text('Are you sure?'),
              content: Text('App will be closed.'),
            ));

        return result == true;
      },
      child: LocalizedView(
        builder: (context, lang) => Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            centerTitle: true,
            backgroundColor: Color(0xFF313F53),
            title: Image.asset(AppLogo, width: 33, height: 33),
            leading: IconButton(
              icon: Image.asset(MenuIcon, width: 20, height: 20),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
            actions: <Widget>[
              IconButton(
                icon: Image.asset(CustomerCareIcon, width: 20, height: 20),
                onPressed: () => Navigator.of(context).pushNamed(HELPLINE_PAGE),
              ),
              IconButton(
                icon: Image.asset(NotificationIcon, width: 20, height: 20),
                onPressed: () =>
                    Navigator.of(context).pushNamed(NOTIFICATIONS_PAGE),
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(160),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppLogoBg),
                    fit: BoxFit.scaleDown,
                    alignment: Alignment(1, -0.6),
                  ),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(children: <Widget>[
                  Text(
                    lang.hello,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    child: Text(lang.explore,
                        style: TextStyle(color: Colors.white)),
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: CupertinoTextField(
                      onTap: () async {
                        final location = await Navigator.of(context)
                            .pushNamed(PRE_LOCATION_PAGE);

                        if (location != null) {
                          _appData.location = location;
                          setState(() {});
                        }
                      },
                      padding: EdgeInsets.fromLTRB(0, 9, 5, 9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      controller: TextEditingController(text: _appData.address),
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      readOnly: true,
                      prefix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(LocationIcon, height: 19),
                      ),
                    ),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ),
            ),
          ),
          extendBodyBehindAppBar: true,
          drawer: Drawer(
            child: Container(
              color: Color(0xFF313F53),
              constraints: BoxConstraints.expand(),
              child: Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                    child: LocalizationSelector(),
                  ),
                  Center(
                      child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white,
//                  backgroundImage: (!HaweyatiData.isSignedIn || HaweyatiData.customer?.profile?.image ==null) ? AssetImage("assets/images/building.png")
//                  : NetworkImage(HaweyatiService.convertImgUrl(HaweyatiData.customer.profile.image.name)),
                  )),
                  if (_appData.isAuthenticated)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Center(
                        child: Text(
                          _appData.user.name,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (_appData.isAuthenticated &&
                      _appData.user.profile.hasScope('customer'))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Center(child: StarRating()),
                    )
                  else
                    SizedBox(height: 50),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: <Widget>[
                        if (_appData.isAuthenticated)
                          _ListTile(
                            context,
                            image: OrderIcon,
                            title: lang.myOrders,
                            navigateTo: MY_ORDERS_PAGE,
                          ),
                        _ListTile(
                          context,
                          image: SettingsIcon,
                          title: lang.settings,
                          navigateTo: SETTINGS_PAGE,
                        ),
                        _ListTile(
                          context,
                          image: AccountIcon,
                          title: lang.inviteFriends,
                          navigateTo: SHARE_AND_INVITE_PAGE,
                        ),
                        _ListTile(
                          context,
                          image: OrderIcon,
                          title: lang.rewards,
                          navigateTo: REWARDS_PAGE,
                        ),
                        _ListTile(
                          context,
                          image: TermIcon,
                          title: lang.termsAndConditions,
                          navigateTo: TERMS_AND_CONDITIONS_PAGE,
                        ),
                        _ListTile(context,
                            image: StarIconOutlined,
                            title: lang.rateApp, onPressed: () async {
                          Navigator.of(context).pop();
                          // final inAppReview = InAppReview.instance;

                          // if (await inAppReview.isAvailable()) {
                          //   inAppReview.requestReview();
                          // } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('App Review is not available yet.'),
                          ));
                          // }
                        }),
                        if (_appData.isAuthenticated &&
                            _appData.user.profile.hasScope('customer'))
                          _ListTile(
                            context,
                            image: LogoutIcon,
                            title: lang.signOut,
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => WaitingDialog(
                                  message: lang.signingOut,
                                ),
                              );

                              try {
                                await AuthService.signOut();
                                Navigator.of(context)..pop()..pop();

                                _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('You are now in guest mode.'),
                                  ),
                                );

                                setState(() {});
                              } catch (err) {
                                Navigator.of(context).pop();
                                print(err);
                              }
                            },
                          )
                        else
                          _ListTile(
                            context,
                            icon: Icon(Icons.login, color: Colors.white),
                            title: lang.signIn,
                            onPressed: () async {
                              await (Navigator.of(context)..pop())
                                  .pushNamed(SIGN_IN_PAGE);
                              print("Is Guest");
                              print(_appData.user.profile.isGuest);
                              if (_appData.isAuthenticated &&
                                  !_appData.user.profile.isGuest) {
                                setState(() {});
                                _scaffoldKey.currentState.hideCurrentSnackBar(
                                  reason: SnackBarClosedReason.remove,
                                );
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      'You are now Signed in as ${_appData.user.name}'),
                                ));
                              }
                            },
                          )
                      ]),
                    ),
                  )
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 230, 10, 0),
            child: LiveScrollableView<String>(
              header: Padding(padding: const EdgeInsets.only(top: 21)),
              loader: () => _service.getAvailableServices(_appData.city),
              builder: (context, string) => _ServiceContainer(string, lang),
            ),
          ),
          floatingActionButton: ValueListenableBuilder(
            valueListenable: _cart,
            builder: (context, val, widget) {
              return BadgedWidget.numbered(
                size: 65,
                number: val.length,
                child: SizedBox(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    elevation: 5,
                    backgroundColor: Colors.white,
                    onPressed: () => Navigator.of(context).pushNamed(CART_PAGE),
                    child: Image.asset(
                      CartIcon,
                      width: 30,
                      height: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ListTile extends ListTile {
  _ListTile(
    BuildContext context, {
    Icon icon,
    String image,
    String title,
    String navigateTo,
    Function onPressed,
  }) : super(
          dense: true,
          onTap: onPressed ??
              () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(navigateTo);
              },
          leading:
              image != null ? Image.asset(image, width: 20, height: 30) : icon,
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontFamily: 'Helvetica'),
          ),
        );
}

class _ServiceContainerDetail {
  final String page;
  final String image;
  final String Function(AppLocalizations) title;

  const _ServiceContainerDetail({this.page, this.title, this.image});
}

class _ServiceContainer extends StatelessWidget {
  final String service;
  final AppLocalizations lang;

  _ServiceContainer(this.service, this.lang);

  static final _map = {
    'Construction Dumpster': _ServiceContainerDetail(
      page: DUMPSTERS_LIST_PAGE,
      title: (lang) => lang.constructionDumpsters,
      image: ConstructionDumpsterServiceImage,
    ),
    'Scaffolding': _ServiceContainerDetail(
      title: (lang) => lang.scaffoldings,
      page: SCAFFOLDINGS_LIST_PAGE,
      image: ScaffoldingServiceImage,
    ),
    'Building Material': _ServiceContainerDetail(
      title: (lang) => lang.buildingMaterials,
      page: BUILDING_MATERIALS_LIST_PAGE,
      image: BuildingMaterialsServiceImage,
    ),
    'Finishing Material': _ServiceContainerDetail(
      title: (lang) => lang.finishingMaterials,
      page: FINISHING_MATERIALS_LIST_PAGE,
      image: FinishingMaterialsServiceImage,
    ),
    'Delivery Vehicle': _ServiceContainerDetail(
      title: (lang) => lang.vehicles,
      page: DELIVERY_VEHICLES_PAGE,
      image: DeliveryVehiclesServiceImage,
    )
  };

  @override
  Widget build(BuildContext context) {
    final service = _map[this.service];

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(service.page),
      child: Container(
        height: 90,
        margin: const EdgeInsets.only(bottom: 7.5),
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage(service.image),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            service.title(lang),
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
