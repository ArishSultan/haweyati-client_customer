import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/dialogs/waiting_dialog.dart';

class SimpleForm extends StatefulWidget {
  final bool autoValidate;
  final Function onSubmit;
  final Widget child;
  final Widget waitingDialog;

  SimpleForm({
    @required Key key,
    @required this.onSubmit,
    this.child,
    this.autoValidate,
    this.waitingDialog
  }): super(key: key);

  @override
  SimpleFormState createState() => SimpleFormState();
}

class SimpleFormState extends State<SimpleForm> {
  bool _validate = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _validate,
      child: widget.child
    );
  }

  void reset() => _formKey.currentState.reset();
  void submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final data = widget.onSubmit();

      if (data is Future) {
        showDialog(
          context: context,
          builder: (context) => widget.waitingDialog ?? WaitingDialog()
        );
        await data;
        Navigator.of(context).pop();
      }
    } else {
      if (!this._validate) setState(() => this._validate = true);
    }
  }
}
