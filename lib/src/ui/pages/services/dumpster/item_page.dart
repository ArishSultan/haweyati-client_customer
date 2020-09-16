import 'package:haweyati/src/ui/widgets/flat-action-button.dart';

import 'service-detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/utils/app-data.dart';
import 'package:haweyati/src/models/dumpster_model.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/src/ui/views/service-item_view.dart';

class DumpsterItemPage extends StatelessWidget {
  final Dumpster dumpster;

  DumpsterItemPage(this.dumpster) {
    dumpster.pricing.first = dumpster.pricing
      .firstWhere((element) => element.city == AppData.instance().city);
  }

  @override
  Widget build(BuildContext context) {
    return ServiceItemView(
      title: '${dumpster.size} Yard Dumpster',
      image: dumpster.image.name,
      price: TextSpan(
        text: '${dumpster.rent} SAR',
        style: TextStyle(
          color: Color(0xFF313F53),
          // fontWeight: FontWeight.w500
        ),
        children: [
          TextSpan(
            text: '   per ${dumpster.days} days',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600
            )
          )
        ]
      ),
      bottom: FlatActionButton(
        label: 'Rent Now',
        onPressed: () => navigateTo(context, DumpsterServiceDetailPage(dumpster))
      )
    );
  }
}
