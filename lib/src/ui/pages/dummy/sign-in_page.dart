import 'package:flutter/material.dart';
import 'package:haweyati/models/hive-models/customer/customer-model.dart';
import 'package:haweyati/services/auth-service.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/ui/pages/customer-registration_page.dart';
import 'package:haweyati/src/ui/pages/home_page.dart';
import 'package:haweyati/src/ui/widgets/waiting-dialog.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/widgits/haweyati_Textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  final bool fromOrderPage;
  SignInPage({this.fromOrderPage});
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool loading = false;
  bool autoValidate = false;
  var _formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: HaweyatiAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        foregroundColor: Colors.white,
        child: Icon(Icons.arrow_forward),
        onPressed: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          FocusScope.of(context).requestFocus(FocusNode());
          if (_formKey.currentState.validate()) {
            showDialog(
              context: context,
              builder: (context) => WaitingDialog('Signing In, Please wait ...')
            );
            var token;
            try{
            var user = await HaweyatiService.post('auth/sign-in', {"username" : email.text , "password" : password.text});
            token = user.data['access_token'];}
            catch(e){
              Navigator.pop(context);
              scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Incorrect username or password"),
              ));
              return;
            }

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('bearer', token);

            Customer profile = await AuthService().getProfile();
            print(profile);
            var contact = profile.profile.contact;
            Customer customer = await AuthService().getCustomer(contact);


            if(!customer.profile.scope.contains('customer')){
              prefs.setString('bearer', null);
              Navigator.pop(context);
              scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("${customer.profile.name} is registered as a ${customer.profile.scope[0]} .Please use supplier/driver app"),
              ));
              return;
            }


            // await HaweyatiData.signIn(customer);
            Navigator.pop(context);
            if(widget.fromOrderPage){
              Navigator.pop(context);
            } else {
              // CustomNavigator.pushReplacement(context, AppHomePage());
            }

          } else {
            setState(() => autoValidate = true);
          }
        },
      ),

      bottomNavigationBar: Container(
        height: 50,
        child: Align(
          alignment: Alignment(0, -1),
          child: GestureDetector(
            onTap: () {
              CustomNavigator.navigateTo(context, CustomerRegistration());
//              CustomNavigator.navigateTo(context, VerificationPhoneNumber(phoneNumber: '+923012144088',));
            },
            child: Text("REGISTER NOW", style: TextStyle(
              color: Theme.of(context).accentColor
            )),
          ),
        ),
      ),

      body: Form(
        autovalidate: autoValidate,
        key: _formKey,
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),

                Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                SizedBox(height: 10),

                Text("Please Enter Credentials", style: TextStyle(color: Colors.black54)),
                SizedBox(height: 40),

                HaweyatiTextField(
                  keyboardType: TextInputType.emailAddress,
                  label: "Email or Phone Number",
                  controller: email,
                  validator: (value) {
                    return value.isEmpty ? "Please Enter Email" : null;
                  },
                  // context: context,
                ),

                SizedBox(height: 30),

                HaweyatiPasswordField(
                  label: "Password",
                  controller: password,
                  validator: (value) {
                    return value.isEmpty ? "Please Enter Password" : null;
                  },
                  context: context,
                ),

                SizedBox(height: 15),

                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(

                    onTap: () {
//                      CustomNavigator.navigateTo(context,PhoneNumber());
                    },
                    child: Text("Forgot password?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).accentColor,
                      )
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
