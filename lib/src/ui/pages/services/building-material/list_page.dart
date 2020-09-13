import 'package:flutter/material.dart';
import 'package:haweyati/models/building-material_model.dart';
import 'package:haweyati/models/building-material_sublist.dart';
import 'package:haweyati/services/bm-sublist_service.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/ui/views/live-scrollable_view.dart';
import 'package:haweyati/src/ui/widgets/service-list-item.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/src/utlis/simple-future-builder.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';
import 'package:haweyati/widgits/list-of-items.dart';

import '../../../../../pages/service-pages/building-material/building-product-detail.dart';

class BuildingMaterialsListPage extends StatefulWidget {
  final BuildingMaterials item;
  BuildingMaterialsListPage(this.item);

  @override
  _BuildingMaterialsListPageState createState() => _BuildingMaterialsListPageState();
}

class _BuildingMaterialsListPageState extends State<BuildingMaterialsListPage> {
  final _service = BMSublistService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(context: context,),
      body: LiveScrollableView<BMProduct>(
        title: widget.item.name,
        subtitle: widget.item.description,
        loader: () => _service.getBMSublist(widget.item.id),
        builder: (context, BMProduct data) {
          return ServiceListItem(
            name: data.name,
            image: data.image.name,
            onTap: () {
            }
          );
        }
      )
    );
  }
}
