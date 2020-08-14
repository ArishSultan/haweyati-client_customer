import 'package:flutter/material.dart';
import 'package:haweyati/models/hive-models/customer/customer-model.dart';
import 'package:haweyati/models/hive-models/orders/transaction_model.dart';
import 'package:haweyati/services/auth-service.dart';
import 'package:haweyati/services/payment-service.dart';
import 'package:haweyati/src/ui/widgets/loading-dialog.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/src/utlis/hive-local-data.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/custom-navigator.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';
import 'package:haweyati/widgits/message-dialog.dart';
import 'package:hive/hive.dart';
import '../payments-home.dart';

class SelectPaymentMethod extends StatefulWidget {
  final Transaction transaction;
  SelectPaymentMethod({this.transaction});
  @override
  _SelectPaymentMethodState createState() => _SelectPaymentMethodState();
}

class _SelectPaymentMethodState extends State<SelectPaymentMethod> {
  int _selectedIndex = -1;
  bool blocked = false;
  Transaction transaction;

  Future<bool> checkBlockedStatus() async {
    openLoadingDialog(context, 'Please wait...');
    Customer cus = await AuthService().getCustomer(HaweyatiData.customer.profile.contact);
    if(cus.status=='Blocked') {
      print('customer is blocked');
      Navigator.pop(context);
      await openBlockedDialog(context, "Reason: ${cus.message}");
      return true;
    }
    return false;
  }




  void func() async {
    switch(_selectedIndex){
      case 0:
        // Mada
        break;
      case 1:
        // Apple
        break;
      case 2:
        bool isBlocked = await checkBlockedStatus();
       if(!isBlocked){
         Navigator.pop(context);
         StripeTransactionResponse response = await CustomNavigator.navigateTo(context, StripePaymentPage(transaction: widget.transaction,));
         if(response!=null && response.success){
           Navigator.pop(context,PaymentResponse(
               paymentType: 'card',
               paymentIntentId: response.paymentIntentId
           ));
         }
         print(response);
       }
        // Credit Card
        break;
      case 3:
      // Cash On Delivery
        bool isBlocked = await checkBlockedStatus();
        if(!isBlocked){
          Navigator.pop(context);
          Navigator.pop(context,PaymentResponse(
            paymentType: 'COD',
          ));
        }
        break;
    }
  }

  bool selected = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(context: context,),
      body: HaweyatiAppBody(
        onTap: () async {
          func();
//         var paymentData = await CustomNavigator.navigateTo(context, StripePaymentPage());
//         print(paymentData);
//         if(paymentData.success == true){
//           Navigator.pop(context,paymentData);
//           print('Payment Successful');
//         }
//         else {
//           print('Payment not done');
//         }
        },
        showButton: true,
        btnName: "Done",
        title: "Payment Method",
        detail:
        loremIpsum.substring(0,40),
        child: ListView(
          padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
          children: <Widget>[
            _buildPaymentContainer(
                imgPath: "assets/images/mada.png", onTap: () => setState(() => _selectedIndex = 0), text: "Mada", index: 0),
            _buildPaymentContainer(
                imgPath: "assets/images/apple-pay.png", onTap: () => setState(() => _selectedIndex = 1), text: "Apple", index: 1),
            _buildPaymentContainer(
                imgPath: "assets/images/credit-card.png", onTap: () => setState(() => _selectedIndex = 2), text: "Credit Card ", index: 2),
            _buildPaymentContainer(
                imgPath: "assets/images/cash-on-delivery.png", onTap: () => setState(() => _selectedIndex = 3), text: "Cash on Delivery", index: 3)
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentContainer({Function onTap, String text,String imgPath, int index}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: _selectedIndex == index ? Theme.of(context).accentColor: Colors.grey, width: _selectedIndex == index ? 2: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  text,
                  style: boldText,
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: Image.asset(imgPath),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class PaymentResponse {
  String paymentType;
  String paymentIntentId;
  PaymentResponse({this.paymentIntentId,this.paymentType});
}