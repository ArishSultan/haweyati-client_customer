import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/ui/widgets/rich-price-text.dart';

class DetailRow extends TableRow {
  DetailRow(String label, String detail, [bool bold = true])
      : super(children: [
          Text(
            label,
            style: TextStyle(
              fontSize: bold ? 16: 12,
              color: bold ? Color(0xFF313F53) : Colors.grey,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            detail,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Lato',
              color: Color(0xFF313F53),
            ),
          )
        ]);
}

class PriceRow extends TableRow {
  PriceRow(String label, double price)
      : super(children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontFamily: 'Lato',
              height: 1.9,
            ),
          ),
          RichPriceText(price: price)
        ]);
}

class PercentRow extends TableRow {
  PercentRow(String label, double price)
      : super(children: [
    Text(
      label,
      style: TextStyle(
        fontSize: 13,
        color: Colors.grey,
        fontFamily: 'Lato',
        height: 1.9,
      ),
    ),
    Text('${price * 100} %',
      style: TextStyle(
        color: Color(0xFF313F53),
        fontSize: 14,
        fontFamily: 'Lato',
      ),
      textAlign: TextAlign.right,
    )
  ]);
}

class TotalPriceRow extends TableRow {
  TotalPriceRow(double price)
      : super(children: [
          Text(
            'Total',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'Lato',
              height: 3,
            ),
          ),
          RichPriceText(price: price, fontSize: 17, fontWeight: FontWeight.bold)
        ]);
}
