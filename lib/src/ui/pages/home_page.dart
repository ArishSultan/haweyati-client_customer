import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/utils/app-data.dart';
import 'package:haweyati/src/utils/const.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:haweyati/src/ui/widgets/localization-selector.dart';
import 'package:haweyati/services/service-availability_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _appData = AppData.instance();
  final _service = ServiceAvailability();
  final _drawerKey = GlobalKey<ScaffoldState>();

  Future<List<String>> _availableServices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
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
            onPressed: () => Navigator.of(context).pushNamed('/helpline')
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
                    final location = await Navigator.of(context).pushNamed('/location');

                    if (location != null) {
                      _appData.location = location;
                      setState(() {});
                    }
                  },
                  padding: EdgeInsets.fromLTRB(5, 13, 5, 13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  controller: TextEditingController(text: _appData.address),
                  style: TextStyle(color: Colors.black),
                  readOnly: true,
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.location_on,
                      color: Theme.of(context).accentColor,
                    ),
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
                    navigateTo: '/settings',
                  ),
                  _ListTile(context,
                    image: AccountIcon,
                    title: tr('Invite_Friends'),
                    navigateTo: '/share-and-invite',
                  ),
                  _ListTile(context,
                    image: OrderIcon,
                    title: tr('Rewards'),
                    navigateTo: '/rewards',
                  ),
                  _ListTile(context,
                    image: TermIcon,
                    title: tr('Terms_Conditions'),
                    navigateTo: '/terms-and-conditions',
                  ),
                  _ListTile(context,
                    image: StarIconOutlined,
                    title: tr('Rate App'),
                    navigateTo: '/rate',
                  ),
                  _ListTile(context,
                    image: LogoutIcon,
                    title: tr('Logout'),
                    // navigateTo: '/log-out',
                  )
                 //_buildListTile("assets/images/ride.png", "Your Rides",(){CustomNavigator.navigateTo(context, HaweyatiRewards());}),
                 // _buildListTile(
                 //     "", tr(""),(){CustomNavigator.navigateTo(context, HaweyatiSetting());}),
                 // _buildListTile(
                 //     "", tr(""),(){CustomNavigator.navigateTo(context, ShareInvite());}),
                 // _buildListTile("", tr(""),(){CustomNavigator.navigateTo(context, HaweyatiRewards());} ),

                 // _buildListTile(
                 //     "", tr(""),(){CustomNavigator.navigateTo(context, TermAndCondition());}),
                 // _buildListTile("assets/images/rate.png", tr("Rate_App"),(){CustomNavigator.navigateTo(context, Rate());}),
                // HaweyatiData.isSignedIn ? _buildListTile("assets/images/logout.png", tr("Logout"),() {
                //    HaweyatiData.signOut();
                //    Navigator.pop(context);
                //    CustomNavigator.pushReplacement(context, AppHomePage());
                //  }) : SizedBox(),
                // HaweyatiData.isSignedIn ? SizedBox() : ListTile(onTap: (){
                //  CustomNavigator.navigateTo(context, PhoneNumber());
                //   },
                //    leading: Icon(Icons.person_add,color: Colors.white,),title:
                //    Text(tr("Register"),style: TextStyle(color: Colors.white,),),dense: true,)
               ]),
             ))
            ], crossAxisAlignment: CrossAxisAlignment.start),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 230, 10, 0),
        child: CustomScrollView(slivers: <Widget>[
          CupertinoSliverRefreshControl(
            onRefresh: () async => this._availableServices,
          ),
          SliverToBoxAdapter(child: SizedBox(height: 17)),

          SliverList(delegate: SliverChildListDelegate(
            _ServiceContainer._map.keys.map((e) => _ServiceContainer(e)).toList()
          )),
//          SimpleFutureBuilder.simplerSliver(
//              showLoading: false,
//              context: context,
//              future: this._availableServices,
//              builder: (AsyncSnapshot<List<String>> snapshot) {
//                if (snapshot.data.isEmpty) {
//                  return SliverToBoxAdapter(child: Center(child: Text('No services are available in your region')));
//                } else {
//                  return SliverList(delegate: SliverChildBuilderDelegate(
//                          (context, i) => _ServiceContainer(snapshot.data[i]),
//                      childCount: snapshot.data.length
//                  ));
//                }
//              }
//          )
        ]),
      ),
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          elevation: 5,
          backgroundColor: Colors.white,
//            onPressed: () {CustomNavigator.navigateTo(context, ViewAllOrders());},
          child: Image.asset(
            "assets/images/cart.png",
            width: 30,
            height: 30,
            color: Colors.black,
          )
        ),
      ),
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
    title: Text(title, style: TextStyle(color: Colors.white))
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
      page: '/dumpsters-list',
      title: 'Construction_Dumpster',
      image: ConstructionDumpsterServiceImage
    ),
    'Scaffolding': const _ServiceContainerDetail(
      title: 'Scaffolding',
      page: '/scaffoldings-list',
      image: ScaffoldingServiceImage
    ),
    'Building Material': const _ServiceContainerDetail(
      title: 'building',
      page: '/building-materials-list',
      image: BuildingMaterialsServiceImage
    ),
    'Finishing Material': const _ServiceContainerDetail(
      title: 'Finishing_Materials',
      page: '/finishing-materials-list',
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
        width: MediaQuery.of(context).size.width,
        height: 120,
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

