import 'package:haweyati/src/ui/widgets/cart/cart-item.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:haweyati_client_data_models/models/user/supplier_model.dart';

import 'cart-order_page.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati/src/ui/views/localized_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';

class CartPage extends StatefulWidget {
  CartPage();

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<FinishingMaterial> _items;
  final _cart = Hive.lazyBox<FinishingMaterial>('cart');

  @override
  void initState() {
    super.initState();

    _cartProducts().then((value) {
      _items = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (context, lang) => NoScrollView(
        appBar: HaweyatiAppBar(
          hideCart: true,
          hideHome: true,
          actions: [
            Center(child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(lang.nItem(_cart.length), style: TextStyle(
                color: Colors.white
              )),
            )),
          ]
        ),

        body: _buildView(),
        bottom: RaisedActionButton(
          label: 'Place An Order',
          onPressed: _cart.isNotEmpty ? () => _placeOrder(context): null,
        ),
      ),
    );
  }

  Widget _buildView() {
    if (_cart.isEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          'Cart is Empty, Add Some products in cart to proceed',
          textAlign: TextAlign.center, style: TextStyle(
          fontStyle: FontStyle.italic, color: Colors.grey
        )),
      ));
    }

    if (_items != null) {
      return ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15, vertical: 10
            ),
            child: CartItem(
              item: _items[index],
              onRemoved: () async {
                _items.removeAt(index);
                await _cart.deleteAt(index);

                if (_items.isEmpty) {
                  Navigator.pop(context);
                } else setState(() {});
              },
            ),
          );
        }
      );
    } else {
      return Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
  }

  void _placeOrder(context) async {
    navigateTo(context, CartOrderPage(_items
      .map((e) => FinishingMaterialOrderable(product: e))
      .toList()
    ));
  }

  Future<List<FinishingMaterial>> _cartProducts() async {
    Iterable<Future<FinishingMaterial>> getProducts() sync* {
      for (var i = 0; i < _cart.length; ++i) {
        yield _cart.getAt(i);
      }
    }

    return (await Future.wait(getProducts())).toList();
  }

}
