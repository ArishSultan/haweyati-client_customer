import 'package:flutter/material.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/ui/widgets/drop-off-picker.dart';
import 'package:haweyati/src/ui/widgets/location-picker.dart';
import 'package:haweyati/src/ui/views/order-progress_view.dart';
import 'package:haweyati/src/models/order/order-location_model.dart';
import 'package:haweyati/src/ui/pages/services/building-material/order-confirmation_page.dart';

class BuildingMaterialTimeAndLocationPage extends StatefulWidget {
  final $Order _order;

  BuildingMaterialTimeAndLocationPage(this._order) {
    if (_order.location == null) {
      _order.location = OrderLocation.fromAppData();
    }
  }

  @override
  _BuildingMaterialTimeAndLocationPageState createState() =>
      _BuildingMaterialTimeAndLocationPageState();
}

class _BuildingMaterialTimeAndLocationPageState
    extends State<BuildingMaterialTimeAndLocationPage> {
  var _allow = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return OrderProgressView(
      progress: .5,
      order: widget._order,
      builder: ($Order order) => <Widget>[
        HeaderView(
          title: 'Time & Location',
          subtitle: loremIpsum.substring(0, 80),
        ),
        OrderLocationPicker(order),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          child: DropOffPicker(order, () => setState(() => _allow = true)),
        ),
        // ImagePickerWidget()
        Form(
          key: _formKey,
          child: TextFormField(
            style: TextStyle(fontFamily: 'Lato'),
            initialValue: widget._order.note,
            decoration: InputDecoration(
              labelText: 'Note',
              hintText: 'Write note here..',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            maxLines: 4,
            maxLength: 80,
            onSaved: (text) => widget._order.note = text,
          ),
        )
      ],
      $onContinue: _allow
          ? (order) {
              _formKey.currentState.save();
              navigateTo(context, BuildingMaterialOrderConfirmationPage(order));
            }
          : null,
    );
  }
}
