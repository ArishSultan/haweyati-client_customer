import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haweyati/models/hive-models/customer/customer-model.dart';
import 'package:haweyati/src/models/location_model.dart';
import 'package:haweyati/models/order-time_and_location.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/loading-dialog.dart';
import 'package:haweyati/src/utlis/show-snackbar.dart';
import 'package:haweyati/src/utlis/validators.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/haweyati_Textfield.dart';
import 'package:haweyati/widgits/order-location-picker.dart';
import 'package:haweyati/widgits/profile-image-picker.dart';
import 'package:haweyati/widgits/stackButton.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  String imagePath;
  // HiveLocation location = HaweyatiData.customer.location;
  // var name = TextEditingController.fromValue(TextEditingValue(text: HaweyatiData.customer.profile.name));
//  var email = TextEditingController.fromValue(TextEditingValue(text: HaweyatiData.customer.profile.email));
  final key = GlobalKey<ScaffoldState>();
  final form = GlobalKey<FormState>();
  bool autoValidate=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: HaweyatiAppBar(showHome: false,showCart: false,),
      body: SingleChildScrollView(

      padding: EdgeInsets.all(20),
      child: Form(
        autovalidate: autoValidate,
        key: form,
        child: Column(children: <Widget>[
          ProfileImagePicker(
            // previousImage: HaweyatiData.customer?.profile?.image?.name,
            onImagePicked: (String val){
              setState(() {
                imagePath = val;
              });
            },
          ),
        HaweyatiTextField(
          // controller: name,
          validator: (value) => emptyValidator(value, 'Name'),
          label: 'Name',
        ),
          SizedBox(height: 15,),
//          HaweyatiTextField(
//            controller: email,
//            validator: (value) => emailValidator(value),
//            label: 'Email',
//            keyboardType: TextInputType.emailAddress,
//          ),
          OrderLocationPicker(
            previousLocation: OrderLocation(
              city: '',
              // cords: LatLng(location.latitude,location.longitude),
              // address: location.address
            ),
            onLocationChanged: (OrderLocation loc){
              setState(() {
                // location = HiveLocation(
                //   latitude: loc.cords.latitude,
                //   longitude: loc.cords.longitude,
                //   address: loc.address
                // );
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: StackButton(buttonName: "Save",onTap: () async{

              if(form.currentState.validate()){
                FocusScope.of(context).requestFocus(FocusNode());
                FocusScope.of(context).requestFocus(FocusNode());
                openLoadingDialog(context, 'Updating profile...');
//                 FormData profile = FormData.fromMap({
//                   '_id' : HaweyatiData.customer.id,
//                   'personId' : HaweyatiData.customer.profile.id,
//                   'image' : imagePath!=null ? await MultipartFile.fromFile(imagePath,) : null,
//                   'name' : name.text,
// //                  'email' : email.text,
//                   'latitude' : location.latitude,
//                   'longitude' : location.longitude,
//                   'address' : location.address
//                 });
//                 var res = await HaweyatiService.patch('customers', profile);
                // try{
                //   await HaweyatiData.signIn(Customer.fromJson(res.data));
                //   Navigator.pop(context);
                //   Navigator.pop(context);
                //   print(res.data);
                // } catch (e){
                //   Navigator.pop(context);
                //   key.currentState.hideCurrentSnackBar();
                //   showSnackbar(key, res.toString(),true);
                // }

              } else {
                setState(() {
                  autoValidate=true;
                });
              }



            },),
          )
    ],),
      ),),);
  }
}
