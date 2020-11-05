import 'package:flutter/material.dart';
import 'package:haweyati/src/models/services/building-material/category_model.dart';
import 'package:haweyati/src/models/services/building-material/model.dart';
import 'package:haweyati/src/services/bm-sublist_service.dart';
import 'package:haweyati/src/ui/pages/services/building-material/item_page.dart';
import 'package:haweyati/src/ui/views/live-scrollable_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/service-list-tile.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class BuildingMaterialsListPage extends StatelessWidget {
  BuildingMaterialsListPage(this.item);
  
  final BuildingMaterialCategory item;
  final _service = BMSublistService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(),
      body: LiveScrollableView<BuildingMaterial>(
        title: item.name,
        subtitle: item.description,
        loader: () => _service.getBMSublist(item.id),
        builder: (context, BuildingMaterial data) {
          return ServiceListItem(
            name: data.name,
            image: data.image.name,
            detail: '${data.price12} - ${data.price20} SAR',
            onTap: () => navigateTo(context, BuildingMaterialItemPage(data))
          );
        }
      )
    );
  }
}
