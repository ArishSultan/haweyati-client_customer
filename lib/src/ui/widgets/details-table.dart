import 'package:flutter/material.dart';

class DetailsTableAlt extends Table {
  static _generateFlexes(List<double> flexes) {
    final map = <int, FlexColumnWidth>{};

    for (var i = 0; i < flexes.length; ++i) {
      map[i] = FlexColumnWidth(flexes[i]);
    }

    return map;
  }

  DetailsTableAlt(List<String> headers, List<String> details, [List<double> flexes = const [3, 2]])
      : super(
          columnWidths: _generateFlexes(flexes),
          textBaseline: TextBaseline.alphabetic,
          defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
          children: [
            TableRow(children: headers.map((header) => Text(
              header,
              style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
            )).toList()),
            TableRow(children: details.map((detail) => Text(
              detail,
              style: TextStyle(fontSize: 13, color: Color(0xFF313F53), height: 1.5),
            )).toList()),
          ]
        );
}

class DetailsTable extends Table {
  DetailsTable(List<TableRow> children)
      : super(
          textBaseline: TextBaseline.alphabetic,
          columnWidths: {0: FlexColumnWidth(3), 1: FlexColumnWidth(2)},
          defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
          children: children,
        );
}
