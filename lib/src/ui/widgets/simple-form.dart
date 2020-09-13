import 'dart:async';
import 'package:flutter/material.dart';

class SimpleForm extends StatefulWidget {
  final Widget child;
  final FutureOr Function() onSubmit;

  SimpleForm({
    @required Key key,
    @required this.child,
    @required this.onSubmit
  }): assert(key != null),
      assert(child != null),
      assert(onSubmit != null),
      super(key: key);

  @override
  SimpleFormState createState() => SimpleFormState();
}

class SimpleFormState extends State<SimpleForm> {
  var _validate = false;
  var _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: widget.child,
      autovalidate: _validate
    );
  }

  FutureOr submit() async {
    if (_key.currentState.validate()) {
      try {
        final result = await widget.onSubmit();

        return result;
      } catch (e) {
        // showDialog(
        //   context: context,
        //   builder: (context) => _Form
        // );
      }
    } else if (! _validate) {
      setState(() => _validate = true);
    }

    return null;
  }
}
