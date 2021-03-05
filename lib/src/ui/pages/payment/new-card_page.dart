import 'package:flutter/material.dart';
import 'package:haweyati/src/common/simple-form.dart';
import 'package:haweyati/src/rest/payment-service.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/ui/widgets/text-fields/date-picker-field.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';
import 'package:haweyati/src/const.dart';
import 'package:stripe_payment/stripe_payment.dart';

class NewCardPage extends StatefulWidget {
  final int amount;
  final Function(String) onPaymentIntentId;
  NewCardPage({this.amount,this.onPaymentIntentId});

  @override _NewCardPageState createState() => _NewCardPageState();
}

class _NewCardPageState extends State<NewCardPage> {
  final _card = CreditCard();
  final _key = GlobalKey<SimpleFormState>();

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      appBar: HaweyatiAppBar(hideHome: true, hideCart: true),
      body: DottedBackgroundView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15
        ),
        child: Builder(
           builder: (ctx) => SingleChildScrollView(
            child: SimpleForm(
              key: _key,
              onSubmit: () async {
                StripeTransactionResponse response = await StripeService.payViaExistingCard(
                  card: _card, currency: 'SAR', amount: widget.amount.toString()+'0'
                );

                if (response.success ?? false) {
                  widget.onPaymentIntentId(response.paymentIntentId);
                   Navigator.pop(context);
                  // Navigator.pop(ctx, PaymentResponse(PaymentMethodEnum.creditCard,response.paymentIntentId));
                  // Navigator.pop(context, PaymentResponse(PaymentMethodEnum.creditCard,response.paymentIntentId));
                  // Navigator.pop(context, PaymentResponse(PaymentMethodEnum.creditCard,response.paymentIntentId));
                }
              },
              child: Column(children: [
                HeaderView(
                  title: 'Visa/Master Card',
                  subtitle: loremIpsum.substring(0, 70),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Image.asset(CreditCardsIcon, width: 90),
                ),

                HaweyatiTextField(
                  label: 'Name',
                  value: 'Haroon',
                  onSaved: (val) => _card.name = val,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 25, bottom: 10
                  ),
                  child: HaweyatiTextField(
                    label: 'Card Number',
                    maxLength: 16,
                    value: '4242424242424242',
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _card.number = val,
                  ),
                ),

                Row(children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 10
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade500)
                      ),
                      child: DatePickerField(
                        initialValue: DateTime.now(),
                        onChanged: (date) {
                          _card.expMonth = date.month;
                          _card.expYear = date.year;
                        }
                      )
                    )
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: HaweyatiTextField(
                      label: 'Security Code',
                      value: '123',
                      keyboardType: TextInputType.number,
                      onSaved: (val) => _card.cvc = val,
                    ),
                  ),
                ])
              ])
            ),
          ),
        ),
      ),

      bottom: FlatActionButton(
        icon: Icon(Icons.lock_outline),
        label: 'Pay ${widget.amount} SAR',
        onPressed: () async {
          _key.currentState.submit();
          print(_card.cvc);

        }
      ),
    );
  }
}
