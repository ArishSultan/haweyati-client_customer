import 'package:flutter/material.dart';
import 'package:haweyati/models/hive-models/orders/transaction_model.dart';
import 'package:haweyati/services/payment-service.dart';
import 'package:haweyati/src/ui/widgets/loading-dialog.dart';
import 'package:hive/hive.dart';

class StripePaymentPage extends StatefulWidget {
  final Transaction transaction;
  StripePaymentPage({this.transaction});

  @override
  StripePaymentPageState createState() => StripePaymentPageState();
}

class StripePaymentPageState extends State<StripePaymentPage> {

  onItemPress(BuildContext context, int index) async {
    switch(index) {
      case 0:
        payViaNewCard(context);
        break;
      case 1:
        Navigator.pushNamed(context, '/existing-cards');
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    openLoadingDialog(context, 'Please wait');
    var response = await StripeService.payWithNewCard(
        amount: widget.transaction?.paymentAmount !=null ? widget.transaction.paymentAmount?.toInt().toString() : '200',
        currency: 'USD'
    );
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: response.success == true ? 1200 : 3000),
        )
    );
    print(response.message);
    Navigator.pop(context,response);
    Navigator.pop(context,response);
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Icon icon;
              Text text;

              switch(index) {
                case 0:
                  icon = Icon(Icons.add_circle, color: theme.primaryColor);
                  text = Text('Pay via new card');
                  break;
                // case 1:
                //   icon = Icon(Icons.credit_card, color: theme.primaryColor);
                //   text = Text('Pay via existing card');
                //   break;
              }

              return InkWell(
                onTap: () {
                  onItemPress(context, index);
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: theme.primaryColor,
            ),
            itemCount: 2
        ),
      ),
    );
  }
}