import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/widgets/simple-form.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/flat-action-button.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';

class CeilingCalculationPage extends StatelessWidget {
  String _width;
  String _height;
  String _length;

  final _key = GlobalKey<SimpleFormState>();

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      body: DottedBackgroundView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15, vertical: 20
        ),
        child: SimpleForm(
          key: _key,
          onSubmit: () {},
          child: Column(children: [
            TextFormField(
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Length',
              ),
              onSaved: (val) => _length = val,
              keyboardType: TextInputType.number,
              validator: (value) => value.isEmpty ? "Please Enter Length" : null,
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Width',
              ),
              onSaved: (val) => _width = val,
              keyboardType: TextInputType.number,
              validator: (value) => value.isEmpty ? "Please Enter Length" : null,
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Height'
              ),
              onSaved: (val) => _height = val,
              keyboardType: TextInputType.number,
              validator: (value) => value.isEmpty ? "Please Enter Length" : null,
            )
          ]),
        ),
      ),

      bottom: FlatActionButton(
        label: 'Continue',
        onPressed: () {
          _key.currentState.submit();
        }
      ),
    );
  }
}
