import 'package:flutter/material.dart';

class SimpleForm extends StatefulWidget {
  final bool autoValidate;
  final Function onSubmit;
  final Widget Function(BuildContext, Function) builder;

  SimpleForm({
    this.builder,
    this.onSubmit,
    this.autoValidate
  });

  @override
  _SimpleFormState createState() => _SimpleFormState();
}

class _SimpleFormState extends State<SimpleForm> {
  bool _validate = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _validate,
      child: widget.builder(context, _onSubmit),
    );
  }

  void _onSubmit() {
    if (this._formKey.currentState.validate()) {
      widget.onSubmit();
    } else {
      if (!this._validate) setState(() => this._validate = true);
    }
  }
}
