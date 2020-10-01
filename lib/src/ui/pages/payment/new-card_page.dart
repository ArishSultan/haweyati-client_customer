import 'package:flutter/material.dart';
import 'package:haweyati/src/common/simple-form.dart';
import 'package:haweyati/src/models/credit-card_model.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/ui/widgets/text-fields/date-picker-field.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';
import 'package:haweyati/src/const.dart';

class NewCardPage extends StatefulWidget {
  @override
  _NewCardPageState createState() => _NewCardPageState();
}

class _NewCardPageState extends State<NewCardPage> {
  final _card = CreditCard();
  final _key = GlobalKey<SimpleFormState>();

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      body: DottedBackgroundView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15
        ),
        child: SingleChildScrollView(
          child: SimpleForm(
            key: _key,
            onSubmit: () {},
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
                onSaved: (val) => _card.ownerName = val,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 25, bottom: 10
                ),
                child: HaweyatiTextField(
                  label: 'Card Number',
                  maxLength: 16,
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
                      onChanged: (date) => _card.expiresAt = date
                    )
                  )
                ),
                SizedBox(width: 15),
                Expanded(
                  child: HaweyatiTextField(
                    label: 'Security Code',
                    onSaved: (val) => _card.ownerName = val,
                  ),
                ),
              ])
            ])
          ),
        ),
      ),

      bottom: FlatActionButton(
        /// TODO: Change this icon.
        icon: Icon(Icons.lock_outline),
        label: 'Pay \$123123.00 SAR',
        onPressed: () {
        }
      ),
    );
  }
}
