import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/models/building-material_sublist.dart';
import 'package:haweyati/models/dumpster_model.dart';
import 'package:haweyati/models/hive-models/orders/building-material-order.dart';
import 'package:haweyati/models/hive-models/orders/dumpster-order_model.dart';
import 'package:haweyati/models/hive-models/orders/order-details_model.dart';
import 'package:haweyati/models/hive-models/orders/order_model.dart';
import 'package:haweyati/models/hive-models/orders/transaction_model.dart';
import 'package:haweyati/pages/orderDetail/orderPlaced.dart';
import 'package:haweyati/pages/payment/payment-method.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/ui/pages/signin_page.dart';
import 'package:haweyati/src/ui/widgets/loading-dialog.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/src/utlis/date-formatter.dart';
import 'package:haweyati/src/utlis/hive-local-data.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/custom-navigator.dart';
import 'package:haweyati/widgits/emptyContainer.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';
import 'package:haweyati/widgits/orderPlaced.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DumpsterOrderConfirmation extends StatefulWidget {
  final Dumpster item;
  DumpsterOrderConfirmation({this.item});

  @override
  _BuildingOrderConfirmationState createState() => _BuildingOrderConfirmationState();
}

class _BuildingOrderConfirmationState extends State<DumpsterOrderConfirmation> {

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
            var dumpster = await Hive.openBox('dumpster');
            var orders = await Hive.openBox('orders');

            var orderData = await orders.values.first as Order;
            var dumpsterOrder = await dumpster.values.first as DumpsterOrder;

            orderData.customer = HaweyatiData.customer.id;

            orderData.order = OrderDetails(
                items: [dumpsterOrder],
                netTotal: dumpsterOrder.total
            );


            if(HaweyatiData.isSignedIn){

              PaymentResponse paymentResponse = await CustomNavigator.navigateTo(context, SelectPaymentMethod(transaction: Transaction(
                paymentAmount: dumpsterOrder.total
              ),));

              print(paymentResponse);

              if(paymentResponse!=null){
                openLoadingDialog(context, 'Placing your order..');

                orderData.paymentType = paymentResponse.paymentType;
                if(paymentResponse.paymentType == 'card'){
                  orderData.paymentIntentId = paymentResponse.paymentIntentId;
                }


                orderData.save();


                FormData dumpsterPostData = FormData.fromMap(orderData.toJson());

                if(orderData.image!=null){
                  print(orderData.image + "image null nahi thee");
                  dumpsterPostData.files.add(MapEntry(
                      'image' , await MultipartFile.fromFile(orderData.image,filename: DateTime.now().toIso8601String())
                  ));
                }

                var postOrder = await HaweyatiService.post('orders',dumpsterPostData );

                CustomNavigator.navigateTo(context, OrderPlaced(referenceNo: postOrder.data['orderNo'],));

                print(dumpsterPostData.fields);
            } else {

              }
          }
            else {
               CustomNavigator.navigateTo(context, SignInPage());

            }
          },
          showButton: true,
          detail: 'Please confirm your order details',
          child: ListView(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 100),
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
                          "Services Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        FlatButton.icon(
                            onPressed: (){
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
                          widget.item.size + "Yard Dumpster",
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
                            "Quantity",
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Text(
                            "Days",
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(widget.item.pricing[0].rent.toString() + ' SR/'
                              '' + widget.item.pricing[0].days.toString() + ' days'),
                          flex: 4,
                        ),
                        Expanded(
                          child: Text("1 Piece"),
                          flex: 3,
                        ),
                        ValueListenableBuilder(
                          valueListenable: Hive.box('dumpster').listenable(),
                          builder: (context,box,widget){
                            DumpsterOrder order = box.values.first as DumpsterOrder;
                            return Expanded(
                              child: Text( (order.dumpster.pricing.first.days + order.extraDays).toString()),
                              flex: 2,
                            );
                          },
                        ),
                      ],
                    )
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
                              child: Text(order.address)
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
                        text1: formattedDate(DateTime.parse(order.dropOffDate)), text2: order.dropOffTime),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),

              Text(
               " ${widget.item.size} Yard Container Dumpster",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              ValueListenableBuilder(
                valueListenable: Hive.box('dumpster').listenable(),
                builder: (context,box,widget){
                  DumpsterOrder order = box.values.first as DumpsterOrder;
                  return Column(
                    children: [
                      _buildRow(type: "Price (${order.dumpster.pricing.first.days} Days)", detail: " ${order.dumpster.pricing.first.rent.toStringAsFixed(2)} SR"),
                      _buildRow(type: "Extra (${order.extraDays} Days)", detail: "${order.extraDayPrice.toStringAsFixed(2)} SR"),
//                      _buildRow(type: "Service Days", detail: "11 Days"),
//                      _buildRow(type: "Delivery fee", detail: "50.00 SAR"),SizedBox(height: 8,),
//
                      Row(children: <Widget>[
                        Text("Total", style: TextStyle(color: Colors.blueGrey),),
                        Text(order.total.toStringAsFixed(2) + " SR",
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),) ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                    ],
                  );
                },
              ),        ],
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
