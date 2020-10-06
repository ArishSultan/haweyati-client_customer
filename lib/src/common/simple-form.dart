import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';

class SimpleForm extends StatefulWidget {
  final Widget child;
  final bool autoValidate;
  final Function onSubmit;
  final Function afterSubmit;
  final Widget waitingDialog;
  final Function(dynamic) onError;

  SimpleForm({
    @required Key key,
    @required this.onSubmit,
    this.child,
    this.onError,
    this.afterSubmit,
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
  Future<void> submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
        final data = widget.onSubmit();

        if (data is Future) {
          showDialog(
            context: context,
            builder: (context) => widget.waitingDialog ?? WaitingDialog()
          );
          try {
            await data;
            Navigator.of(context).pop();
          } catch (err) {
            Navigator.of(context).pop();

            if (widget.onError != null) {
              widget.onError(err);
              return;
            }
          }
        }

        if (widget.afterSubmit != null) widget.afterSubmit();
    } else {
      if (!this._validate) setState(() => this._validate = true);
    }
  }
}
