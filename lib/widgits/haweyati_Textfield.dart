import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HaweyatiTextField extends StatelessWidget {
  final bool dense;
  final String label;
  final IconData icon;
  final Function(String) onSaved;
  final Function(String) validator;
  final TextInputType keyboardType;
  final TextEditingController controller;

  HaweyatiTextField({
    this.label, this.icon, this.onSaved,
    this.dense = false, this.validator,
    this.keyboardType, this.controller
  });
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(context).nextFocus();
      },
      scrollPadding: EdgeInsets.all(180),
      decoration: InputDecoration(
        labelText: label,
      ),
      onSaved: onSaved,
      validator: validator,
      controller: controller,
    );
  }
}

class HaweyatiPasswordField extends StatefulWidget {
  final IconData icon;
  final String label;
  final TextInputType keyboardType;
  final BuildContext context;
  final TextEditingController controller;
  final Function(String) validator;
  final Function(String) onSaved;

  HaweyatiPasswordField({
    this.icon,
    this.label,
    this.keyboardType,
    this.context,
    this.onSaved,
    this.controller,
    this.validator,
  });

  @override
  _HaweyatiPasswordFieldState createState() => _HaweyatiPasswordFieldState();
}

class _HaweyatiPasswordFieldState extends State<HaweyatiPasswordField> {
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _show,
      keyboardType: widget.keyboardType,
      textInputAction: TextInputAction.next,
      scrollPadding: EdgeInsets.all(180),
      decoration: InputDecoration(
        labelText: widget.label,
        focusColor: Theme.of(context).primaryColor,
        suffix: GestureDetector(
          child: Text('Show', style: TextStyle(color: Theme.of(context).primaryColor)),
          onTap: () => setState(() => _show = !_show),
        )
      ),
      onSaved: widget.onSaved,
      validator: widget.validator,
      controller: widget.controller,
    );
  }
}
