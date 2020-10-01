import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/src/l10n/localization.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/widgets/localization-selector.dart';

class FeaturesPage extends StatefulWidget {
  @override
  _FeaturesPageState createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  int _currentPage = 0;
  PageController _controller;

  @override
  void initState() {
    super.initState();

    AppData.instance().burnFuse();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    final _lang = HaweyatiLocalizations.of(context);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 5,
        automaticallyImplyLeading: false,
        title: Row(children: <Widget>[
          LocalizationSelector(),
          Expanded(child: Image.asset(AppLogo, width: 40, height: 40))
        ]),
        actions: <Widget>[
          _currentPage != 3? SizedBox(
            width: 70,
            child: FlatButton(
              textColor: Colors.white,
              child: Text(_lang?.skip ?? ''),
              onPressed: () => Navigator.of(context).pushNamed(PRE_LOCATION_PAGE)
            )
          ): Container(width: 70)
        ],
      ),

      body: DottedBackgroundView(
        padding: const EdgeInsets.only(bottom: 56),
        child: PageView(
          children: <Widget>[
            _FeatureView(
              image: '1',
              title: _lang.ourServices,
              detail: _lang.ourServicesDescription
            ),
            _FeatureView(
              image: '2',
              // title: tr('Our_product'),
              // detail: tr('product_detail')
            ),
            _FeatureView(
              image: '3',
              // title: tr('Truck'),
              // detail: tr('truck_detail')
            ),
            _FeatureView(
              image: '4',
              // title: tr('Payment'),
              // detail: tr('payment_detail')
            ),
          ],
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
        ),
      ),

      floatingActionButton: GestureDetector(
        onTap: () {
          if (_currentPage != 3)
            _controller.nextPage(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 300)
            );
          else Navigator
              .of(context)
              .pushNamed(PRE_LOCATION_PAGE);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: _currentPage == 3? 138 :60,
          height: _currentPage == 3? 45 :60,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(_currentPage == 3? 23: 35)
          ),
          child: _currentPage == 3? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(children: <Widget>[
              Expanded(
                flex: 10,
                child: Text("Get Started", style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ), overflow: TextOverflow.ellipsis),
              ),
              Expanded(flex: 1, child: Container()),
              Transform.rotate(
                angle: Localizations.localeOf(context).languageCode == 'ar' ? 3.14 : 0,
                child: Image.asset(NextFeatureIcon, width: 20)
              )
            ]),
          ): Center(child: Transform.rotate(
            angle: Localizations.localeOf(context).languageCode == 'ar' ? 3.14 : 0,
            child: Image.asset(NextFeatureIcon, width: 30)
          )),
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(children: <Widget>[
            _FeatureViewIndicator(_currentPage == 0),
            _FeatureViewIndicator(_currentPage == 1),
            _FeatureViewIndicator(_currentPage == 2),
            _FeatureViewIndicator(_currentPage == 3)
          ], crossAxisAlignment: CrossAxisAlignment.start),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    this._controller.dispose();
  }
}

class _FeatureView extends Column {
  _FeatureView({
    String image,
    String title,
    String detail
  }): super(children: [
    Expanded(child: Center(
      child: Transform.scale(
        scale: 0.8,
        child: Image.asset('assets/images/welcome-page/feature-$image.png')
      )
    )),
    Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
      child: Text(title ?? '', style: TextStyle(
        height: 1,
        fontSize: 20,
        fontWeight: FontWeight.bold
      )),
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 60),
      child: Text(detail ?? '', style: TextStyle(fontSize: 14 )),
    )
  ], crossAxisAlignment: CrossAxisAlignment.start);
}

class _FeatureViewIndicator extends Container {
  _FeatureViewIndicator(bool selected): super(
    width: 7, height: 7,
    margin: const EdgeInsets.only(left: 5),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: selected ? Color(0xFF313F53) : Colors.grey.shade300
    )
  );
}
