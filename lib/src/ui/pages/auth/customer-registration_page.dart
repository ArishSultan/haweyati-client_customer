// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:haweyati/services/haweyati-service.dart';
// import 'package:haweyati/src/ui/widgets/app-bar.dart';
// import 'package:haweyati/src/ui/widgets/waiting-dialog.dart';
// import 'package:haweyati/src/utlis/show-snackbar.dart';
// import 'package:haweyati/src/utlis/validators.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CustomerRegistration extends StatefulWidget {
//   final String contact;
//   final bool fromOrderPage;
//   CustomerRegistration({this.fromOrderPage,this.contact});
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
//   TextEditingController confirmPassword =TextEditingController();
//   SharedPreferences prefs;
//   // UserLocation userLocation;
//   bool autoValidate = false;
//   var scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     super.initState();
//     contact.text = widget.contact;
//     initMap();
//   }
//
//   initMap() async {
//     prefs = await SharedPreferences.getInstance();
//     setState(() {
//       // userLocation = UserLocation(
//       //   city: prefs.getString('city'),
//       //   address: prefs.getString('address'),
//       //   cords: LatLng(
//       //       prefs.getDouble('latitude'), prefs.getDouble('longitude')
//       //   ),
//       // );
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: HaweyatiAppBar(hideCart:true,hideHome: true,),
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
// //          HaweyatiTextField(controller: email,label: "Email",keyboardType: TextInputType.emailAddress,
// //            validator: (value) => emailValidator(value),
// //          ),
// //          SizedBox(height: 15,),
//           AbsorbPointer(
//             absorbing: true,
//             child: HaweyatiTextField(controller: contact,
//                 label: "Contact",
//                 keyboardType: TextInputType.number),
//           ),
//
//           SizedBox(height: 15,),
//           HaweyatiPasswordField(controller: password,label: "Password",validator:(value)=> passwordValidator(value),),
//             SizedBox(height: 15,),
//             HaweyatiPasswordField(controller: confirmPassword,label: "Confirm Password",
//               validator:(value){
//                 if(value.isEmpty){
//                   return 'Please confirm password';
//                 }
//                 if(password.text != confirmPassword.text){
//                   return "Passwords don't match";
//                 }
//                 return null;
//               },
//             ),
//             EmptyContainer(
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
//                           FocusScope.of(context).requestFocus(FocusNode());
//                           FocusScope.of(context).requestFocus(FocusNode());
//                           OrderLocation location = await  Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => MyLocationMapPage(
//                                 editMode: true,
//                               )));
//                           if(location!=null){
//                             print(location);
//                             setState(() {
//                               // userLocation = UserLocation(
//                               //     cords: location.cords,
//                               //     address: location.address
//                               // );
//                             });
//                           }
//
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
//                     // Expanded(
//                     //   child: Padding(
//                     //     padding: const EdgeInsets.only(left: 10),
//                     //     child: Text(userLocation?.address ?? ''),
//                     //   ),
//                     // )
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
//                   'contact' : widget?.contact,
//                   'scope' : 'customer',
// //                  'email' : email.text,
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
//                       // HaweyatiData.signIn(Customer.fromJson(res.data));
// //                      Navigator.pop(context);
// //                         CustomNavigator.pushReplacement(context, AppHomePage());
//                   } catch (e){
//                     print(e);
//                     Navigator.pop(context);
//                     showSnackbar(scaffoldKey, res.toString(),true);
//                   }
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
