import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:haweyati/src/ui/widgets/buttons/dialog-action_button.dart';

class LocationPermissionErrorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Location is Turned Off'),
      actions: [
        DialogActionButton(
          label: 'no',
          onPressed: () => Navigator.of(context).pop()
        ),

        DialogActionButton(
          label: 'yes',
          isPrimary: true,
          onPressed: () => LocationPermissions().requestPermissions()
        ),
      ]
    );
  }
}
