import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/widgets/table-rows.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/ui/widgets/details-table.dart';
import 'package:haweyati/src/ui/views/order-confirmation_view.dart';
import 'package:haweyati/src/models/order/building-material/order-item_model.dart';
import 'package:haweyati/src/ui/pages/services/dumpster/order-confirmation_page.dart';

class BuildingMaterialOrderConfirmationPage extends StatelessWidget {
  final $Order<BuildingMaterialOrderItem> _order;
  BuildingMaterialOrderConfirmationPage(this._order);

  @override
  Widget build(BuildContext context) {
    return $OrderConfirmationView<BuildingMaterialOrderItem>(
      order: _order,
      itemsBuilder: (lang, order) => order.items
          .map((holder) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: OrderConfirmationItem(
                  title: holder.item.product.name + ' (${holder.item.size})',
                  image: holder.item.product.image.name,
                  table: DetailsTableAlt([
                    'Price',
                    'Container'
                  ], [
                    '${holder.item.price.toStringAsFixed(0)} SAR',
                    lang.nPieces(holder.item.qty)
                  ]),
                ),
          ))
          .toList(),
      pricingBuilder: (lang, order) => order.items
          .map(
            (holder) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: DetailsTable([
                DetailRow(
                  '${holder.item.product.name} (${holder.item.size})',
                  lang.nPieces(holder.item.qty),
                ),
                PriceRow('Price ${lang.nPieces(holder.item.qty)}', holder.item.price * holder.item.qty)
              ]),
            ),
          )
          .toList(),
    );
  }
}
