import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/services/building-material/model.dart';
import 'package:haweyati/src/ui/pages/services/building-material/service-detail_page.dart';
import 'package:haweyati/src/ui/views/service-item_view.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class BuildingMaterialItemPage extends StatelessWidget {
  final BuildingMaterial item;

  BuildingMaterialItemPage(this.item) {
    item.pricing.first = item.pricing
      .firstWhere((element) => element.city == AppData.instance().city);
  }

  @override
  Widget build(BuildContext context) {
    return ServiceItemView(
      title: item.name,
      image: item.image.name,
      price: TextSpan(
        text: ''
          '${item.pricing.first.price12yard.toStringAsFixed(2)} SAR - '
          '${item.pricing.first.price20yard.toStringAsFixed(2)} SAR',
        style: TextStyle(
          color: Color(0xFF313F53),
          // fontWeight: FontWeight.w500
        ),
        children: [
          TextSpan(
            text: '   per container',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600
            )
          )
        ]
      ),
      bottom: FlatActionButton(
        label: 'Buy Now',
        onPressed: () => navigateTo(context, BuildingMaterialServiceDetailPage(item)),
      )
    );
  }
}
