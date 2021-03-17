// @dart = 2.12

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:haweyati/src/base/theme.dart';
import 'package:haweyati/src/base/assets.dart';
import 'package:haweyati/src/ui/views/localized_view.dart';
import 'package:haweyati/src/ui/widgets/directional_arrow.dart';
import 'package:haweyati/src/ui/widgets/controller_widget.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/widgets/localization-selector.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final imageWidth = media.size.width * .8;

    return Material(
      child: DottedBackgroundView(
        child: LocalizedView(
          builder: (_, lang) => Column(children: [
            Container(
              color: AppTheme.primaryColor2,
              height: kToolbarHeight + media.padding.top,
              padding: EdgeInsets.only(top: media.padding.top),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: LocalizationSelector(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _SkipButton(
                      controller: _controller,
                      text: lang.skip,
                      onPressed: () {
                        _controller.jumpToPage(3);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                children: [
                  _Feature(
                    width: imageWidth,
                    image: Assets.feature1Image,
                    title: lang.ourServices,
                    detail: lang.ourServicesDescription,
                  ),
                  _Feature(
                    width: imageWidth,
                    image: Assets.feature2Image,
                    title: lang.ourProducts,
                    detail: lang.ourProductsDescription,
                  ),
                  _Feature(
                    width: imageWidth,
                    image: Assets.feature3Image,
                    title: lang.ourTrucks,
                    detail: lang.ourTrucksDescription,
                  ),
                  _Feature(
                    width: imageWidth,
                    image: Assets.feature4Image,
                    title: lang.paymentAndSecurity,
                    detail: lang.paymentAndSecurityDescription,
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              child: _NavigationBar(
                lang.getStarted,
                Directionality.of(context),
                _controller,
              ),
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 23),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
      _controller.dispose();
    super.dispose();
  }
}

class _SkipButton extends ControlledWidget<PageController> {
  final String text;
  final VoidCallback onPressed;

  _SkipButton({
    required this.text,
    required this.onPressed,
    required PageController controller,
  }) : super(controller: controller);

  @override
  __SkipButtonState createState() => __SkipButtonState();
}

class __SkipButtonState extends ControlledWidgetState<_SkipButton> {
  @override
  Widget build(BuildContext context) {
    late final double page;
    if (widget.controller.hasClients) {
      page = widget.controller.page ?? 0;
    } else {
      page = 0;
    }

    late final double scale;
    if (page > 2) {
      scale = 1 - page % 2;
    } else {
      scale = 1;
    }

    return Transform.scale(
      scale: scale,
      child: TextButton(
        child: Text(widget.text),
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          primary: Colors.white,
          minimumSize: Size(56, 56),
          backgroundColor: Color(0x0),
          shape: RoundedRectangleBorder(),
        ),
      ),
    );
  }
}

class _NavigationBar extends ControlledWidget<PageController> {
  final String text;
  final ui.TextDirection direction;

  _NavigationBar(this.text, this.direction, PageController controller)
      : super(controller: controller);

  @override
  __NavigationBarState createState() => __NavigationBarState();
}

class __NavigationBarState extends ControlledWidgetState<_NavigationBar> {
  late double textWidth;

  @override
  void initState() {
    super.initState();
    textWidth = widget.direction == ui.TextDirection.ltr ? 86 : 35;
  }

  @override
  Widget build(BuildContext context) {
    late final int page;
    late final double scalePage;
    if (widget.controller.hasClients) {
      page = widget.controller.page?.round() ?? 0;
      scalePage = widget.controller.page ?? 0;
    } else {
      page = 0;
      scalePage = 0;
    }

    late final double scale;
    if (scalePage > 2) {
      scale = scalePage % 2;
    } else {
      scale = 0;
    }

    return Row(children: [
      Row(children: [
        _FeatureViewIndicator(page == 0),
        _FeatureViewIndicator(page == 1),
        _FeatureViewIndicator(page == 2),
        _FeatureViewIndicator(page == 3),
      ]),
      Spacer(),
      TextButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: textWidth * scale,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  widget.text,
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ),
            DirectionalArrow(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child:
                  Image.asset(Assets.nextFeatureIcon, width: 30 - (10 * scale)),
            )),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        onPressed: () {},
        style: TextButton.styleFrom(
          primary: Colors.white,
          minimumSize: Size(60, 60 - (15 * scale)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: AppTheme.primaryColor,
        ),
      ),
    ]);
  }
}

class _Feature extends Padding {
  _Feature({
    required double width,
    required String image,
    required String title,
    required String detail,
  }) : super(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            Expanded(
              child: Center(child: Image.asset(image, width: width)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                title,
                style: const TextStyle(
                  height: 1,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
              child: Text(
                detail,
                style: const TextStyle(fontSize: 14, height: 1.3),
              ),
            )
          ], crossAxisAlignment: CrossAxisAlignment.start),
        );
}

class _FeatureViewIndicator extends Container {
  _FeatureViewIndicator(bool selected)
      : super(
          width: 7,
          height: 7,
          margin: const EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? AppTheme.primaryColor2 : Colors.grey.shade300,
          ),
        );
}
