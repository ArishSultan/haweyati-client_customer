import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/const.dart';

class TermsAndConditionsPage extends StatefulWidget {
  @override
  _TermsAndConditionsPageState createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  var _allow = false;

  _agreeToTerms() {

  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (ScrollUpdateNotification scrollNotification) {
        if (_allow) return true;

        if (scrollNotification.metrics.pixels >= scrollNotification.metrics.maxScrollExtent) {
          setState(() => _allow = true);
        }

        return true;
      },
      child: ScrollableView(
        appBar: HaweyatiAppBar(hideHome: true, hideCart: true),
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
        showBackground: true,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderView(
            title: 'Terms and Conditions',
            subtitle: loremIpsum.substring(0, 100),
          ),

          Text('Tile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            child: Text(loremIpsum.substring(0, 300)),
          ),

          Text('Tile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            child: Text(loremIpsum.substring(0, 300)),
          ),

          Text('Tile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            child: Text(loremIpsum.substring(0, 300)),
          ),

          Text('Tile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            child: Text(loremIpsum.substring(0, 300)),
          )
        ],
        bottom: RaisedActionButton(
          label: 'Agree To Terms & Conditions',
          onPressed: _allow ? _agreeToTerms : null,
        )
      ),
    );
  }
}
