import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/pages/payment/credit-cards_page.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/utils/const.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

enum PaymentMethod {
  applePay,
  creditCard,
  cashOnDelivery
}

class PaymentResponse {
  final String intentId;
  final PaymentMethod method;
  
  PaymentResponse({
    this.method,
    this.intentId
  });
}

class PaymentMethodsPage extends StatefulWidget {
  @override
  _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  var _paymentType = PaymentMethod.cashOnDelivery;

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      body: DottedBackgroundView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(child: Column(children: [
          HeaderView(
            title: 'Payment Method',
            subtitle: loremIpsum.substring(0, 70),
          ),

          if (Platform.isIOS)
            _PaymentMethod(
              text: 'Apple Pay',
              selected: _paymentType == PaymentMethod.applePay,
              image: Image.asset(ApplePayIcon, width: 60),
              onTap: () => setState(() => _paymentType = PaymentMethod.applePay),
            ),

          _PaymentMethod(
            text: 'Credit Card',
            selected: _paymentType == PaymentMethod.creditCard,
            image: Image.asset(CreditCardsIcon, width: 85),
            onTap: () => setState(() => _paymentType = PaymentMethod.creditCard),
          ),
          _PaymentMethod(
            text: 'Cash on Delivery',
            selected: _paymentType == PaymentMethod.cashOnDelivery,
            image: Image.asset(CashIcon, width: 30),
            onTap: () => setState(() => _paymentType = PaymentMethod.cashOnDelivery),
          )
        ])),
      ),

      bottom: FlatActionButton(
        label: 'Done',
        onPressed: _paymentType != null ? _processPayment : null
      )
    );
  }

  _processPayment() {
    print(_paymentType);
    switch (_paymentType) {
      case PaymentMethod.applePay:
        break;
      case PaymentMethod.creditCard:
        navigateTo(context, CreditCardsPage());
        break;
      case PaymentMethod.cashOnDelivery:
        return Navigator.of(context).pop(PaymentResponse(
          method: PaymentMethod.cashOnDelivery
        ));
    }
  }
}


// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:haweyati/models/hive-models/customer/customer-model.dart';
// import 'package:haweyati/models/hive-models/orders/transaction_model.dart';
// import 'package:haweyati/pages/payments-home.dart';
// import 'package:haweyati/services/auth-service.dart';
// import 'package:haweyati/services/payment-service.dart';
// import 'package:haweyati/src/ui/widgets/loading-dialog.dart';
// import 'package:haweyati/src/utils/custom-navigator.dart';
//
// class PaymentMethodsPage extends StatefulWidget {
//   final Transaction transaction;
//   PaymentMethodsPage({this.transaction});
//   @override
//   _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
// }
//
// class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
//   int _selectedIndex = -1;
//   bool blocked = false;
//   Transaction transaction;
//
//   Future<bool> checkBlockedStatus() async {
//     openLoadingDialog(context, 'Please wait...');
//     Customer cus = await AuthService().getCustomer(''/*HaweyatiData.customer.profile.contact*/);
//     if(cus.status=='Blocked') {
//       print('customer is blocked');
//       Navigator.pop(context);
//       await openBlockedDialog(context, "Reason: ${cus.message}");
//       return true;
//     }
//     return false;
//   }
//
//
//
//
//   void func() async {
//     switch(_selectedIndex){
//       case 0:
//         // Mada
//         break;
//       case 1:
//         // Apple
//         break;
//       case 2:
//         bool isBlocked = await checkBlockedStatus();
//        if(!isBlocked){
//          Navigator.pop(context);
//          StripeTransactionResponse response = await CustomNavigator.navigateTo(context, StripePaymentPage(transaction: widget.transaction,));
//          if(response!=null && response.success){
//            Navigator.pop(context,PaymentResponse(
//                PaymentMethod: 'card',
//                paymentIntentId: response.paymentIntentId
//            ));
//          }
//          print(response);
//        }
//         // Credit Card
//         break;
//       case 3:
//       // Cash On Delivery
//         bool isBlocked = await checkBlockedStatus();
//         if(!isBlocked){
//           Navigator.pop(context);
//           Navigator.pop(context,PaymentResponse(
//             PaymentMethod: 'COD',
//           ));
//         }
//         break;
//     }
//   }
//
//   bool selected = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: HaweyatiAppBar(context: context,),
//       body: HaweyatiAppBody(
//         onTap: () async {
//           func();
// //         var paymentData = await CustomNavigator.navigateTo(context, StripePaymentPage());
// //         print(paymentData);
// //         if(paymentData.success == true){
// //           Navigator.pop(context,paymentData);
// //           print('Payment Successful');
// //         }
// //         else {
// //           print('Payment not done');
// //         }
//         },
//         showButton: true,
//         btnName: "Done",
//         title: "Payment Method",
//         detail:
//         loremIpsum.substring(0,40),
//         child: ListView(
//           padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
//           children: <Widget>[
//             // _buildPaymentContainer(
//             //     imgPath: "assets/images/mada.png", onTap: () => setState(() => _selectedIndex = 0), text: "Mada", index: 0),
//           Platform.isIOS ?  _buildPaymentContainer(
//                 imgPath: "assets/images/apple-pay.png", onTap: () => setState(() => _selectedIndex = 1), text: "Apple", index: 1)
//             : SizedBox() ,
//             _buildPaymentContainer(
//                 imgPath: "assets/images/credit-card.png", onTap: () => setState(() => _selectedIndex = 2), text: "Credit Card ", index: 2),
//             _buildPaymentContainer(
//                 imgPath: "assets/images/cash-on-delivery.png", onTap: () => setState(() => _selectedIndex = 3), text: "Cash on Delivery", index: 3)
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPaymentContainer({Function onTap, String text,String imgPath, int index}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 20),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(color: _selectedIndex == index ? Theme.of(context).accentColor: Colors.grey, width: _selectedIndex == index ? 2: 1),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   text,
//                   style: boldText,
//                 ),
//                 Container(
//                   height: 50,
//                   width: 50,
//                   child: Image.asset(imgPath),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// class PaymentResponse {
//   String PaymentMethod;
//   String paymentIntentId;
//   PaymentResponse({this.paymentIntentId,this.PaymentMethod});
// }

class _PaymentMethod extends GestureDetector {
  _PaymentMethod({
    String text,
    Widget image,
    bool selected,
    Function onTap
  }): super(
    onTap: onTap,
    child: Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(
        horizontal: selected ? 14 : 15
      ),
      decoration: BoxDecoration(
        color: selected ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: selected ? 2 : 1,
          color: selected ? Color(0xFFFF974D) : Colors.grey.shade300
        )
      ),
      child: Row(children: [
        Text(text, style: TextStyle(
          fontSize: 15,
          fontFamily: 'Lato',
          color: Color(0xFF313F53),
          fontWeight: FontWeight.bold
        )),
        Spacer(),
        image,
      ])
    )
  );
}