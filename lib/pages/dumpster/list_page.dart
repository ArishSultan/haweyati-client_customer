import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/models/dumpster_model.dart';
import 'package:haweyati/services/dumpsters_service.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/live-scrollable_body.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/src/utlis/simple-future-builder.dart';
import 'package:haweyati/widgits/custom-navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haweyati/src/ui/widgets/service-list-item.dart';

import 'detail_page.dart';

class DumpstersListPage extends StatefulWidget {
  @override
  _DumpstersListPageState createState() => _DumpstersListPageState();
}

class _DumpstersListPageState extends State<DumpstersListPage> {
  var _flag = false;
  final _service = DumpstersService();

  Future<List<Dumpster>> _dumpsters;

  Future<void> _loadData() async {
    this._dumpsters = _service.getDumpsters(
      (await SharedPreferences.getInstance()).getString('city')
    );
    await _dumpsters;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _loadData()..then((value) { this._flag = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(context,hideHome: true),
      body: LiveScrollableBody(
        onRefresh: _flag ? _loadData : null,
        title: tr("construction_dumpster"),
        subtitle: loremIpsum.substring(0, 70),
        child: SimpleFutureBuilder.simplerSliver(
          showLoading: !_flag,
          context: context,
          future: _dumpsters,
          builder: (AsyncSnapshot<List<Dumpster>> snapshot) {
            if (snapshot.data.length == 0) {
              return SliverToBoxAdapter(child: Text('No Dumpsters service was found in your Area.'));
            } else {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return ServiceListItem(
                      name: snapshot.data[i].size,
                      image: snapshot.data[i].image.name,

                      onTap: () {
                        CustomNavigator.navigateTo(context, DumpsterDetailPage(snapshot.data[i]));
                      }
                    );
                  },
                  childCount: snapshot.data.length
                )
              );
            }
          },
        ),
      ),
    );
  }
}
