import 'dart:io';
import 'package:flutter/material.dart';
import 'package:haweyati/src/app.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/pages/payment/credit-cards_page.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';

enum PaymentMethodEnum {
  applePay,
  creditCard,
  cashOnDelivery
}

class PaymentResponse {
  final String intentId;
  final PaymentMethodEnum _method;
  
  const PaymentResponse(this._method, [this.intentId]);

  String get method {
    switch (_method) {
      case PaymentMethodEnum.applePay:
        return 'A';
        break;
      case PaymentMethodEnum.creditCard:
        return 'C';
        break;
      case PaymentMethodEnum.cashOnDelivery:
        return 'COD';
    }

    return null;
  }
}

class PaymentMethodPage extends StatefulWidget {
  final int amount;
  PaymentMethodPage({this.amount});

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

          _PaymentMethodEnum(
            text: 'Credit Card',
            selected: _paymentType == PaymentMethodEnum.creditCard,
            image: Image.asset(CreditCardsIcon, width: 85),
            onTap: () => setState(() => _paymentType = PaymentMethodEnum.creditCard),
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
      case PaymentMethodEnum.creditCard:
        final data = await navigateTo(context, CreditCardsPage(amount: widget.amount));
        print('on payment method page');
        print(data);
        if (data != null) Navigator.of(context).pop(data);
        break;
      case PaymentMethodEnum.cashOnDelivery:
        return Navigator.of(context).pop(PaymentResponse(PaymentMethodEnum.cashOnDelivery));
    }
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