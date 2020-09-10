import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/no-scroll_page.dart';
import 'package:haweyati/src/ui/widgets/service-list-item.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

import '../single-scaffolding_page.dart';

class ScaffoldingsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoScrollPage(
      appBar: HaweyatiAppBar(progress: .2),
      body: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: Text(
            tr("scaffolding"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(loremIpsum.substring(0, 60), textAlign: TextAlign.center),
        ),

        SizedBox(height: 40),
        ServiceListItem(
          assetImage: true,
          name: "Steel Scaffolding",
          image: 'assets/images/steelscaffolding.png',
          onTap: () => Navigator.of(context).pushNamed('/steel-scaffolding-options'),
        ),
        ServiceListItem(
          assetImage: true,
          name: "Patented Scaffolding",
          image: 'assets/images/steelscaffolding.png',
          onTap: () => Navigator.of(context).pushNamed('/patented-scaffolding-options'),
        ),
        ServiceListItem(
          assetImage: true,
          name: "Single Scaffolding",
          image: 'assets/images/steelscaffolding.png',
          onTap: () => CustomNavigator.navigateTo(context, SingleScaffoldingPage()),
        ),
      ]),
    );
  }
}
