import 'package:flutter/material.dart';
import 'package:haweyati/src/common/simple-form.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/order/order-location_model.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/models/time-slot_model.dart';
import 'package:haweyati/src/ui/pages/services/scaffolding/order-confirmation_page.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/ui/widgets/drop-off-picker.dart';
import 'package:haweyati/src/ui/widgets/image-picker-widget.dart';
import 'package:haweyati/src/ui/widgets/location-picker.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:image_picker/image_picker.dart';

class ScaffoldingTimeAndLocationPage extends StatefulWidget {
  final Order _order;

  ScaffoldingTimeAndLocationPage(this._order) {
    if (_order.location == null) {
      final _appData = AppData.instance();

      _order.location = OrderLocation()
          ..update(_appData.location);
    }
  }

  @override
  _ScaffoldingTimeAndLocationPageState createState() => _ScaffoldingTimeAndLocationPageState();
}

class _ScaffoldingTimeAndLocationPageState extends State<ScaffoldingTimeAndLocationPage> {
  PickedFile _image;
  var _allow = false;
  final _formKey = GlobalKey<SimpleFormState>();

  @override
  Widget build(BuildContext context) {
    return ScrollableView(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
      showBackground: true,
      appBar: HaweyatiAppBar(progress: .5),
      children: [
        HeaderView(
          title: 'Time & Location',
          subtitle: loremIpsum.substring(0, 80),
        ),

        LocationPicker(
          initialValue: widget._order.location,
          onChanged: (location) {}/*_order.location.update*/
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 20, bottom: 40
          ),
          child: DropOffPicker(
            onBuilt: () => setState(() => _allow = true),
            service: ServiceType.buildingMaterials,
            initialDate: widget._order.location.dropOffDate,
            initialTime: widget._order.location.dropOffTime,
            onDateChanged: (date) => widget._order.location.dropOffDate = date,
            onTimeChanged: (time) => widget._order.location.dropOffTime = time
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: ImagePickerWidget(
            initialImage: _image,
            onImagePicked: (image) => _image = image
          ),
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
              hintText: 'Write note here..',
              floatingLabelBehavior: FloatingLabelBehavior.always
            ),
            maxLines: 4,
            maxLength: 80,

            onSaved: (text) => widget._order.note = text,
          )
        )
      ],

      bottom: RaisedActionButton(
        label: 'Continue',
        onPressed: _allow ? () async {
          await _formKey.currentState.submit();
          if (_image != null) {
            widget._order.images = [OrderImage(sort: 'loc', name: _image.path)];
          } else {
            widget._order.images = [];
          }
          print(widget._order.images);
          navigateTo(context, ScaffoldingOrderConfirmationPage(widget._order));
        } : null
      )
    );
  }
}

