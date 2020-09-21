import 'package:flutter/material.dart';
import 'package:haweyati/src/models/services/building-material/category_model.dart';
import 'package:haweyati/src/services/building-material_service.dart';
import 'package:haweyati/src/ui/pages/services/building-material/list_page.dart';
import 'package:haweyati/src/ui/views/live-scrollable_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/service-list-tile.dart';
import 'package:haweyati/src/utils/const.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class BuildingMaterialCategoriesListPage extends StatelessWidget {
  final _service = BuildingMaterialService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(hideHome: true),
      body: LiveScrollableView<BuildingMaterialCategory>(
        title: 'Building Material',
        subtitle: loremIpsum.substring(0, 70),
        loader: () => _service.getBuildingMaterials(),
        builder: (context, BuildingMaterialCategory data) {
          return ServiceListItem(
            name: data.name,
            image: data.image.name,
            onTap: () => navigateTo(context, BuildingMaterialsListPage(data))
          );
        },
      ),
    );
  }
}
