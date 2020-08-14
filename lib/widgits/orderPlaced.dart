import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/pages/home_page.dart';
import 'package:haweyati/widgits/custom-navigator.dart';

class OrderPlaced extends StatefulWidget {
  final String referenceNo;
  OrderPlaced({this.referenceNo=''});
  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        CustomNavigator.pushReplacement(context, AppHomePage());
        return ;
      },
      child: Scaffold(
          appBar:AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                CustomNavigator.pushReplacement(context, AppHomePage());
              },
            ),
            title: Text('Order Placed'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.check,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Thank You , Your Order has been placed successfully",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Order Reference No : ${widget.referenceNo}",
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
//                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyOrders()));
                      },
                      child: Text(
                        "Home",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      ))
//                  GestureDetector(
//                      onTap: () {
//                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyOrders()));
//                      },
//                      child: Text(
//                        "View All Orders",
//                        style: TextStyle(
//                            color: Theme.of(context).accentColor,
//                            fontSize: 18),
//                        textAlign: TextAlign.center,
//                      ))
                ],
              ),
            ),)
              ),
    );
  }
}
