import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/utils/const.dart';

class ShareAndInvitePage extends StatefulWidget {
  @override
  _ShareAndInvitePageState createState() => _ShareAndInvitePageState();
}

class _ShareAndInvitePageState extends State<ShareAndInvitePage> {
  var _code = 'RANDOM CODE';

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      appBar: HaweyatiAppBar(hideHome: true, hideCart: true),
      body: DottedBackgroundView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(children: <Widget>[
          Container(
            width: 80,
            height: 80,
            child: Center(child: Image.asset(GiftIcon, width: 50, height: 50)),
            decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: HeaderView(
              title: 'Share and Invite',
              subtitle: 'Invite our friends and give them each 500 points in coupons. And for every friend who completes their first purchase we\'ll give you 500 points.',
            ),
          ),
          Container(
            width: 250,
            padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 15
            ),
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(50)
            ),
            child: Row(children: <Widget>[
              Text(_code, style: TextStyle(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => Clipboard.setData(ClipboardData(text: _code)),
                child: Text('Copy', style: TextStyle(color: Colors.orange))
              )
            ],mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ),
        ], mainAxisAlignment: MainAxisAlignment.center),
      ),
      bottom: FlatActionButton(
        label: 'Invite Friends',
        onPressed: () {
        }
      ),
    );
  }
}
