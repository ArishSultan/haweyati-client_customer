import 'package:flutter/material.dart';
import 'package:haweyati/l10n/app_localizations.dart';
import 'package:haweyati/src/ui/widgets/table-rows.dart';
import 'package:haweyati/src/ui/widgets/details-table.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/buttons/edit-button.dart';
import 'package:haweyati/src/ui/views/order-confirmation_view.dart';
import 'package:haweyati/src/models/order/dumpster/order-item_model.dart';

class DumpsterOrderConfirmationPage extends StatelessWidget {
  final $Order<DumpsterOrderItem> _order;
  DumpsterOrderConfirmationPage(this._order);

  @override
  Widget build(BuildContext context) {
    return $OrderConfirmationView<DumpsterOrderItem>(
      order: _order,
      itemsBuilder: (lang, order) => order.items
          .map(
            (holder) => OrderConfirmationItem(
              title: '${holder.item.product.size} Yard Container',
              image: holder.item.product.image.name,
              table: DetailsTableAlt([
                'Price',
                'Quantity',
                'Days'
              ], [
                '${holder.item.product.rent.round()} SAR/${holder.item.product.days} days',
                AppLocalizations.of(context).nPieces(holder.item.qty),
                (holder.item.product.days + holder.item.extraDays).toString()
              ], [
                2,
                1,
                1
              ]),
            ),
          )
          .toList(),
      pricingBuilder: (lang, order) => order.items
          .map(
            (holder) => DetailsTable([
              DetailRow(
                '${holder.item.product.size} Yards Container',
                lang.nPieces(holder.item.qty),
              ),
              PriceRow(
                'Price (${lang.nDays(holder.item.product.days)})',
                holder.item.product.rent * holder.item.qty,
              ),
              if (holder.item.extraDays > 0)
                PriceRow(
                  'Extra (${lang.nDays(holder.item.extraDays)})',
                  holder.item.extraDaysPrice * holder.item.qty,
                ),
            ]),
          )
          .toList(),
    );
  }
}

class OrderConfirmationItem extends StatelessWidget {
  final String title;
  final String image;
  final Table table;

  OrderConfirmationItem({
    this.title,
    this.image,
    this.table,
  });

  @override
  Widget build(BuildContext context) {
    return DarkContainer(
      padding: const EdgeInsets.fromLTRB(15, 17, 15, 15),
      child: Column(children: [
        Row(children: [
          Text(
            'Service Details',
            style: TextStyle(
              color: Color(0xFF313F53),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          EditButton(onPressed: () {
            Navigator.of(context)..pop()..pop();
          }),
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(children: [
            Image.network(HaweyatiService.resolveImage(image), height: 60),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  title /*'${dumpster.size} Yard Container'*/,
                  style: TextStyle(
                    color: Color(0xFF313F53),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25),
          child: table,
        ),
      ]),
    );
  }
}
