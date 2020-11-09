import 'package:flutter/material.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableView(
      appBar: HaweyatiAppBar(hideHome: true, hideCart: true),
      showBackground: true,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderView(
          title: 'Terms and Conditions',
          subtitle: loremIpsum.substring(0, 100),
        ),
        Text('Tile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          child: Text(loremIpsum.substring(0, 300)),
        ),
        Text('Tile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          child: Text(loremIpsum.substring(0, 300)),
        ),
        Text('Tile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          child: Text(loremIpsum.substring(0, 300)),
        ),
        Text('Tile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          child: Text(loremIpsum.substring(0, 300)),
        )
      ],
    );
  }
}
