import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/utils/const.dart';
import 'package:app_settings/app_settings.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/dark-list-item.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';

class SettingsPage extends StatelessWidget {
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

          DarkListTile(
            title: 'Profile',
            trailing: Icon(CupertinoIcons.right_chevron),
            onTap: () => Navigator.of(context).pushNamed('/profile')
          ),
          SizedBox(height: 15),
          DarkListTile(
            title: 'Notification',
            trailing: Icon(CupertinoIcons.right_chevron),
            onTap: () => AppSettings.openAppSettings()
          ),
          SizedBox(height: 15),
          DarkListTile(
            title: 'Change Password',
            trailing: Icon(CupertinoIcons.right_chevron),
            onTap: () => Navigator.of(context).pushNamed('/change-password')
          )
        ]),
      ),
    );
  }
}
