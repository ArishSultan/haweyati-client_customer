import 'confirmation-dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


Future<bool> showConfirmationDialog({
  BuildContext context,
  bool barrierDismissible,
  ConfirmationDialog Function(BuildContext) builder
}) async => (await showDialog(
  context: context,
  builder: builder,
  barrierDismissible: barrierDismissible
)) ?? false;