import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/app.dart';
import 'package:haweyati/src/common/simple-form.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/order/dumpster/order-item_model.dart';
import 'package:haweyati/src/models/order/order-location_model.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/models/services/dumpster/model.dart';
import 'package:haweyati/src/ui/pages/services/dumpster/order-confirmation_page.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/order-progress_view.dart';
import 'package:haweyati/src/ui/widgets/drop-off-picker.dart';
import 'package:haweyati/src/ui/widgets/image-picker-widget.dart';
import 'package:haweyati/src/ui/widgets/location-picker.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class DumpsterTimeAndLocationPage extends StatefulWidget {
  final Order _order;

  DumpsterTimeAndLocationPage(this._order) {
    if (_order.location == null) {
      final _appData = AppData.instance();

      _order.location = RentableOrderLocation
          .fromLocation(_appData.location);
    }
  }

  @override
  _DumpsterTimeAndLocationPageState createState() => _DumpsterTimeAndLocationPageState();
}

class _DumpsterTimeAndLocationPageState extends State<DumpsterTimeAndLocationPage> {
  var _allow = false;
  final _formKey = GlobalKey<SimpleFormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return OrderProgressView(
      key: _scaffoldKey,
      progress: .5,

      children: [
        HeaderView(
          title: 'Time & Location',
          subtitle: loremIpsum.substring(0, 80),
        ),

        LocationPicker(
          initialValue: widget._order.location,
          onChanged: widget._order.location.update
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 20, bottom: 40
          ),
          child: DropOffPicker(
            onBuilt: () => setState(() => _allow = true),
            initialDate: widget._order.location.dropOffDate,
            initialTime: widget._order.location.dropOffTime,
            onDateChanged: (date) => widget._order.location.dropOffDate = date,
            onTimeChanged: (time) => widget._order.location.dropOffTime = time
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: ImagePickerWidget(),
        ),

        SimpleForm(
          key: _formKey,
          onSubmit: () {},
          child: TextFormField(
            style: TextStyle(
              fontFamily: 'Lato'
            ),
            initialValue: widget._order.note,
            decoration: InputDecoration(
              labelText: 'Note',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: 'Write note here..'
            ),
            maxLines: 4,
            maxLength: 80,

            onSaved: (text) => widget._order.note = text,
          )
        )
      ],

      onContinue: (widget._order.location.dropOffDate != null
      && widget._order.location.dropOffTime != null) ? () async {
        await _formKey.currentState.submit();

        /// Setup Pickup Time and Date for the Dumpster
        final location = widget._order.location as RentableOrderLocation;

        final item = widget._order.items.first.item as DumpsterOrderItem;
        final product = item.product as Dumpster;

        location.pickUpTime = location.dropOffTime;
        location.pickUpDate = location.dropOffDate.add(Duration(
            days: item.extraDays + product.pricing.first.days
        ));

        navigateTo(context, DumpsterOrderConfirmationPage(widget._order));
      }: null
    );
  }
}
