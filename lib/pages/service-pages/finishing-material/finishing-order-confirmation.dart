import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haweyati/models/finishing-product.dart';
import 'package:haweyati/models/hive-models/orders/finishing-material_order.dart';
import 'package:haweyati/models/hive-models/orders/order_model.dart';
import 'package:haweyati/models/order-time_and_location.dart';
import 'package:haweyati/pages/payment/payment-method.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/loading-dialog.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/widgits/emptyContainer.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';
import 'package:haweyati/widgits/order-location-picker.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinishingOrderConfirmation extends StatefulWidget {
  FinishingMaterial product;
  FinishingOrderConfirmation({this.product});
  @override
  _FinishingOrderConfirmationState createState() => _FinishingOrderConfirmationState();
}

class _FinishingOrderConfirmationState extends State<FinishingOrderConfirmation> {

  OrderLocation dropOffLocation;

  @override
  void initState() {
    super.initState();
    init();
  }

  void addOrder(/*Order*/ order) async {
    final box = await Hive.openBox('orders');
    await box.clear();
    box.add(order);
    order.save();
  }

  init() async {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        dropOffLocation = OrderLocation(
            cords: LatLng(value.getDouble('latitude'),value.getDouble('latitude')),
            address: value.getString('address'),
            city: value.getString('city')
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: HaweyatiAppBar(context: context,),
        body: HaweyatiAppBody(
          title: "Orders",
          btnName:tr("Place Order"),
          onTap: () async {
            //Place finishing material order
            var finishingMaterialBox = await Hive.openBox('finishing-material-order');
            var finishingMaterialOrder = await finishingMaterialBox.values.first/* as FMOrder*/;

            PaymentResponse paymentResponse = await CustomNavigator.navigateTo(context, SelectPaymentMethod());
            if(paymentResponse!=null){
             openLoadingDialog(context, "Placing order...");
              // await addOrder(Order(
              //   // customer: HaweyatiData.customer.id,
              //   city: dropOffLocation.city,
              //   paymentType: paymentResponse.paymentType,
              //   paymentIntentId: paymentResponse.paymentIntentId,
              //   _order: OrderDetail(
              //       items: [finishingMaterialOrder],
              //       netTotal: 200
              //   ),
              //   address: dropOffLocation.address,
              //   latitude: dropOffLocation.cords.latitude.toString(),
              //   longitude: dropOffLocation.cords.longitude.toString(),
              //   service: 'Finishing Material',
              // ));
              //
              // var postOrder = await HaweyatiService.post('orders',FormData.fromMap(Order(
              //   // customer: HaweyatiData.customer.id,
              //   city: dropOffLocation.city,
              //   paymentType: 'COD',
              //   _order: OrderDetail(
              //       items: [finishingMaterialOrder],
              //       netTotal: 200
              //   ),
              //   address: dropOffLocation.address,
              //   latitude: dropOffLocation.cords.latitude.toString(),
              //   longitude: dropOffLocation.cords.longitude.toString(),
              //   service: 'Finishing Material',
              // ).toJson()) );

             // CustomNavigator.navigateTo(context, OrderPlaced(referenceNo: postOrder.state['orderNo'],));


            }

          },
          showButton: true,
          detail: "Please confirm your order details",
          child: ListView(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 100),
            children: <Widget>[
              OrderLocationPicker(
                onLocationChanged: (OrderLocation location){
                  location = location;
                },
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
                          "Services Detail",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        FlatButton.icon(
                            onPressed: (null),
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
                    Row(
                      children: <Widget>[
                        Image.network(HaweyatiService.convertImgUrl(widget.product.images.name),width: 60,height: 60,),SizedBox(
                          width: 12,
                        ),
                        Text(
                          widget.product.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
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
                            widget.product.price.toString(),
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                          flex: 3,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
//                    Row(
//                      children: <Widget>[
//                        Expanded(
//                          child: Text(widget.product.description),
//                          flex: 4,
//                        ),
//                        Expanded(
//                          child: Text("100 piece"),
//                          flex: 3,
//                        ),
//                        Expanded(
//                          child: Text("No"),
//                          flex: 2,
//                        ),
//                      ],
//                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                widget.product.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              _buildRow(type: "Price", detail: "345.00 Sar"),
              _buildRow(type: "Quantity", detail: "1 Piece"),
              _buildRow(type: "Service Days", detail: "11 Days"),
              _buildRow(type: "Delivery fee", detail: "50.00 SAR"),
              _buildRow(type: "Total", detail: "345.00 Sar")
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
            "Drop-off-Date",
            style: TextStyle(color: Colors.blueGrey),
          ),
          flex: 4,
        ),
        Expanded(
          child: Text(
            "Drop-off-Date",
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
