import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/models/hive-models/orders/order-details_model.dart';
import 'package:haweyati/models/hive-models/orders/order_model.dart';
import 'package:haweyati/models/hive-models/orders/scaffolding-item_model.dart';
import 'package:haweyati/models/order-time_and_location.dart';
import 'package:haweyati/pages/payment/payment-method.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/src/utlis/date-formatter.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/widgits/emptyContainer.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';
import 'package:haweyati/widgits/orderPlaced.dart';

class ScaffoldingOrderConfirmation extends StatefulWidget {
  final String subService;
  final List order;
  final DateTime date;
  final String time;
  final OrderLocation location;
  ScaffoldingOrderConfirmation({this.date,this.time,this.location,this.order,this.subService});

  @override
  _ScaffoldingOrderConfirmationState createState() => _ScaffoldingOrderConfirmationState();
}

class _ScaffoldingOrderConfirmationState extends State<ScaffoldingOrderConfirmation> {

  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    widget.order.forEach((element) {
      totalPrice += element.price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: HaweyatiAppBar(context: context,),
        body: HaweyatiAppBody(
          title: "Orders",
          btnName: tr("Continue"),
          onTap: () async {

            PaymentResponse response = await CustomNavigator.navigateTo(context, SelectPaymentMethod());
            print(response);

            if(response!=null){
              // Order order = Order(
              //   service: 'Scaffolding',
              //   subService: widget.subService,
              //   address: widget.location.address,
              //   latitude: widget.location.cords.latitude.toString(),
              //   longitude: widget.location.cords.longitude.toString(),
              //   dropOffDate: widget.date.toIso8601String(),
              //   dropOffTime: widget.time,
              //   city: widget.location.city,
              //   paymentType: response.paymentType,
              //   paymentIntentId: response.paymentIntentId,
              //   // customer: HaweyatiData.customer.id,
              //   _order: OrderDetail(
              //     netTotal: totalPrice,
              //     items: widget.order,
              //   )
              // );

              // print(order.toJson());
              //
              // var postOrder = await HaweyatiService.post('orders',FormData.fromMap(order.toJson()) );
              // CustomNavigator.navigateTo(context, OrderPlaced(referenceNo: postOrder.state['orderNo'],));
//
//              print(order.toJson());
            }
          },
          showButton: true,
          detail: loremIpsum.substring(0,60,),
          child: ListView(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 100),
            children: <Widget>[
              EmptyContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Services Detail",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        FlatButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).accentColor,
                            ),
                            label: Text(
                              "Edit",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset("assets/images/steelscaffolding.png",width: 60,height: 60,)
                       ??SizedBox() ,                        SizedBox(
                          width: 12,
                        ),
                        Text("Steel Scaffolding",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              EmptyContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Time & Location",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        FlatButton.icon(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).accentColor,
                            ),
                            label: Text(
                              "Edit",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    FlatButton.icon(
                        onPressed: (null),
                        icon: Icon(
                          Icons.location_on,
                          color: Theme.of(context).accentColor,
                        ),
                        label: Expanded(
                          child: Text(widget.location.address,
                          ),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    _buildHeadRow(
                        text1: "Drop-off-Date", text2: "Drop-off-Time"),
                    SizedBox(
                      height: 15,
                    ),
                    _builddetailRow(
                        text1: formattedDate(widget.date), text2: widget.time),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Steel Scaffolding",
                style: TextStyle(color: Colors.blueGrey),
              ),
              // for(var item in singleScaffoldingItems)
              //   _buildRow(type: item.name, detail: "${item.price} Sar"),

              Row(children: <Widget>[ Text("Total", style: TextStyle(color: Colors.blueGrey),),
                Text("${totalPrice} SR",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),) ],mainAxisAlignment: MainAxisAlignment.spaceBetween,)            ],
          ),
        ));
  }

  Widget _buildRow({
    String type,
    String detail,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Text(
            type,
            style: TextStyle(color: Colors.blueGrey),
          ),
          Text(
            detail,
            style:
            TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Widget _buildHeadRow({String text1, String text2}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            text1,
            style: TextStyle(color: Colors.blueGrey),
          ),
          flex: 4,
        ),
        Expanded(
          child: Text(
            text2,
            style: TextStyle(color: Colors.blueGrey),
          ),
          flex: 3,
        ),
      ],
    );
  }

  Widget _builddetailRow({String text1, String text2}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            text1,
          ),
          flex: 4,
        ),
        Expanded(
          child: Text(
            text2,
          ),
          flex: 3,
        ),
      ],
    );
  }
}
