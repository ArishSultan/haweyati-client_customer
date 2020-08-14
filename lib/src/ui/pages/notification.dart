import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/scrollable_page.dart';
import 'package:haweyati/src/utlis/const.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      padding: 0,
      showBackgroundImage: false,
      appBar: HaweyatiAppBar(
        context,
        progress: 0,
        hideHome: true,
        hideCart: true
      ),
      title: "Notifications",
      subtitle: loremIpsum.substring(0, 50),

      child: SliverList(delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0x11000000)))
            ),
            child: ListTile(
              leading: Icon(Icons.fingerprint),
              title: Text(loremIpsum.substring(0, 60)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("12:30 PM"),
              )
            ),
          );
        },
        childCount: 20
      )),
    );

//      Scaffold(
//      appBar: HaweyatiAppBar(context: context,showCart: false,showHome: false,),
//      body: HaweyatiAppBody(
//        title: "Notification",
//        detail:
//            loremIpsum.substring(0,50),
//        child: ListView.separated(
//            itemBuilder: (context, i) {
//              return ListTile(
//                leading: Image.asset("assets/images/notification_thumb.png",height: 40,width: 40,),
//title: Text(loremIpsum.substring(0,60)),
//         ,     );
//            },
//            separatorBuilder: (context, i) {
//              return Divider();
//            },
//            itemCount: 12)
//      ),
//    );
  }
}
