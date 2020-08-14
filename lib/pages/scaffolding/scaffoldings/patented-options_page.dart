import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/dark-list-item.dart';
import 'package:haweyati/src/ui/widgets/no-scroll_page.dart';
import 'package:haweyati/src/utlis/const.dart';

class PatentedOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoScrollPage(
      appBar: HaweyatiAppBar(context,progress: .3),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 10),
            child: Text(
              "Scaffolding Option",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
          ),
          Text(loremIpsum.substring(0,60), textAlign: TextAlign.center),
          SizedBox(height: 40),
          DarkListItem(
            title: "Facades",
            trailing: Icon(CupertinoIcons.right_chevron),
            onTap: () => Navigator.of(context).pushNamed('/scaffoldings-facades')
          ),
          SizedBox(height: 15),
          DarkListItem(title: "Manual", trailing: Icon(CupertinoIcons.right_chevron)),
        ]),
      ),
    );
  }
}
