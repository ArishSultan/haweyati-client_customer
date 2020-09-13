import 'item_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/utils/app-data.dart';
import 'package:haweyati/src/utils/const.dart';
import 'package:haweyati/src/models/dumpster_model.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/services/dumpsters_service.dart';
import 'package:haweyati/src/ui/widgets/service-list-item.dart';
import 'package:haweyati/src/ui/views/live-scrollable_view.dart';

class DumpstersListPage extends StatelessWidget {
  final _service = DumpstersService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(hideHome: true),
      body: LiveScrollableView<Dumpster>(
        title: 'Construction Dumpsters',
        subtitle: loremIpsum.substring(0, 70),

        loader: () => _service.getDumpsters(AppData.instance().city),
        builder: (context, data) {
          return ServiceListItem(
            name: '${data.size} Yards',
            image: data.image.name,
            onTap: () => navigateTo(context, DumpsterItemPage(data))
          );
        }
      )
    );
  }
}
