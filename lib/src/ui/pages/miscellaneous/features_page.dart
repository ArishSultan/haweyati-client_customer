import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:haweyati/src/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/src/ui/views/localized_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/widgets/localization-selector.dart';
import 'package:haweyati_client_data_models/data.dart';

var _currentPageCache = 0;

class FeaturesPage extends StatelessWidget {
  final _page = ValueNotifier<int>(_currentPageCache);
  final _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    AppData().burnFuse();

    return LocalizedView(
      builder: (context, lang) => NoScrollView(
        appBar: _AppBar(_page, lang.skip),
        extendBody: true,
        body: DottedBackgroundView(
          padding: const EdgeInsets.only(bottom: 56),
          child: PageView(
            children: [
              _FeatureView(
                image: FeatureImage1,
                title: lang.ourServices,
                detail: lang.ourServicesDescription
              ),
              _FeatureView(
                image: FeatureImage2,
                title: lang.ourProducts,
                detail: lang.ourProductsDescription
              ),
              _FeatureView(
                image: FeatureImage3,
                title: lang.ourTrucks,
                detail: lang.ourTrucksDescription
              ),
              _FeatureView(
                image: FeatureImage4,
                title: lang.paymentAndSecurity,
                detail: lang.paymentAndSecurityDescription
              ),
            ],
            controller: _controller,
            onPageChanged: (index) => _currentPageCache = _page.value = index
          ),
        ),

        bottom: _BottomControls(
          page: _page,
          controller: _controller,
        )
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  final PageController controller;
  final ValueListenable<int> page;

  _BottomControls({
    this.page,
    this.controller
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: page,
      builder: (context, value, child) {
        final flag = value == 3;

        return Container(
          height: 60,
          margin: const EdgeInsets.fromLTRB(13, 0, 13, 23),
          child: Row(children: [
            Wrap(children: [
              _FeatureViewIndicator(0, value),
              _FeatureViewIndicator(1, value),
              _FeatureViewIndicator(2, value),
              _FeatureViewIndicator(3, value)
            ]),

            Spacer(),

            if (flag)
              TextButton.icon(
                onPressed: () => Navigator
                    .of(context)
                    .pushReplacementNamed(PRE_LOCATION_PAGE),

                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 11
                  ))
                ),
                label: Transform.rotate(
                  child: Image.asset(NextFeatureIcon, width: flag ? 20 : 30),
                  angle: AppLocalizations.of(context).localeName == 'ar' ? 3.14 : 0
                ),
                icon: Text(AppLocalizations.of(context).getStarted),
              )
            else
              SizedBox(
                width: 60,
                height: 60,
                child: TextButton(
                  child: Transform.rotate(
                    angle: AppLocalizations.of(context).localeName == 'ar' ? 3.14 : 0,
                    child: Image.asset(NextFeatureIcon, width: flag ? 20 : 30)
                  ),

                  onPressed: () => controller.nextPage(
                    curve: Curves.easeOut,
                    duration: Duration(milliseconds: 500),
                  )
                ),
              )
          ]),
        );
      }
    );
  }
}


class _FeatureView extends Column {
  _FeatureView({
    String image,
    String title,
    String detail
  }): super(children: [
    Expanded(child: Center(
      child: Transform.scale(scale: 0.8, child: Image.asset(image))
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
      child: Text(detail ?? '', style: TextStyle(fontSize: 14, height: 1.3)),
    )
  ], crossAxisAlignment: CrossAxisAlignment.start);
}
class _FeatureViewIndicator extends Container {
  _FeatureViewIndicator(int selected, int current): super(
    width: 7, height: 7,
    margin: const EdgeInsets.only(left: 5),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: selected == current ? Color(0xFF313F53) : Colors.grey.shade300
    )
  );
}

class _AppBar extends StatelessWidget with PreferredSizeWidget {
  final String skipText;
  final ValueListenable<int> page;
  _AppBar(this.page, this.skipText);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: page,
      builder: (context, val, child) {
        return Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          color: Color(0xFF313F53),
          child: Stack(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: LocalizationSelector(),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Image.asset(AppLogo, width: 40, height: 40)
            ),

            if (val != 3)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text(skipText),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)
                    )),
                    backgroundColor: MaterialStateProperty.all(Colors.transparent)
                  ),
                  onPressed: () => Navigator
                      .of(context)
                      .pushReplacementNamed(PRE_LOCATION_PAGE)
                )
              ),
          ], fit: StackFit.expand),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
