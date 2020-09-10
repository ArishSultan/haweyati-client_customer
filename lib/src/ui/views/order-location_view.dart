import 'package:flutter/material.dart';
import 'package:haweyati/src/utils/date-formatter.dart';
import 'package:haweyati/src/models/order/order-location_model.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/edit-button.dart';
import 'package:haweyati/src/utils/const.dart';

class OrderLocationView extends DarkContainer {
  OrderLocationView({
    OrderLocation location,
    Function onEdit,
  }): super(
    margin: const EdgeInsets.only(top: 18),
    padding: const EdgeInsets.fromLTRB(15, 17, 15, 15),

    child: Column(children: [
      Row(children: [
        Text('Time & Location', style: TextStyle(
          color: Color(0xFF313F53),
          fontWeight: FontWeight.bold
        )),
        Spacer(),
        EditButton(onPressed: onEdit),
      ]),

      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(top: 3 ),
            child: Image.asset(LocationIcon, height: 18),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(location.address, style: TextStyle(
              height: 1,
              color: Color(0xFF313F53),
            )),
          ))
        ], crossAxisAlignment: CrossAxisAlignment.start),
      ),

      Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
          children: [
            TableRow(children: [
              Text('Drop-off Date', style: TextStyle(fontSize: 13, color: Colors.grey)),
              Text('Drop-off Time', style: TextStyle(fontSize: 13, color: Colors.grey)),
            ]),

            TableRow(children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(location.dropOffDate.formated, style: TextStyle(fontSize: 13, color: Color(0xFF313F53))),
              ),
              Text(location.dropOffTime.toString(), style: TextStyle(fontSize: 13, color: Color(0xFF313F53))),
            ])
          ],
        ),
      ),

      if (location is RentableOrderLocation)
        Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
            children: [
              TableRow(children: [
                Text('Pick-up Date', style: TextStyle(fontSize: 13, color: Colors.grey)),
                Text('Pick-up Time', style: TextStyle(fontSize: 13, color: Colors.grey)),
              ]),

              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(location.pickUpDate.formated,
                    style: TextStyle(fontSize: 13, color: Color(0xFF313F53))
                  ),
                ),
                Text('${location.dropOffTime.toString()} (Approx.)', style: TextStyle(fontSize: 13, color: Color(0xFF313F53))),
              ])
            ]
          )
        )
    ])
  );
}
