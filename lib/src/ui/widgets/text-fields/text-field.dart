import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/l10n/app_localizations.dart';

class HaweyatiTextField extends StatelessWidget {
  final bool dense;
  final String label;
  final IconData icon;
  final int maxLength;
  final EdgeInsets scrollPadding;
  final Function(String) onSaved;
  final Function(String) validator;
  final TextInputType keyboardType;
  final TextEditingController controller;

  HaweyatiTextField({
    this.maxLength,
    this.scrollPadding = const EdgeInsets.all(100),
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
      scrollPadding: EdgeInsets.all(100),
      decoration: InputDecoration(
        labelText: label,
      ),
      maxLength: maxLength,
      onSaved: onSaved,
      validator: validator,
      controller: controller,
    );
  }
}

class HaweyatiPasswordField extends StatefulWidget {
  final IconData icon;
  final String label;
  final BuildContext context;
  final TextInputType keyboardType;
  final EdgeInsets scrollPadding;
  final TextEditingController controller;
  final Function(String) validator;
  final Function(String) onSaved;

  HaweyatiPasswordField({
    this.icon,
    this.label,
    this.scrollPadding = const EdgeInsets.all(100),
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
  final _node = FocusNode();

  @override
  void initState() {
    super.initState();
    _node.addListener(_listenToFocus);
  }

  _listenToFocus() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _node,
      obscureText: _show,
      keyboardType: widget.keyboardType,
      textInputAction: TextInputAction.next,
      scrollPadding: widget.scrollPadding,
      decoration: InputDecoration(
        labelText: widget.label,
        focusColor: Theme.of(context).primaryColor,
        suffix: GestureDetector(
          child: Text(_show
            ? AppLocalizations.of(context).show
            : AppLocalizations.of(context).hide,
            style: TextStyle(
              height: 1,
              color: _node.hasFocus
                ? Theme.of(context).primaryColor
                : Colors.grey
          )),
          onTap: () => setState(() => _show = !_show),
        )
      ),
      onSaved: widget.onSaved,
      validator: widget.validator,
      controller: widget.controller,
    );
  }

  @override
  void dispose() {
    _node.removeListener(_listenToFocus);
    super.dispose();
  }
}
