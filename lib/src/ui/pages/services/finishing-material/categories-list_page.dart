import 'package:flutter/material.dart';
import 'package:haweyati/src/models/services/finishing-material/category_model.dart';
import 'package:haweyati/src/services/finishing-material_service.dart';
import 'package:haweyati/src/ui/pages/services/finishing-material/list_page.dart';
import 'package:haweyati/src/ui/views/live-scrollable_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/service-list-tile.dart';
import 'package:haweyati/src/utils/const.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class FinishingMaterialCategoriesListPage extends StatelessWidget {
  final _service = FinishingMaterialService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(hideHome: true),
      body: LiveScrollableView<FinishingMaterialCategory>(
        title: 'Finishing Material',
        subtitle: loremIpsum.substring(0, 70),
        loader: () => _service.getFinishingMaterial(),
        builder: (context, data) {
          return ServiceListItem(
            name: data.name,
            image: data.image.name,
            onTap: () => navigateTo(context, FinishingMaterialSubList(data))
          );
        }
      )
    );
  }
}
