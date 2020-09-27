import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/common/widgets/badged-widget.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/services/finishing-material/model.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/src/services/service-availability_service.dart';
import 'package:haweyati/src/ui/widgets/localization-selector.dart';
import 'package:haweyati/src/utils/const.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../routes.dart';
import '../../utils/custom-navigator.dart';
import '../views/live-scrollable_view.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _appData = AppData.instance();
  final _service = AvailabilityService();
  final _drawerKey = GlobalKey<ScaffoldState>();
  ValueListenable<LazyBox<FinishingMaterial>> _cart;

  @override
  void initState() {
    super.initState();

    _cart = Hive.lazyBox<FinishingMaterial>('cart').listenable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)
          )
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF313F53),
        title: Image.asset(AppLogo, width: 40, height: 40),
        leading: IconButton(
          icon: Image.asset(MenuIcon, width: 20, height: 20),
          onPressed: () => _drawerKey.currentState.openDrawer()
        ),
        actions: <Widget>[
          IconButton(
            icon: Image.asset(CustomerCareIcon, width: 20, height: 20),
            onPressed: () => Navigator.of(context).pushNamed(HELPLINE_PAGE)
          ),
          IconButton(
            /// TODO: Fix This.
            icon: Image.asset(NotificationIcon, width: 20, height: 20),
            onPressed: () => Navigator.of(context).pushNamed('/notifications')
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(160),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppLogoBg),
                fit: BoxFit.scaleDown,
                alignment: Alignment(1, -0.6)
              ),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(children: <Widget>[
              Text(tr('hello'), style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
              Padding(padding: const EdgeInsets.only(top: 8, bottom: 20), child: Text(tr('explore'), style: TextStyle(color: Colors.white))),

              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: CupertinoTextField(
                  onTap: () async {
                    final location = await Navigator.of(context).pushNamed(PRE_LOCATION_PAGE);

                    if (location != null) {
                      _appData.location = location;
                      setState(() {});
                    }
                  },
                  padding: EdgeInsets.fromLTRB(0, 9, 5, 9),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  controller: TextEditingController(text: _appData.address),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14
                  ),
                  readOnly: true,
                  prefix: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10
                    ),
                    child: Image.asset(LocationIcon, height: 19)
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
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                child: LocalizationSelector(
                  selected: EasyLocalization.of(context).locale,
                  onChanged: (locale) {
                    setState(() => EasyLocalization.of(context).locale = locale);
                  },
                ),
              ),
              Center(child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                foregroundColor: Colors.white,
//                  backgroundImage: (!HaweyatiData.isSignedIn || HaweyatiData.customer?.profile?.image ==null) ? AssetImage("assets/images/building.png")
//                  : NetworkImage(HaweyatiService.convertImgUrl(HaweyatiData.customer.profile.image.name)),
              )),
              // Padding(
              //   padding: const EdgeInsets.only(top: 15),
              //   child: Center(child: Text(AppData.instance.user.profile.name, style: TextStyle(
              //     fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold
              //   ))),
              // ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(child: FlatButton.icon(
                  onPressed: null,
                  icon: Image.asset('assets/images/star_outlined.png', width: 20, height: 20),
                  label: Text('Rated 5.0', style: TextStyle(color: Colors.white))
                )),
              ),

              Expanded(child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  _ListTile(context,
                    image: OrderIcon,
                    title: tr('My_Orders'),
                  // navigateTo: () =>
                  //  CustomNavigator.navigateTo(context, ViewAllOrders());
                  ),
                  _ListTile(context,
                    image: SettingsIcon,
                    title: tr('Settings'),
                    navigateTo: SETTINGS_PAGE,
                  ),
                  _ListTile(context,
                    image: AccountIcon,
                    title: tr('Invite_Friends'),
                    navigateTo: SHARE_AND_INVITE_PAGE,
                  ),
                  _ListTile(context,
                    image: OrderIcon,
                    title: tr('Rewards'),
                    navigateTo: REWARDS_PAGE,
                  ),
                  _ListTile(context,
                    image: TermIcon,
                    title: tr('Terms_Conditions'),
                    navigateTo: TERMS_AND_CONDITIONS_PAGE,
                  ),
                  _ListTile(context,
                    image: StarIconOutlined,
                    title: tr('Rate App'),
                    navigateTo: RATE_APP_PAGE,
                  ),
                  _ListTile(context,
                    image: LogoutIcon,
                    title: tr('Logout'),
                    // navigateTo: '/log-out',
                  )
               ]),
             ))
            ], crossAxisAlignment: CrossAxisAlignment.start),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          10, 230, 10, 0
        ),
        child: LiveScrollableView<String>(
          header: Padding(padding: const EdgeInsets.only(top: 21)),
          loader: () => _service.getAvailableServices(_appData.city),
          builder: (context, string) => _ServiceContainer(string)
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
                onPressed: () => navigateTo(context, CartPage()),
                child: Image.asset(CartIcon, width: 30, height: 30, color: Colors.black)
              ),
            ),
          );
        }
      )
    );
  }
}

class _ListTile extends ListTile {
  _ListTile(BuildContext context, {
    Icon icon,
    String image,
    String title,
    String navigateTo,
    Function onPressed,
  }): super(
    dense: true,
    onTap: onPressed ?? () {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(navigateTo);
    },
    leading: image != null ? Image.asset(image, width: 20, height: 30): icon,
    title: Text(title, style: TextStyle(color: Colors.white, fontFamily: 'Helvetica'))
  );
}
class _ServiceContainerDetail {
  final String page;
  final String title;
  final String image;

  const _ServiceContainerDetail({
    this.page, this.title, this.image
  });
}

class _ServiceContainer extends StatelessWidget {
  final String service;
  _ServiceContainer(this.service);

  static const _map = {
    'Construction Dumpster': const _ServiceContainerDetail(
      page: DUMPSTERS_LIST_PAGE,
      title: 'Construction_Dumpster',
      image: ConstructionDumpsterServiceImage
    ),
    'Scaffolding': const _ServiceContainerDetail(
      title: 'Scaffolding',
      page: SCAFFOLDINGS_LIST_PAGE,
      image: ScaffoldingServiceImage
    ),
    'Building Material': const _ServiceContainerDetail(
      title: 'building',
      page: BUILDING_MATERIALS_LIST_PAGE,
      image: BuildingMaterialsServiceImage
    ),
    'Finishing Material': const _ServiceContainerDetail(
      title: 'Finishing_Materials',
      page: FINISHING_MATERIALS_LIST_PAGE,
      image: FinishingMaterialsServiceImage
    ),
    'Delivery Vehicle': const _ServiceContainerDetail(
      title: 'vehicles',
      page: '/scaffoldings-list',
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
          borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: Text(tr(service.title), style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold
          )),
        ),
      )
    );
  }
}

