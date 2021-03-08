import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:share/share.dart';

class ShareAndInvitePage extends StatefulWidget {
  @override
  _ShareAndInvitePageState createState() => _ShareAndInvitePageState();
}

class _ShareAndInvitePageState extends State<ShareAndInvitePage> {
  String _code;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    final profileId = AppData().user.profile.id;
    _code = AppData().user.referralCode;
  }

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      key: _scaffoldKey,
      appBar: HaweyatiAppBar(hideHome: true, hideCart: true),
      body: DottedBackgroundView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(children: <Widget>[
          Container(
            width: 80,
            height: 80,
            child: Center(child: Image.asset(GiftIcon, width: 50, height: 50)),
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: HeaderView(
              title: 'Share and Invite',
              subtitle:
                  'Invite your friends and give them each 500 points in coupons. And for every friend who completes their first purchase we\'ll give you 500 points.',
            ),
          ),
          Container(
            width: 260,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(children: <Widget>[
              Text(
                _code.toUpperCase(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              GestureDetector(
                onTap: ()  async {
                  await Clipboard.setData(ClipboardData(text: _code));
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'Copied $_code',
                    ),
                  ));
                } ,
                child: Text('Copy', style: TextStyle(color: Colors.orange)),
              )
            ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ),
        ], mainAxisAlignment: MainAxisAlignment.center),
      ),
      bottom: FlatActionButton(
        label: 'Invite Friends',
        onPressed: () async {
         await Share.share("You are invited to create an account on Haweyati by ${AppData().user.name}. Please use the following code when signing up to get 500 bonus points: $_code");
          return;
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Invitation will be available after purchasing application domain'
              'i.e. https://www.haweyati.com',
            ),
          ));
        },
      ),
    );
  }
}
