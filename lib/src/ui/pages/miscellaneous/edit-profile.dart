import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/location_model.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/ui/widgets/location-picker.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';
import 'package:haweyati/src/utils/validators.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name = AppData.instance().user.name;
  String imagePath;
  Location location = AppData.instance().location;

  final key = GlobalKey<ScaffoldState>();
  final form = GlobalKey<FormState>();

  bool autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      key: key,
      appBar: HaweyatiAppBar(hideHome: true, hideCart: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          autovalidate: autoValidate,
          key: form,
          child: Column(children: <Widget>[
            // ProfileImagePicker(
            //   previousImage: HaweyatiData.customer?.profile?.image?.name,
            //   onImagePicked: (String val){
            //     setState(() {
            //       imagePath = val;
            //     });
            //   },
            // ),
            HaweyatiTextField(
              value: name,
              validator: (value) => emptyValidator(value, 'Name'),
              label: 'Name',
              onSaved: (value) => name = value,
            ),
            SizedBox(height: 15,),
//          HaweyatiTextField(
//            controller: email,
//            validator: (value) => emailValidator(value),
//            label: 'Email',
//            keyboardType: TextInputType.emailAddress,
//          ),
            LocationPicker(
              initialValue: location,
              onChanged: (location) {
                AppData.instance().location = location;
              },
            ),
          ])
        )
      ),

      bottom: FlatActionButton(
        label: 'Save',
        onPressed: () async {
          if (form.currentState.validate()) {
            form.currentState.save();

            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).requestFocus(FocusNode());

            showDialog(
              context: context,
              builder: (context) => WaitingDialog(message: 'Updating Profile...')
            );

            final user = AppData.instance().user;
            FormData profile = FormData.fromMap({
              '_id' : user.id,
              'personId' : user.profile.id,
              'image': imagePath != null ? await MultipartFile.fromFile(imagePath,) : null,
              'name': name,
              'latitude' : location.latitude,
              'longitude' : location.longitude,
              'address' : location.address
            });

            var res = await HaweyatiService.patch('customers', profile);
            try {
              user.profile.name = name;
              await user.save();

              Navigator.pop(context);
              Navigator.pop(context);
            } catch (e) {
              Navigator.pop(context);
              key.currentState.hideCurrentSnackBar();
              key.currentState.showSnackBar(
                SnackBar(content: Text(res.toString())
              ));
            }
          } else {
            setState(() { autoValidate = true; });
          }
        },
      ),
    );
  }
}
