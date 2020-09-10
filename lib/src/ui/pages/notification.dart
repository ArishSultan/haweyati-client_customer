import 'package:flutter/material.dart';
import 'package:haweyati/models/notifications_model.dart';
import 'package:haweyati/services/notifications-service.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/scrollable_page.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/src/utlis/date-formatter.dart';
import 'package:haweyati/src/utlis/simple-future-builder.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  Future<List<NotificationModel>> notifications;

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  Future getNotifications() async {
    notifications = NotificationsService().notifications();
  }


  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      padding: 0,
      showBackgroundImage: false,
      appBar: HaweyatiAppBar(
        progress: 0,
        hideHome: true,
        hideCart: true
      ),
      title: "Notifications",
      subtitle: loremIpsum.substring(0, 50),
      child: SimpleFutureBuilder.simplerSliver(
        context: context,
        future: notifications,
        builder: (AsyncSnapshot<List<NotificationModel>> notification){
          return SliverList(delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    NotificationModel not = notification.data[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0x11000000)))
                  ),
                  child: ListTile(
                      leading: Icon(Icons.fingerprint),
                      title: Text(not.title),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(not?.body),
                            Text(formattedDate(DateTime.parse(not.createdAt))),
                          ],
                        ),
                      )
                  ),
                );
              },
              childCount: notification.data.length
          ));
        }
      ),
    );
  }
}
