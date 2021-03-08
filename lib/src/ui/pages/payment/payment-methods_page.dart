import 'dart:io';
import 'package:flutter/material.dart';
import 'package:haweyati/src/app.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/utils/lazy_task.dart';
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/pages/payment/credit-cards_page.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati_client_data_models/utils/toast_utils.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

import 'PaymentCard.dart';

enum PaymentMethodEnum {
  applePay,
  stripe,
  cashOnDelivery,
  mada
}

class PaymentResponse {
  final String intentId;
  final PaymentMethodEnum _method;
  
  const PaymentResponse(this._method, [this.intentId]);

  String get method {
    switch (_method) {
      case PaymentMethodEnum.applePay:
        return 'ApplePay';
        break;
      case PaymentMethodEnum.stripe:
        return 'Stripe';
        break;
      case PaymentMethodEnum.cashOnDelivery:
        return 'COD';
      case PaymentMethodEnum.mada:
        return 'Mada';
    }

    return null;
  }
}

class PaymentMethodPage extends StatefulWidget {
  final int amount;
  bool canPayOnline;
  PaymentMethodPage({this.amount,this.canPayOnline}){
   this.canPayOnline = amount > 0;
  }

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  var _paymentType = PaymentMethodEnum.cashOnDelivery;

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      appBar: const HaweyatiAppBar(hideHome: true, hideCart: true),
      body: DottedBackgroundView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(child: Column(children: [
          HeaderView(
            title: 'Payment Method',
            subtitle: loremIpsum.substring(0, 70),
          ),

          if (Platform.isIOS)
            _PaymentMethodEnum(
              text: 'Apple Pay',
              selected: _paymentType == PaymentMethodEnum.applePay,
              image: Image.asset(ApplePayIcon, width: 60),
              onTap: () => setState(() => _paymentType = PaymentMethodEnum.applePay),
            ),

         if(widget.canPayOnline) _PaymentMethodEnum(
            text: 'Credit Card',
            selected: _paymentType == PaymentMethodEnum.stripe,
            image: Image.asset(CreditCardsIcon, width: 85),
            onTap: () => setState(() => _paymentType = PaymentMethodEnum.stripe),
          ),

          if(widget.canPayOnline) _PaymentMethodEnum(
            text: 'Mada',
            selected: _paymentType == PaymentMethodEnum.mada,
            image: Image.asset(MadaIcon, width: 85),
            onTap: () => setState(() => _paymentType = PaymentMethodEnum.mada),
          ),
          _PaymentMethodEnum(
            text: 'Cash on Delivery',
            selected: _paymentType == PaymentMethodEnum.cashOnDelivery,
            image: Image.asset(CashIcon, width: 30),
            onTap: () => setState(() => _paymentType = PaymentMethodEnum.cashOnDelivery),
          )
        ])),
      ),

      bottom: FlatActionButton(
        label: 'Done',
        onPressed: _paymentType != null ? _processPayment : null
      )
    );
  }

  _processPayment() async {
    switch (_paymentType) {
      case PaymentMethodEnum.applePay:
        break;
      case PaymentMethodEnum.stripe:
        return navigateTo(context, CreditCardsPage(amount: widget.amount));
      case PaymentMethodEnum.cashOnDelivery:
        return Navigator.of(context).pop(PaymentResponse(PaymentMethodEnum.cashOnDelivery));
      case PaymentMethodEnum.mada:
        handleMyFatoorahPayment();
    }
  }


  Future handleMyFatoorahPayment () async {
    openLoadingDialog(context, "Processing");
    MFSDK.init("https://apitest.myfatoorah.com", "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL");
    var request = MFInitiatePaymentRequest(widget.amount.toDouble(), MFCurrencyISO.SAUDI_ARABIA_SAR);

    MFSDK.initiatePayment(request, MFAPILanguage.EN,
            (MFResult<MFInitiatePaymentResponse> result) async {
          if(result.isSuccess())  {
            Navigator.pop(context);
            int paymentMethodId = await navigateTo(context, AvailablePaymentMethods(methods: result.response.paymentMethods));
            if(paymentMethodId!=null){
              var req = new MFExecutePaymentRequest(paymentMethodId, widget.amount.toDouble());
              MFSDK.executePayment(context, req, MFAPILanguage.EN,
                      (String invoiceId, MFResult<MFPaymentStatusResponse> result) async {
                    if(result.isSuccess() && result.response.invoiceId!=null) {
                      var invoiceId = result.response.invoiceId;
                      showSuccessToast("Payment done successfully");
                      Navigator.pop(context,PaymentResponse(PaymentMethodEnum.mada,invoiceId.toString()));
                    }
                    else {
                      showErrorToast(result.error.message);
                      print(result.error.message);
                    }});
            }
          }
          else {
            Navigator.pop(context);
            print(result.error.message);
            showErrorToast(result.error.message);
          }
        });
  }


}

class _PaymentMethodEnum extends GestureDetector {
  _PaymentMethodEnum({
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