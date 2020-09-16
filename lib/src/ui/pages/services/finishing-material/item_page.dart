import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/models/finishing-product.dart';
import 'package:haweyati/src/ui/pages/services/finishing-material/service-detail_page.dart';
import 'package:haweyati/src/ui/views/service-item_view.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class FinishingMaterialItemPage extends StatelessWidget {
  final FinishingMaterial item;
  FinishingMaterialItemPage(this.item);

  @override
  Widget build(BuildContext context) {
    return ServiceItemView(
      title: item.name,
      image: item.images.name,
      bottom: Container(
        height: 70,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: 7.5
        ),
        child: Row(children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                horizontal: 7.5
              ),
              constraints: BoxConstraints.expand(height: 40),
              child: FlatButton(
                textColor: Colors.white,
                color: Colors.red,
                shape: StadiumBorder(),
                child: Text('Add To Cart'),
                onPressed: () {}
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                horizontal: 7.5
              ),
              constraints: BoxConstraints.expand(height: 40),
              child: FlatButton(
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                shape: StadiumBorder(),
                child: Text('Buy Now'),
                onPressed: () => navigateTo(context, FinishingMaterialServiceDetailPage(item))
              ),
            ),
          ),
        ]),
      ),
      price: TextSpan(
        text: '${item.price.round()} SAR',
        style: TextStyle(
          color: Color(0xFF313F53),
        )
      ),
    );
  }
}
