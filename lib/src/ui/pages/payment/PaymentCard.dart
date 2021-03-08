import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/views/localized_view.dart';
import 'package:myfatoorah_flutter/model/initpayment/SDKInitiatePaymentResponse.dart';

class AvailablePaymentMethods extends StatefulWidget {
  final List<PaymentMethods> methods;
  AvailablePaymentMethods({this.methods});
  @override
  _AvailablePaymentMethodsState createState() => _AvailablePaymentMethodsState();
}

class _AvailablePaymentMethodsState extends State<AvailablePaymentMethods> {
  int selectedPaymentMethodId;

  @override
  void initState() {
    super.initState();
    selectedPaymentMethodId = widget.methods.first.paymentMethodId;
  }
  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder:(context,lang)=> Scaffold(
        appBar: AppBar(
          title: Text("Select Payment Method",style: TextStyle(color: Colors.white),),
        ),
        backgroundColor: Colors.grey[300],
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(height: 40),
              child: FlatButton(
                onPressed: (){
                  Navigator.pop(context,selectedPaymentMethodId);
                },
                shape: StadiumBorder(),
                textColor: Colors.white,
                disabledTextColor: Colors.white,
                disabledColor: Color(0x7FFF974D),
                color: Theme.of(context).primaryColor,
                child: Text("Proceed"),
              ),
            )
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.methods.length,
              itemBuilder: (context, index) {
                PaymentMethods method = widget.methods[index];
                return PaymentMethodEnum(
                  method: method,
                  onTap: (){
                    setState(() {
                      selectedPaymentMethodId = method.paymentMethodId;
                    });
                  },
                  selected: selectedPaymentMethodId == method.paymentMethodId,
                );
              }),
        ),
      ),
    );
  }

}

class PaymentMethodEnum extends GestureDetector {
  PaymentMethodEnum({
    PaymentMethods method,
    bool selected,
    Function onTap
  }): super(
      onTap: onTap,
      child: Container(
          height: 60,
          margin: const EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.symmetric(
              horizontal: selected ? 14 : 15
          ),
          decoration: BoxDecoration(
              color: selected ? Colors.grey.shade100 : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: selected ? 2 : 1,
                  color: selected ? Colors.deepOrange : Colors.grey.shade300
              )
          ),
          child: Row(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(method.paymentMethodEn, style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Lato',
                    color: Color(0xFF313F53),
                    fontWeight: FontWeight.bold
                )),

                Text("Service Charges: " + method.serviceCharge.toString()),
                Text("Total Amount: " + (method.totalAmount+method.serviceCharge).toStringAsFixed(2)),
              ],
            ),
            Spacer(),
            Image.network(method.imageUrl),
          ])
      )
  );
}
