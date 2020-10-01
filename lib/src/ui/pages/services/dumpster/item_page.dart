import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/src/ui/views/service-item_view.dart';
import 'package:haweyati/src/models/services/dumpster/model.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/ui/pages/services/dumpster/service-detail_page.dart';

class DumpsterItemPage extends StatelessWidget {
  final Dumpster dumpster;

  DumpsterItemPage(this.dumpster) {
    dumpster.pricing.first = dumpster.pricing
      .firstWhere((element) => element.city == AppData.instance().city);
  }

  @override
  Widget build(BuildContext context) {
    return ServiceItemView(
      title: '${dumpster.size} Yards Container',
      image: dumpster.image.name,
      price: TextSpan(
        text: ''
          '${dumpster.pricing.first.rent.toStringAsFixed(2)} SAR',
        style: TextStyle(
          color: Color(0xFF313F53),
          // fontWeight: FontWeight.w500
        ),
        children: [
          TextSpan(
            text: '   per ${dumpster.pricing.first.days} days ',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade600
            )
          )
        ]
      ),
      description: dumpster.description,
      bottom: RaisedActionButton(
        label: 'Buy Now',
        onPressed: () => navigateTo(context, DumpsterServiceDetailPage(dumpster)),
      )
    );
  }
}
