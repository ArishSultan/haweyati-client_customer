import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:hive/hive.dart';
import 'package:flutter/widgets.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';

class NotificationsPage extends StatelessWidget {
  // final _box = Hive.box<StoreableNotification>('notifications');

  @override
  Widget build(BuildContext context) {
    // List<StoreableNotification> list = _box.values.toList();

    return ScrollableView.sliver(
      appBar: HaweyatiAppBar(hideHome: true, hideCart: true),
      children: [
        SliverToBoxAdapter(child: HeaderView(
          title: 'Notifications',
          subtitle: 'this is the history of all the notifications that you have received',
        )),

        // SliverList(delegate: SliverChildBuilderDelegate(
        //   (context, index) {
        //     return ListTile(
        //       leading: Icon(CupertinoIcons.news),
        //       // title: Text(list[index].notification.title ?? ''),
        //       // subtitle: Text(list[index].notification.body ?? ''),
        //     );
        //   },
        //   // childCount: list.length
        // ))
      ],
    );
  }
}
