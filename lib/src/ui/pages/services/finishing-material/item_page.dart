import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/services/finishing-material/model.dart';
import 'package:haweyati/src/ui/pages/services/finishing-material/service-detail_page.dart';
import 'package:haweyati/src/ui/views/service-item_view.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class FinishingMaterialItemPage extends StatefulWidget {
  final FinishingMaterial item;
  FinishingMaterialItemPage(this.item);

  @override
  _FinishingMaterialItemPageState createState() => _FinishingMaterialItemPageState();
}

class _FinishingMaterialItemPageState extends State<FinishingMaterialItemPage> {
  final _appData = AppData.instance();

  @override
  Widget build(BuildContext context) {
    return ServiceItemView(
      title: widget.item.name,
      image: widget.item.images.name,
      description: widget.item.description,

      bottom: Container(
        height: 80,
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
              child: FutureBuilder<bool>(
                future: _appData.canAddToCart(widget.item),
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  return FlatButton(
                    textColor: Colors.white,
                    color: Colors.red,
                    disabledColor: Color(0x77ff0000),
                    disabledTextColor: Colors.white,
                    shape: StadiumBorder(),
                    child: snapshot.connectionState == ConnectionState.done
                      ? Text(snapshot.data ?? true ? 'Add To Cart' : 'Already Added')
                      : SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                    onPressed: snapshot.data ?? true ? () async {
                      await _appData.addToCart(widget.item);
                      setState(() {});
                    } : null
                  );
                }
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
                onPressed: () => navigateTo(context, FinishingMaterialServiceDetailPage(widget.item))
              ),
            ),
          ),
        ]),
      ),
      price: _buildPrice()
    );
  }

  _buildPrice() {
    if (widget.item.variants?.isNotEmpty ?? false) {
      final range = _minAndMaxPrice(widget.item.variants);

      return TextSpan(
        text: '${range[0]?.toStringAsFixed(2)} SAR - ',
        style: TextStyle(
          color: Color(0xFF313F53),
        ),

        children: [
          TextSpan(
            text: '${range[1]?.toStringAsFixed(2)} SAR',
            style: TextStyle(
              color: Color(0xFF313F53),
            ),
          )
        ]
      );
    } else {
      return TextSpan(
        text: '${widget.item.price?.toStringAsFixed(2)} SAR',
        style: TextStyle(
          color: Color(0xFF313F53),
        )
      );
    }
  }

  static List<double> _minAndMaxPrice(List<Map<String, dynamic>> variants) {
    var min = double.tryParse(variants[0]['price']);
    var max = min;

    for (final variant in variants) {
      final price = double.tryParse(variant['price']) ?? 0.0;

      if (price < min) {
        min = price;
      }

      if (price > max) {
        max = price;
      }
    }

    return [min, max];
  }
}
