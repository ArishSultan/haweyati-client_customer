import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/location_model.dart';
import 'package:haweyati/src/models/order/finishing-material/order-item_model.dart';
import 'package:haweyati/src/models/order/order-item_model.dart';
import 'package:haweyati/src/models/order/order-location_model.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/models/services/finishing-material/model.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/pages/services/finishing-material/order-confirmation_page.dart';
import 'package:haweyati/src/ui/views/order-progress_view.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/ui/widgets/counter.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/location-picker.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class FinishingMaterialServiceDetailPage extends StatefulWidget {
  final FinishingMaterial item;
  FinishingMaterialServiceDetailPage(this.item);

  @override
  _FinishingMaterialServiceDetailPageState createState() => _FinishingMaterialServiceDetailPageState();
}

class _FinishingMaterialServiceDetailPageState extends State<FinishingMaterialServiceDetailPage> {
  final _order = Order(OrderType.finishingMaterial);
  final _item = FinishingMaterialOrderItem();

  final _selectedVariants = <String, String>{};
  final _availableVariants = <String, List<String>>{};

  @override
  void initState() {
    super.initState();

    _order.customer = AppData.instance().user;
    _order.location = OrderLocation()
      ..update(AppData.instance().location);

    if (widget.item.variants?.isNotEmpty ?? false) {
      for (final option in widget.item.options) {
        final values = option.values;
        _selectedVariants[option.name] = values[0];
        _availableVariants[option.name] = values;
      }

      final element = widget.item.variants?.firstWhere((element) {
        for (final key in element.keys) {
          if (key == 'price') continue;

          if (_selectedVariants[key] != element[key]) return false;
        }

        return true;
      }, orElse: () => null);

      if (element != null) {
        _item.price = double.tryParse(element['price']) ?? 0.0;
      }
    } else {
      _item.price = widget.item.price;
    }

    _item.product = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return OrderProgressView.sliver(
      children: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
          sliver: SliverToBoxAdapter(child: Row(children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                  color: Color(0xEEFFFFFF),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: Colors.grey.shade300
                    )
                  ],
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(HaweyatiService.resolveImage(widget.item.images.name))
                  )
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(widget.item.name, style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF313F53),
                    fontWeight: FontWeight.bold
                )),
              ),
            )
          ])),
        ),

        if (widget.item.variants?.isNotEmpty ?? false)
          ..._buildVariants(),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverToBoxAdapter(child: DarkContainer(
            height: 80,
            margin: const EdgeInsets.only(
                top: 20, bottom: 30
            ),
            padding: const EdgeInsets.all(15),
            child: Row(children: [
              Column(children: [
                Text('Quantity', style: TextStyle(
                    color: Color(0xFF313F53),
                    fontWeight: FontWeight.bold
                )),
                Spacer(),
                Text('${_item.price.toStringAsFixed(2)} SAR', style: TextStyle(
                    color: Color(0xFF313F53)
                ))
              ], crossAxisAlignment: CrossAxisAlignment.start),
              Counter(
                  initialValue: _item.qty.toDouble(),
                  onChange: (count) => setState(() => _item.qty = count?.round())
              )
            ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
          )),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
          sliver: SliverToBoxAdapter(child: LocationPicker(
              initialValue: _order.location,
              onChanged: (Location location) => _order.location = location
          )),
        ),
      ],

      onContinue: _item.qty > 0 ? () {
        _item.variants = _selectedVariants;

        _order.items = [OrderItemHolder(
          item: _item,
          subtotal: _item.price * _item.qty
        )];

        _order.total = _item.price * _item.qty;

        navigateTo(context, FinishingMaterialOrderConfirmationPage(_order));
      } : null
    );
  }

  List<Widget> _buildVariants() {
    List<Widget> list = [];

    _availableVariants.forEach((key, values) {
      list.add(SliverPadding(
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
        sliver: SliverToBoxAdapter(
          child: Text(key, style: TextStyle(
            fontSize: 13,
            color: Color(0xFF313F53),
            fontWeight: FontWeight.bold
          ))
        ),
      ));

      list.add(SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width / 55
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            return Row(children: [
              Radio(
                visualDensity: VisualDensity.comfortable,
                value: values[index],
                groupValue: _selectedVariants[key],
                onChanged: (val) => _changedVariants(key, val),
              ),
              Text(values[index])
            ]);
          }, childCount: values.length),
        ),
      ));
    });

    return list;
  }

  _changedVariants(String key, String value) {
    _selectedVariants[key] = value;

    final element = widget.item.variants?.firstWhere((element) {
      for (final key in element.keys) {
        if (key == 'price') continue;

        if (_selectedVariants[key] != element[key]) return false;
      }

      return true;
    }, orElse: () => null);

    if (element != null) {
      _item.price = double.tryParse(element['price']) ?? 0.0;
    }

    setState(() {});
  }
}
