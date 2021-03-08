import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/rest/_new/notification_rest.dart';
import 'package:haweyati/src/ui/views/live-scrollable_view.dart';
import 'package:flutter/widgets.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati_client_data_models/data.dart';

class NotificationsPage extends StatelessWidget {
  // final _box = Hive.box<StoreableNotification>('notifications');
  final _key = GlobalKey<LiveScrollableViewState>();

  @override
  Widget build(BuildContext context) {
    // List<StoreableNotification> list = _box.values.toList();
    return NoScrollView(
      appBar: HaweyatiAppBar(
        hideHome: true,
        hideCart: true,
      ),
      body: LiveScrollableView<NotificationRequest>(
        key: _key,
        loader: NotificationRest().get,
        loadingTitle: 'Loading Notifications',
        builder: (context, NotificationRequest _) {
          return ListTile(
            title: Text(_.title),
            subtitle: Text(_.body),
          );
        },
        title: 'Notifications',
        // subtitle: 'This is the history of all the notifications that you have received.',
      ),
    );
    //
    // return ScrollableView.sliver(
    //   appBar: HaweyatiAppBar(hideHome: true, hideCart: true),
    //   children: [
    //     SliverToBoxAdapter(child: HeaderView(
    //       title: 'Notifications',
    //       subtitle: 'this is the history of all the notifications that you have received',
    //     )),
    //
    //     // SliverList(delegate: SliverChildBuilderDelegate(
    //     //   (context, index) {
    //     //     return ListTile(
    //     //       leading: Icon(CupertinoIcons.news),
    //     //       // title: Text(list[index].notification.title ?? ''),
    //     //       // subtitle: Text(list[index].notification.body ?? ''),
    //     //     );
    //     //   },
    //     //   // childCount: list.length
    //     // ))
    //   ],
    // );
  }
}
