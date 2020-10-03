import 'package:flutter/material.dart';

class BaseAlertDialog extends AlertDialog {
  BaseAlertDialog({
    Widget title,
    Widget content,
    List<Widget> actions,
  }): super(
    insetPadding: const EdgeInsets.all(15),
    titlePadding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
    actionsPadding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
    contentPadding: const EdgeInsets.all(15),

    title: title,
    content: content,
    actions: actions
  );
}