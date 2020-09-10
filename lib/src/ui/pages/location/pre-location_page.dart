import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haweyati/src/ui/pages/locations-map_page.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/flat-action-button.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/utils/app-data.dart';

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
      bottom: _enabled ? FlatActionButton(
        label: tr('Set_Your_Location'),
        onPressed: () async {
          final location = await Navigator.of(context).pushNamed('/location');

          if (location != null) {
            AppData.instance().location = location;
            Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          }
        }
      ): FlatActionButton(
        icon: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 1,
            valueColor: AlwaysStoppedAnimation(Colors.grey.shade600),
          ),
        ),
        label: 'Checking Location Availability'
      ),
    );
  }
}
