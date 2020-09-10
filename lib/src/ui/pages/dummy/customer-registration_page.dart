// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:haweyati/models/hive-models/customer/customer-model.dart';
// import 'package:haweyati/models/hive-models/customer/profile_model.dart';
// import 'package:haweyati/models/hive-models/orders/location_model.dart';
// import 'package:haweyati/models/user-location_model.dart';
// import 'package:haweyati/pages/locations-map_page.dart';
// import 'package:haweyati/services/auth-service.dart';
// import 'package:haweyati/services/haweyati-service.dart';
// import 'package:haweyati/src/ui/pages/home_page.dart';
// import 'package:haweyati/src/ui/widgets/app-bar.dart';
// import 'package:haweyati/src/ui/widgets/waiting-dialog.dart';
// import 'package:haweyati/src/utlis/hive-local-data.dart';
// import 'package:haweyati/src/utlis/local-data.dart';
// import 'package:haweyati/src/utlis/show-snackbar.dart';
// import 'package:haweyati/src/utlis/validators.dart';
// import 'package:haweyati/widgits/custom-navigator.dart';
// import 'package:haweyati/widgits/emptyContainer.dart';
// import 'package:haweyati/widgits/haweyati_Textfield.dart';
// import 'package:hive/hive.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CustomerRegistration extends StatefulWidget {
//   final bool fromOrderPage;
//   CustomerRegistration({this.fromOrderPage});
//   @override
//   _CustomerRegistrationState createState() => _CustomerRegistrationState();
// }
//
// class _CustomerRegistrationState extends State<CustomerRegistration> {
//   var formKey = GlobalKey<FormState>();
//   TextEditingController name =TextEditingController();
//   TextEditingController contact =TextEditingController();
//   TextEditingController email =TextEditingController();
//   TextEditingController password =TextEditingController();
//   SharedPreferences prefs;
//   UserLocation userLocation;
//   bool autoValidate = false;
//   var scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     super.initState();
//     initMap();
//   }
//
//   initMap() async {
//     prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userLocation = UserLocation(
//         city: prefs.getString('city'),
//         address: prefs.getString('address'),
//         cords: LatLng(
//             prefs.getDouble('latitude'), prefs.getDouble('longitude')
//         ),
//       );
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: HaweyatiAppBar(context,hideCart:true,hideHome: true,),
//       body: SingleChildScrollView(padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
//         child: Form(
//           key: formKey,
//           autovalidate: autoValidate,
//           child: Column(children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(bottom: 12.0),
//               child: Text("Register",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//             ),
//           HaweyatiTextField(controller: name,label: "Name",
//             validator: (value) => emptyValidator(value, 'name'),
//           ),
//           SizedBox(height: 15,),
//           HaweyatiTextField(controller: email,label: "Email",keyboardType: TextInputType.emailAddress,
//             validator: (value) => emailValidator(value),
//           ),
//           SizedBox(height: 15,),
//           HaweyatiTextField(controller: contact,label: "Contact",keyboardType: TextInputType.number),
//           SizedBox(height: 15,),
//           HaweyatiPasswordField(controller: password,label: "Password",validator:(value)=> passwordValidator(value),),
//           EmptyContainer(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(
//                       "Location",
//                     ),
//                     FlatButton.icon(
//                         onPressed: () async {
//                           UserLocation location = await  Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => MyLocationMapPage(
//                                 editMode: true,
//                               )));
//                           setState(() {
//                             userLocation = location;
//                           });
//                         },
//                         icon: Icon(
//                           Icons.edit,
//                           color: Theme.of(context).accentColor,
//                         ),
//                         label: Text(
//                           "Edit",
//                           style:
//                           TextStyle(color: Theme.of(context).accentColor),
//                         ))
//                   ],
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//
//                 Row(
//                   children: <Widget>[
//                     Icon(
//                       Icons.location_on,
//                       color: Theme.of(context).accentColor,
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 10),
//                         child: Text(prefs?.getString('address') ?? ''),
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           RaisedButton(
//             color: Theme.of(context).accentColor,
//             child: Text('Submit',
//               style: TextStyle(color: Colors.white),),
//             onPressed: () async {
//
//               if(formKey.currentState.validate()){
//                 FocusScope.of(context).requestFocus(FocusNode());
//                 FocusScope.of(context).requestFocus(FocusNode());
//
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//
//                 FormData data = FormData.fromMap({
//                   'name' : name.text,
//                   'contact' : contact.text,
//                   'scope' : 'customer',
//                   'email' : email.text,
//                   'password' : password.text,
//                   'latitude': prefs.getDouble('latitude'),
//                   'longitude': prefs.getDouble('longitude'),
//                   'address': prefs.getString('address'),
//                 });
//
//                 showDialog(
//                     context: context,
//                     builder: (context) => WaitingDialog('Registering, Please wait ...')
//                 );
//
//
//                   var res = await HaweyatiService.post(
//                       'customers', data);
//                   try {
//                       HaweyatiData.signIn(Customer.fromJson(res.data));
//                       Navigator.pop(context);
//                       if(widget.fromOrderPage){
//                         Navigator.pop(context);
//                         Navigator.pop(context);
//                       } else {
//                         CustomNavigator.pushReplacement(context, AppHomePage());
//                       }
//                   } catch (e){
//                     Navigator.pop(context);
//                     showSnackbar(scaffoldKey, res.toString(),true);
//                   }
//
//
//               }
//               else {
//                 setState(() {
//                   autoValidate=true;
//                 });
//               }
//             },
//           )
//       ],),
//         ),),
//     );
//   }
// }
