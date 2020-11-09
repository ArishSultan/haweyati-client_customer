import 'package:flutter/cupertino.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:haweyati/src/ui/widgets/service-list-tile.dart';

class CartItem extends Dismissible {
  CartItem({
    Function onRemoved,
    FinishingMaterial item
  }): super(
    key: UniqueKey(),
    direction: DismissDirection.endToStart,

    background: Container(
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(CupertinoIcons.trash, color: CupertinoColors.destructiveRed, size: 30),
        ),
      ),
    ),

    onDismissed: (_) { onRemoved(); },

    child: ProductListTile(
      onTap: () {},
      name: item.name,
      image: item.image.name,
      margin: const EdgeInsets.all(0),
    )
  );
}
