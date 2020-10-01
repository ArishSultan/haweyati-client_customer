import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/ui/modals/dialogs/errors/gps-off_error-dialog.dart';
import 'package:haweyati/src/ui/modals/dialogs/errors/location-permission_error-dialog.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/utils/location-service-util.dart';

import '../../../routes.dart';
import '../../../routes.dart';

class PreLocationPage extends StatefulWidget {
  @override
  _PreLocationPageState createState() => _PreLocationPageState();
}

class _PreLocationPageState extends State<PreLocationPage> {
  bool _enabled = false;

  checkStatus() async {
    _enabled = await Geolocator().isLocationServiceEnabled();

    if (!_enabled) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog();
        }
      );
    } else setState(() {});
  }

  @override
  void initState() {
    super.initState();

    checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      appBar: HaweyatiAppBar(hideHome: true, hideCart: true),
      body: DottedBackgroundView(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
        child: Column(children: <Widget>[
          Icon(
            Icons.location_on,
            color: Theme.of(context).accentColor,
            size: 100,
          ),
          HeaderView(
            title: tr('Location'),
            subtitle: tr('Location_Detail'),
          )
        ], mainAxisAlignment: MainAxisAlignment.center),
      ),
      bottom: FlatActionButton(
        label: tr('Set_Your_Location'),
        onPressed: () async {
          if (await checkLocationService(context,
            gpsErrorDialog: GPSErrorDialog(context),
            locationPermissionErrorDialog: LocationPermissionErrorDialog()
          )) {
            final location = await Navigator
              .of(context)
              .pushNamed(LOCATION_PICKER_MAP_PAGE);

            if (location != null) {
              AppData.instance().location = location;

              Navigator
                .of(context)
                .pushNamedAndRemoveUntil(HOME_PAGE, (route) => false);
            }
          }
        }
      ),
    );
  }
}
