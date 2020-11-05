import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/common/simple-form.dart';
import 'package:haweyati/src/models/order/dumpster/order-item_model.dart';
import 'package:haweyati/src/models/order/order-location_model.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/ui/pages/services/dumpster/order-confirmation_page.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/order-progress_view.dart';
import 'package:haweyati/src/ui/widgets/drop-off-picker.dart';
import 'package:haweyati/src/ui/widgets/image-picker-widget.dart';
import 'package:haweyati/src/ui/widgets/location-picker.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class DumpsterTimeAndLocationPage extends StatefulWidget {
  final $Order<DumpsterOrderItem> _order;

  DumpsterTimeAndLocationPage(this._order) {
    if (_order.location == null) {
      _order.location = OrderLocation.fromAppData();
    }
  }

  @override
  _DumpsterTimeAndLocationPageState createState() =>
      _DumpsterTimeAndLocationPageState();
}

class _DumpsterTimeAndLocationPageState
    extends State<DumpsterTimeAndLocationPage> {
  var _allow = false;
  final _formKey = GlobalKey<SimpleFormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return OrderProgressView<DumpsterOrderItem>(
      key: _scaffoldKey,
      progress: .5,
      allow: _allow,
      order: widget._order,
      builder: (order) {
        return <Widget>[
          HeaderView(
            title: 'Time & Location',
            subtitle: loremIpsum.substring(0, 80),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: OrderLocationPicker(order, true),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: DropOffPicker(order, () => setState(() => _allow = true)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ImagePickerWidget(),
          ),
          SimpleForm(
            key: _formKey,
            onSubmit: () {},
            child: TextFormField(
              style: TextStyle(fontFamily: 'Lato'),
              initialValue: widget._order.note,
              decoration: InputDecoration(
                labelText: 'Note',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'Write note here..',
              ),
              maxLines: 4,
              maxLength: 80,
              onSaved: (text) => widget._order.note = text,
            ),
          )
        ];
      },
      $onContinue: (order) async {
        await _formKey.currentState.submit();

        /// Setup Pickup Time and Date for the Dumpster
        // final location = order.location as RentableOrderLocation;
        //
        // final item = order.items.first.item;
        // final product = item.product;
        //
        // location.pickUpTime = location.dropOffTime;
        // location.pickUpDate = location.dropOffDate
        //     .add(Duration(days: item.extraDays + product.pricing.first.days));

        navigateTo(context, DumpsterOrderConfirmationPage(order));
      },
    );
  }
}
