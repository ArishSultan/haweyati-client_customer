import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/widgets/flat-action-button.dart';
import 'package:haweyati/src/utils/const.dart';

class RateAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      appBar: HaweyatiAppBar(hideCart: true, hideHome: true),
      body: DottedBackgroundView(
        padding: const EdgeInsets.only(bottom: 55),
        child: Center(child: Column(children: [
          Container(
            width: 90, height: 90,
            padding: const EdgeInsets.all(15),
            child: Image.asset(StarIconOutlined),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).accentColor,
            ),
          ),
          SizedBox(height: 15),
          Text('Rate the app',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            )
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              loremIpsum.substring(0, 50),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
              Image.asset(StarIconFilled, width: 30, height: 30),
              SizedBox(width: 5),
              Image.asset(StarIconFilled, width: 30, height: 30),
              SizedBox(width: 5),
              Image.asset(StarIconFilled, width: 30, height: 30),
              SizedBox(width: 5),
              Image.asset(StarIconFilled, width: 30, height: 30),
              SizedBox(width: 5),
              Image.asset(StarIconFilled, width: 30, height: 30),
            ])
          ),
        ], mainAxisAlignment: MainAxisAlignment.center)),
      ),

      bottom: FlatActionButton(
        label: 'Submit',
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text('This feature is not implemented yet.'),
            )
          );
        }
      )
    );
  }
}
