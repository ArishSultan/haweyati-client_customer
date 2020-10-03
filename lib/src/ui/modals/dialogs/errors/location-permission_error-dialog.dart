import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/ui/modals/dialogs/base-alert-dialog.dart';
import 'package:haweyati/src/ui/views/localized_view.dart';

class LocationPermissionErrorDialog extends LocalizedView {
  LocationPermissionErrorDialog({Function onPressed}): super(
    builder: (context, lang) => BaseAlertDialog(
      title: Text(lang.useLocation),
      content: Wrap(children: [
        Text(lang.useLocationMessage1, style: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade700
        )),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(children: [
            Image.asset(LocationIcon, width: 20),
            SizedBox(width: 15),
            Expanded(
              child: Text(lang.useLocationMessage2, style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700
              )),
            )
          ]),
        )
      ]),

      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(lang.no)
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(lang.yes)
        )
      ],
    ),
  );
}
