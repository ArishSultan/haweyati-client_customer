// import 'package:flutter/material.dart';
// import 'package:haweyati/services/haweyati-service.dart';
// import 'package:haweyati/src/ui/pages/signin_page.dart';
// import 'package:haweyati/src/ui/widgets/loading-dialog.dart';
// import 'package:haweyati/src/utlis/const.dart';
// import 'package:haweyati/src/utlis/hive-local-data.dart';
// import 'package:haweyati/src/utlis/show-snackbar.dart';
// import 'package:haweyati/widgits/appBar.dart';
// import 'package:haweyati/widgits/navigator.dart';
// import 'package:haweyati/widgits/haweyati-appbody.dart';
// import 'package:haweyati/widgits/haweyati_Textfield.dart';
// import 'package:haweyati/widgits/stackButton.dart';
//
// class ResetPasswordPage extends StatefulWidget {
//   final String phoneNumber;
//   ResetPasswordPage({this.phoneNumber});
//   @override
//   _ResetPasswordPageState createState() => _ResetPasswordPageState();
// }
//
// class _ResetPasswordPageState extends State<ResetPasswordPage> {
//
//   bool autoValidate = false;
//   bool loading = false;
//   var _formKey = GlobalKey<FormState>();
//   var key = GlobalKey<ScaffoldState>();
//
//   TextEditingController newPass = new TextEditingController();
//   TextEditingController confirmPass = new TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       key: key,
//       appBar: HaweyatiAppBar(),
//       body: HaweyatiAppBody(
//         title: "Reset Password",
//         detail: loremIpsum.substring(0, 80),
//         btnName: "Done",
//         onTap: () {
//           Navigator.of(context).pop();
//         },
//         child: Form(key: _formKey,autovalidate: autoValidate, child: SingleChildScrollView(padding: EdgeInsets.fromLTRB(20, 40, 20, 0), child: Column(
//           children: <Widget>[
//
//             HaweyatiPasswordField(
//               label: "New Password",
//               controller :newPass,
//               validator: (value) {
//                 if(value.length<8)
//                   return 'Password must be at least 8 characters';
//                 return value.isEmpty ? "Please Enter New Password" : null;
//               },
//               context: context,
//             ),
//
//             SizedBox(height: 15,),
//             HaweyatiPasswordField(
//               label: "Confirm Password",
//               controller:confirmPass,
//               validator: (value) {
//                 if(value.isEmpty){
//                   return 'Please Enter Confirm Password';
//                 }
//                 if(newPass.text!=confirmPass.text){
//                   return 'New and Confirm Passwords not matched';
//                 }
//                 return null;
//               },
//               context: context,
//             ),
//             SizedBox(height: 15,),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 70),
//               child: StackButton(buttonName: "Reset",onTap: () async {
//
//                 if(_formKey.currentState.validate()){
//                   FocusScope.of(context).requestFocus(FocusNode());
//                   FocusScope.of(context).requestFocus(FocusNode());
//                   openLoadingDialog(context, 'Resetting your password...');
//                   var change = {
//                     'contact' : widget.phoneNumber,
//                     'password' : newPass.text,
//                   };
//                   var res = await HaweyatiService.post('persons/contact/change-password', change);
//                   try{
//                     Navigator.pop(context);
//                     showSnackbar(key, "Your password has been changed successfully!");
//                     Future.delayed(Duration(seconds: 2),() async {
//                       CustomNavigator.navigateTo(context, SignInPage());
//                     });
//                   } catch (e){
//                     Navigator.pop(context);
//                     key.currentState.hideCurrentSnackBar();
//                     showSnackbar(key, res.toString(),true);
//                   }
//
//                 } else {
//                   setState(() {
//                     autoValidate=true;
//                   });
//                 }
//
//
//               },),
//             )
//           ],
//
//         ),)),
//
//       ),
//     );
//   }
// }
