import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/models/dumpster_model.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/utils/app-data.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/flat-action-button.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'service-detail_page.dart';

class DumpsterItemPage extends StatelessWidget {
  final Dumpster dumpster;

   DumpsterItemPage(this.dumpster) {
    dumpster.pricing.first = dumpster.pricing
      .firstWhere((element) => element.city == AppData.instance().city);
  }

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      appBar: HaweyatiAppBar(),
      body: DottedBackgroundView(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(children: [
            SizedBox(
              height: 250,
              child: Center(
                child: Image.network(
                  HaweyatiService.resolveImage(dumpster.image.name),
                  height: 250,
                ),
              )
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Text('${dumpster.size} Yard Dumpster', style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20
              ))
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: RichText(
                text: TextSpan(
                  text: '${dumpster.pricing.first.rent.round()} SAR',
                  style: TextStyle(
                    color: Color(0xFF313F53),
                    // fontWeight: FontWeight.w500
                  ),
                  children: [
                    TextSpan(
                      text: '   per ${dumpster.pricing.first.days} days',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade600
                      )
                    )
                  ]
                )
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(dumpster.description, style: TextStyle(color: Colors.grey.shade600)),
            ),
          ], crossAxisAlignment: CrossAxisAlignment.start)
        )
      ),
      bottom: FlatActionButton(
        label: 'Rent Now',
        onPressed: () => navigateTo(context, DumpsterServiceDetailPage(dumpster))
      )
    );
  }
}
