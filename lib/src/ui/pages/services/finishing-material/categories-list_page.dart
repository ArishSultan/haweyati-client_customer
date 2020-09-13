import 'package:flutter/material.dart';
import 'package:haweyati/src/utils/const.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/src/ui/widgets/service-list-item.dart';
import 'package:haweyati/src/ui/views/live-scrollable_view.dart';
import 'package:haweyati/services/finishing-material_service.dart';
import 'package:haweyati/src/ui/pages/services/finishing-material/list_page.dart';

class FinishingMaterialCategoriesListPage extends StatelessWidget {
  final _service = FinishingMaterialService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(hideHome: true),
      body: LiveScrollableView(
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
