import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/counter.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:haweyati/src/rest/haweyati-service.dart';
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/ui/pages/products/finishing-material/finishing-material_pages.dart';
import 'package:haweyati_client_data_models/models/user/supplier_model.dart';
import 'package:hive/hive.dart';

class CartOrderPage extends StatefulWidget {
  CartOrderPage(this._items);
  final List<FinishingMaterialOrderable> _items;

  @override
  _CartOrderPageState createState() => _CartOrderPageState();
}

class _CartOrderPageState extends State<CartOrderPage> {
  final _count = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      appBar: HaweyatiAppBar(hideHome: true, hideCart: true),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemCount: widget._items.length,
        itemBuilder: (context, index) => Dismissible(
          key: UniqueKey(),
          background: Container(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  CupertinoIcons.trash,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ),
          ),
          onDismissed: (_) {
            widget._items.removeAt(index);
            if (widget._items.isEmpty) {
              Navigator.of(context).pop();
              return;
            }
            setState(() {});
          },
          child: _CartOrderItem(
            item: widget._items[index],
            onChange: (val) {
              _count.value += val;
              print(_count.value);
            },
          ),
        ),
      ),
      bottom: ValueListenableBuilder(
        valueListenable: _count,
        builder: (context, val, widget) => RaisedActionButton(
          label: 'Proceed',
          onPressed: val > 0 ? _proceed : null,
        ),
      ),
    );
  }

  _proceed() async {
    final order = Order<FinishingMaterialOrderable>(OrderType.finishingMaterial);

    Box<Supplier> box = await Hive.openBox('supplier');
    // TODO: check
    order.supplier =box.getAt(0);
    await box.close();
    print(widget._items.where((element) => element.qty > 0).toList().map((e) =>
    e.variants == null || e?.variants?.isEmpty ? e.price : e.variants['price']).toList());
    widget._items.where((element) => element.qty > 0).forEach(
        (element) => order.addProduct(element, element.qty * element.price));
    navigateTo(context, FinishingMaterialOrderConfirmationPage(order, true));
  }

}

class _CartOrderItem extends StatefulWidget {
  _CartOrderItem({this.item, this.onChange});

  final Function(int val) onChange;
  final FinishingMaterialOrderable item;

  FinishingMaterial get product => item.product;

  @override
  State<_CartOrderItem> createState() {
    if (product.options?.isNotEmpty ?? false) {
      return __CartOrderItemWithVariantsState();
    } else {
      return __CartOrderItemState();
    }
  }
}

class __CartOrderItemState extends State<_CartOrderItem> {
  @override
  Widget build(BuildContext context) {
    print("Temp test");
    print(widget.item.price);
    widget.item.price = widget.product.price = widget.product.price;
    print(widget.item.price);

    return DarkContainer(
      margin: const EdgeInsets.only(bottom: 15),
      child: _ListTile(widget.item, widget.onChange),
    );
  }
}

class __CartOrderItemWithVariantsState extends State<_CartOrderItem> {
  var _expanded = false;
  final _selectedVariant = <String, dynamic>{};

  @override
  void initState() {
    super.initState();

    widget.product.options.forEach((element) {
      _selectedVariant[element.name] = element.values.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final variant = widget.product.variant(_selectedVariant);
    widget.item.variants = variant.second;
    widget.item.price = variant.first;
    widget.item.product.price = variant.first;
    print(widget.item.variants);

    return DarkContainer(
      child: Column(children: [
        _ListTile(widget.item, widget.onChange),
        if (_expanded) Wrap(children: _buildOptions(widget.product.options)),
        Divider(thickness: 1, height: 1),
        ConstrainedBox(
          constraints: BoxConstraints.expand(height: 25),
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: Transform.rotate(
              angle: _expanded ? 3.14 : 0,
              child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ),
            onPressed: () => setState(() => _expanded = !_expanded),
          ),
        )
      ]),
      margin: const EdgeInsets.only(bottom: 15),
    );
  }

  _buildOptions(List<FinishingMaterialOption> options) {
    final list = <Widget>[Divider(thickness: 1, height: 1)];

    for (final option in options) {
      list.add(Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Text(option.name, style: TextStyle(fontWeight: FontWeight.bold)),
      ));

      var row = <Widget>[];
      for (final value in option.values) {
        row.add(Row(
            children: [
          Radio(
            value: value,
            visualDensity: VisualDensity.compact,
            groupValue: _selectedVariant[option.name],
            onChanged: (val) => setState(() {
              _selectedVariant[option.name] = value;
            }),
          ),
          Text(value)
        ]));

        if (row.length == 2) {
          list.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(children: row),
          ));
          row = <Widget>[];
        }
      }

      if (row.isNotEmpty) {
        list.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: row.first,
        ));
      }
    }

    return list;
  }
}

class _ListTile extends ListTile {
  _ListTile(FinishingMaterialOrderable item, Function onChange)
      : super(
          contentPadding: const EdgeInsets.all(10),
          title: Text((item.product).name),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(children: [
              Expanded(
                child: Text('${(item.product).price.toStringAsFixed(2)} SAR'),
              ),
              Counter(
                initialValue: item.qty.toDouble(),
                onChange: (val) {
                  onChange(val.toInt() - item.qty);
                  item.qty = val.round();
                },
              )
            ]),
          ),
          leading: Container(
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 10,
                  color: Colors.grey.shade500,
                )
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  HaweyatiService.resolveImage((item.product).image.name),
                ),
              ),
            ),
          ),
        );
}
