import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/pages/miscellaneous/change-password.dart';
import 'package:haweyati/src/ui/pages/miscellaneous/edit-profile.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/dark-list-tile.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati_client_data_models/data.dart';

class SettingsPage extends StatelessWidget {
  final _appData = AppData();

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      appBar: HaweyatiAppBar(hideCart: true, hideHome: true),
      body: DottedBackgroundView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: <Widget>[
          HeaderView(
            title: 'Settings',
            subtitle: loremIpsum.substring(0, 70),
          ),
          if (_appData.isAuthenticated &&
              _appData.user.profile.hasScope('customer'))
            DarkListTile(
              title: 'Profile',
              trailing: Icon(CupertinoIcons.right_chevron),
              onTap: () => navigateTo(context, EditProfile()),
            ),
          SizedBox(height: 15),
          DarkListTile(
            title: 'Notification',
            trailing: Icon(CupertinoIcons.right_chevron),
            onTap: () => AppSettings.openAppSettings(),
          ),
          SizedBox(height: 15),
          DarkListTile(
            title: 'Change Password',
            trailing: Icon(CupertinoIcons.right_chevron),
            onTap: () => navigateTo(context, ChangePassword()),
          )
        ]),
      ),
    );
  }
}
