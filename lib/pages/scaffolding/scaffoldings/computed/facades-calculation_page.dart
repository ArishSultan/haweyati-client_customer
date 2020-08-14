import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/simple-form.dart';
import 'package:haweyati/src/ui/widgets/no-scroll_page.dart';
import 'package:haweyati/widgits/custom-navigator.dart';

import '../../scaffoldinserviceDetail.dart';

class FacadesCalculationPage extends StatelessWidget {
  final _faces = new TextEditingController();
  final _height = new TextEditingController();
  final _length = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleForm(
      autoValidate: false,
      onSubmit: () {
        CustomNavigator.navigateTo(context, ScaffoldingServicesDetail());
      },
      builder: (context, submit) => NoScrollPage(
        appBar: HaweyatiAppBar(context,progress: .4),
        body: Theme(
          data: ThemeData(
            accentColor: Theme.of(context).accentColor,
            primaryColor: Theme.of(context).accentColor
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(children: <Widget>[
              TextFormField(
                controller: _length,
                style: TextStyle(fontFamily: "Lato"),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Length',
                  border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value.isEmpty ? "Please Enter Length" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _faces,
                style: TextStyle(fontFamily: "Lato"),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'No. of Faces',
                  border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value.isEmpty ? "Please Enter Length" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _height,
                style: TextStyle(fontFamily: "Lato"),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Height',
                  border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value.isEmpty ? "Please Enter Length" : null,
              )
            ]),
          ),
        ),
        action: tr('Continue'),
        onAction: submit,
      ),
    );
  }
}
