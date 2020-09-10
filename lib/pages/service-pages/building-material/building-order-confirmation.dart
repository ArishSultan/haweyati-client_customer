import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/models/building-material_sublist.dart';
import 'package:haweyati/models/hive-models/orders/building-material-order.dart';
import 'package:haweyati/models/hive-models/orders/order-details_model.dart';
import 'package:haweyati/models/hive-models/orders/order_model.dart';
import 'package:haweyati/models/hive-models/orders/transaction_model.dart';
import 'package:haweyati/pages/payment/payment-method.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/loading-dialog.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/src/utlis/date-formatter.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/widgits/emptyContainer.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';
import 'package:haweyati/widgits/orderPlaced.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BuildingOrderConfirmation extends StatefulWidget {
  final BMProduct item;
  BuildingOrderConfirmation({this.item});

  @override
  _BuildingOrderConfirmationState createState() => _BuildingOrderConfirmationState();
}

class _BuildingOrderConfirmationState extends State<BuildingOrderConfirmation> {

  @override
  void initState() {
    super.initState();
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
              var orders = await Hive.box('orders');
              var bmOrderBox = await Hive.box('bmorder');
              var order = await orders.values.first as Order;
              var bmOrder = await bmOrderBox.values.first as BMOrder;
              // order.customer = HaweyatiData.customer.id;

              // print(order._order.netTotal);
            PaymentResponse paymentResponse = await CustomNavigator.navigateTo(context, SelectPaymentMethod(
              transaction: Transaction(
                  // paymentAmount: order._order.netTotal
              )
            ));
            if(paymentResponse!=null){
              if(paymentResponse.paymentType == 'card'){
                // order.paymentIntentId = paymentResponse.paymentIntentId;
              }
              order.save();
              openLoadingDialog(context, "Placing your oder...");
              var postOrder = await HaweyatiService.post('orders',FormData.fromMap(order.toJson()) );
              Navigator.pop(context);
              CustomNavigator.navigateTo(context, OrderPlaced(referenceNo: postOrder.state['orderNo'],));
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
                            onPressed: (){
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
                        Image.network(HaweyatiService.convertImgUrl(widget.item.image.name) ?? "",width: 60,height: 60,)
                        ,  SizedBox(
                          width: 12,
                        ),
                        Text(
                          widget.item.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Price",
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                          flex: 4,
                        ),
                        Expanded(
                          child: Text(
                            "12 Yard Container",
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Text(
                            "24 Yard Container",
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
//                    ValueListenableBuilder(
//                      valueListenable: Hive.box('bmorder').listenable(),
//                        builder: (context,box,widget){
//                        BMOrder order = box.values.first as BMOrder;
//                            return Row(
//                          children: <Widget>[
//                            Expanded(
//                              child: Text(box.values),
//                              flex: 4,
//                            ),
//                            Expanded(
//                              child: Text("${order.qty} piece"),
//                              flex: 3,
//                            ),
//                        Expanded(
//                          child: Text("No"),
//                          flex: 2,
//                        ),
//                          ],
//                        );
//                        }
//                    )
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: Hive.box('orders').listenable(),
                builder: (context,box,widget){
                  Order order = box.values.first as Order;
                  return EmptyContainer(
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
                              child: Text(''/*order.address*/)
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        _buildHeadRow(
                            text1: "Drop-off-Date", text2: "Drop-off-Time"),
                        SizedBox(
                          height: 15,
                        ),
                    // _builddetailRow(
                    //     text1: formattedDate(DateTime.parse(order.dropOffDate)), text2: order.dropOffTime),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                widget.item.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              ValueListenableBuilder(
                valueListenable: Hive.box('bmorder').listenable(),
                  builder: (context,box,widget){

                  return   Column(
                  children: [
                    for(var order in box.values)
                      _buildRow(type: " ${order.size}", detail: "Quantity : ${order.qty} Price : ${order.price}"),
//              _buildRow(type: "Quantity", detail: "1 Piece"),
//              _buildRow(type: "Service Days", detail: "11 Days"),
//              _buildRow(type: "Delivery fee", detail: "50.00 SAR"),SizedBox(height: 8,),

                  Row(children: <Widget>[
                  Text("Total", style: TextStyle(color: Colors.blueGrey),),

                  ValueListenableBuilder(
                    valueListenable: Hive.box('orders').listenable(),
                    builder: (context,box,widget){
                    return Text("${box.values.first._order.netTotal} SR",
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),);
                    }
                  )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,)

                  ],
                  );
                   }

              ),


            ],
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
          flex: 4,
        ),
      ],
    );
  }
}
