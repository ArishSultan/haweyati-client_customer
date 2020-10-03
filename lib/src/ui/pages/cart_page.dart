import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/models/order/finishing-material/order-item_model.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/src/ui/pages/cart-order_page.dart';
import '../../models/services/finishing-material/model.dart';
import 'package:haweyati/src/ui/widgets/service-list-tile.dart';

// ignore: must_be_immutable
class CartPage extends StatelessWidget {
  final LazyBox<FinishingMaterial> _cart;
  ValueListenable<LazyBox<FinishingMaterial>> _box;

  CartPage(): _cart = Hive.lazyBox<FinishingMaterial>('cart') {
    _box = _cart.listenable();
  }

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      appBar: HaweyatiAppBar(
        hideCart: true,
        hideHome: true,
        actions: [
          ValueListenableBuilder(
            valueListenable: _box,
            builder: (context, val, widget) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text('${val.length} ${val.length == 1 ? 'Item' : 'Items'}', style: TextStyle(
                    color: Colors.white
                  )),
                )
              );
            }
          )
        ]
      ),
      body: ValueListenableBuilder(
        valueListenable: _box,
        builder: (context, LazyBox<FinishingMaterial> box, widget) {
          if (box.isEmpty) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'Cart is Empty, Add Some products in cart to proceed',
                textAlign: TextAlign.center, style: TextStyle(
                fontStyle: FontStyle.italic, color: Colors.grey
              )),
            ));
          }

          return ListView.builder(
            itemBuilder: (context, index) => FutureBuilder(
              future: _cart.getAt(index),
              builder: (context, AsyncSnapshot<FinishingMaterial> snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 15
                  ),
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,

                    background: Container(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(CupertinoIcons.trash, color: Colors.red, size: 30),
                        ),
                      ),
                    ),

                    onDismissed: (_) async {
                      await _cart.deleteAt(index);

                      if (_cart.isEmpty) {
                        Navigator.of(context).pop();
                      }
                    },

                    child: ServiceListItem(
                      margin: const EdgeInsets.all(0),
                      image: snapshot.data?.images?.name ?? '',
                      name: snapshot.data?.name ?? '',
                      onTap: () {}
                    )
                  ),
                );
              },
            ),
            itemCount: box.length,
          );
        }
      ),

      bottom: RaisedActionButton(
        label: 'Place An Order',
        onPressed: _cart.isNotEmpty ? () => _placeOrder(context): null,
      ),
    );
  }

  void _placeOrder(context) async {
    navigateTo(context, CartOrderPage(
      await Future.wait(_cartProducts().map((e) async => FinishingMaterialOrderItem(product: await e)))
    ));
  }

  Iterable<Future<FinishingMaterial>> _cartProducts() sync* {
    for (final key in _cart.keys) yield _cart.get(key);
  }
}
