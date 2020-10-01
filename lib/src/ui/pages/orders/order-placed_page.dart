import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';

class OrderPlacedPage extends StatelessWidget {
  final String number;
  final Future Function() beforeFinish;

  OrderPlacedPage(this.number, this.beforeFinish);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: NoScrollView(
        appBar: HaweyatiAppBar(
          allowBack: false,
          hideCart: true,
          hideHome: true,
        ),

        body: DottedBackgroundView(
          padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                shape: BoxShape.circle
              ),
              child: Icon(Icons.check, color: Colors.white, size: 39)
            ),

            HeaderView(
              title: 'Thank You',
              subtitle: 'Your order has been placed. Your order reference number is ${number.toUpperCase()}',
            ),

            GestureDetector(
              child: Text('View Order Details', style: TextStyle(
                color: Theme.of(context).primaryColor
              )),
              onTap: () {
                print('View Order Details');
              },
            )
          ], mainAxisAlignment: MainAxisAlignment.center),
        ),

        bottom: FlatActionButton(
          label: 'Home',
          onPressed: () => Navigator
              .of(context)
              .popUntil((route) => route.settings.name == HOME_PAGE),
        ),
      ),
    );
  }
}
