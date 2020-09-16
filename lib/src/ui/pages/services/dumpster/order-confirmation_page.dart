import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/edit-button.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/views/order-location_view.dart';
import 'package:haweyati/src/models/order/order-location_model.dart';

class DumpsterOrderConfirmationPage extends StatelessWidget {
  // final Order _order;

  // DumpsterOrderConfirmationPage(this._order) {
  //   // final item = (_order.detail.items.first as DumpsterOrderItem);
  //   // (_order.location as RentableOrderLocation).pickUpDate = _order.location.dropOffDate.add(
  //   //   Duration(days: item.dumpster.pricing.first.days + item.extraDays)
  //   // );
  // }

  // String get _size => _item.dumpster.size;
  // int get _days => _item.dumpster.pricing.first.days;
  // double get _rent => _item.dumpster.pricing.first.rent;
  // double get _extraDayRent => _item.dumpster.pricing.first.extraDayRent;
  // DumpsterOrderItem get _item => _order.detail.items.first as DumpsterOrderItem;
  
  @override
  Widget build(BuildContext context) {
    return ScrollableView(
      showBackground: true,
      children: [
        HeaderView(
          title: 'Hello User,',
          subtitle: 'Please confirm your order details and your order reference number in HW38473'
        ),

        DarkContainer(
          padding: const EdgeInsets.fromLTRB(15, 17, 15, 15),
          child: Column(children: [
            Row(children: [
              Text('Service Details', style: TextStyle(
                color: Color(0xFF313F53),
                fontWeight: FontWeight.bold
              )),
              Spacer(),
              EditButton(onPressed: () {
                Navigator.of(context)
                  ..pop()
                  ..pop();
              }),
            ]),

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(children: [
                // Image.network(
                //   HaweyatiService.resolveImage(_item.dumpster.image.name),
                //   height: 60
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 10),
                //   child: Text('$_size Yard Container', style: TextStyle(
                //     color: Color(0xFF313F53),
                //     fontSize: 15, fontWeight: FontWeight.bold
                //   )),
                // )
              ]),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1)
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
                children: [
                  TableRow(children: [
                    Text('Price', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    Text('Quantity', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    Text('Days', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ]),

                  TableRow(children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 5),
                    //   child: Text('${_rent.round()} SAR/$_days days',
                    //     style: TextStyle(fontSize: 13, color: Color(0xFF313F53))
                    //   ),
                    // ),
                    Text('1 Piece', style: TextStyle(fontSize: 13, color: Color(0xFF313F53))),
                    // Text((_days + _item.extraDays).toString(), style: TextStyle(fontSize: 13, color: Color(0xFF313F53))),
                  ])
                ],
              ),
            )
          ]),
        ),

        // Padding(
        //   padding: const EdgeInsets.only(bottom: 30),
        //   child: OrderLocationView(location: _order.location),
        // ),

        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
          children: [
            TableRow(children: [
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10),
              //   child: Text('$_size Yards Container', style: TextStyle(
              //     fontSize: 16,
              //     color: Color(0xFF313F53),
              //     fontWeight: FontWeight.bold
              //   )),
              // ),
              Text('1 Piece', textAlign: TextAlign.right, style: TextStyle(
                fontSize: 12,
                fontFamily: 'Lato',
                color: Color(0xFF313F53),
              ))
            ]),
            TableRow(children: [
              Text('Price (10 Days)', style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontFamily: 'Lato', height: 1.9
              )),
              // Text(_rent.toString(), textAlign: TextAlign.right)
            ]),
            TableRow(children: [
              Text('Extra (3 Days)', style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontFamily: 'Lato', height: 1.9
              )),
              // Text(_rent.toString(), textAlign: TextAlign.right)
            ]),
            TableRow(children: [
              Text('Extra (3 Days)', style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontFamily: 'Lato', height: 1.9
              )),
              // Text(_rent.toString(), textAlign: TextAlign.right)
            ]),
            TableRow(children: [
              Text('Total', style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'Lato', height: 2.5
              )),
              // Text(_rent.toString(), textAlign: TextAlign.right, style: TextStyle(
              //   fontSize: 18,
              //   color: Color(0xFF313F53),
              // ))
            ]),
          ],
        )
      ]
    );
  }
}
