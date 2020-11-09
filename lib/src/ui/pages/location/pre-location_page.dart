import 'package:flutter/material.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/localized_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/utils/location-service-util.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/widgets/localization-selector.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';

class PreLocationPage extends StatefulWidget {
  @override
  _PreLocationPageState createState() => _PreLocationPageState();
}

class _PreLocationPageState extends State<PreLocationPage> {
  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (context, lang) => NoScrollView(
        appBar: HaweyatiAppBar(
          hideHome: true,
          hideCart: true,
          allowBack: false,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(child: LocalizationSelector()),
            )
          ],
        ),
        body: DottedBackgroundView(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
          child: Column(children: <Widget>[
            Image.asset(LocationIcon),
            HeaderView(
              title: lang.location,
              subtitle: lang.locationDescription,
            )
          ], mainAxisAlignment: MainAxisAlignment.center),
        ),
        bottom: FlatActionButton(
          label: lang.setYourLocation,
          onPressed: () => processUserLocationPicking(
            context,
            onLocationPicked: () =>
                Navigator.of(context).pushNamedAndRemoveUntil(
              HOME_PAGE,
              (route) => false,
            ),
          ),
        ),
      ),
    );
  }
}
