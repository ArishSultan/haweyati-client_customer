import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:haweyati/src/models/services/building-material/model.dart';
import 'package:haweyati/models/hive-models/orders/building-material-order.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/counter.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/flat-action-button.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/container-with-add-remove-item.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';
import 'package:hive/hive.dart';

import 'time-location_page.dart';

class BuildingMaterialServiceDetailPage extends StatefulWidget {
  final BuildingMaterial item;
  BuildingMaterialServiceDetailPage(this.item);

  @override
  _BuildingMaterialServiceDetailPageState createState() => _BuildingMaterialServiceDetailPageState();
}

class _BuildingMaterialServiceDetailPageState extends State<BuildingMaterialServiceDetailPage> {
  int qty20Yard = 0;
  int qty12Yard = 0;

  void addBuildingOrder(List bmOrder) async {
     var box = await Hive.openBox('bmorder');
     await box.clear();
     box.addAll(bmOrder);
     bmOrder.forEach((element) {element.save();});
  }


  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      body: DottedBackgroundView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15
        ),
        child: Column(children: [
          HeaderView(
            title: 'Product Details',
            subtitle: loremIpsum.substring(0, 70),
          ),

          RichText(
            text: TextSpan(
              text: 'Small Container,',
              style: TextStyle(
                color: Color(0xFF313F53),
                fontSize: 13,
                fontWeight: FontWeight.bold
              ),
              children: [
                TextSpan(
                  text: ' 12 Yards',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF313F53)
                  )
                )
              ]
            ),
          ),

          DarkContainer(
            height: 80,
            margin: const EdgeInsets.only(
              top: 20, bottom: 30
            ),
            padding: const EdgeInsets.all(15),
            child: Row(children: [
              Expanded(
                child: Column(children: [
                  Text('Quantity', style: TextStyle(
                    color: Color(0xFF313F53),
                    fontWeight: FontWeight.bold
                  )),
                  Spacer(),
                  Text('SAR ${widget.item.pricing.first.price12yard.round()}', style: TextStyle(
                    color: Color(0xFF313F53),
                  )),
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ),

              Counter(
                onChange: (asd) {},
              )
            ]),
          ),

          RichText(
            text: TextSpan(
              text: 'Big Container,',
              style: TextStyle(
                color: Color(0xFF313F53),
                fontSize: 13,
                fontWeight: FontWeight.bold
              ),
              children: [
                TextSpan(
                  text: ' 20 Yards',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF313F53)
                  )
                )
              ]
            ),
          ),

          DarkContainer(
            height: 80,
            margin: const EdgeInsets.only(
              top: 20, bottom: 30
            ),
            padding: const EdgeInsets.all(15),
            child: Row(children: [
              Expanded(
                child: Column(children: [
                  Text('Quantity', style: TextStyle(
                    color: Color(0xFF313F53),
                    fontWeight: FontWeight.bold
                  )),
                  Spacer(),
                  Text('SAR ${widget.item.pricing.first.price20yard.round()}', style: TextStyle(
                    color: Color(0xFF313F53),
                  )),
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ),

              Counter(
                onChange: (asd) {},
              )
            ]),
          ),
        ], crossAxisAlignment: CrossAxisAlignment.start),
      ),

      bottom: FlatActionButton(
        label: 'Continue',
        onPressed: () {
          navigateTo(context, BuildingTimeAndLocation(bmItem: widget.item));
        }
      ),
    );
    // return Scaffold(
    //   appBar: HaweyatiAppBar(
    //     context: context,
    //   ),
    //   body: HaweyatiAppBody(
    //     title: "Product Detail",
    //     detail: loremIpsum.substring(0, 90),
    //     child: ListView(
    //       children: <Widget>[
    //         Align(
    //             alignment: Alignment.centerLeft,
    //             child: RichText(
    //               text: TextSpan(
    //                   text: "Small Container,",
    //                   style: TextStyle(
    //                       color: Colors.black,
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.bold),
    //                   children: [
    //                     TextSpan(
    //                         text: "     12 Yard",
    //                         style: TextStyle(
    //                           fontSize: 12,
    //                         ))
    //                   ]),
    //             )),
    //         SizedBox(
    //           height: 10,
    //         ),
    //         QuantitySelector(
    //           canBeZero: true,
    //           title: 'Price: ${qty12Yard == 1 ? widget.item.pricing.first.price12yard : widget.item.pricing.first.price12yard * qty12Yard.toDouble()} ',
    //           onValueChange: (int val){
    //             setState(() {
    //               qty12Yard=val;
    //             });
    //           },
    //           subtitle: "Quantity",
    //         ),
    //         SizedBox(
    //           height: 20,
    //         ),
    //         Align(
    //             alignment: Alignment.centerLeft,
    //             child: RichText(
    //               text: TextSpan(
    //                   text: "Big Container,",
    //                   style: TextStyle(
    //                       color: Colors.black,
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.bold),
    //                   children: [
    //                     TextSpan(
    //                         text: "     20 Yard",
    //                         style: TextStyle(
    //                           fontSize: 12,
    //                         ))
    //                   ]),
    //             )),
    //         SizedBox(
    //           height: 10,
    //         ),
    //         QuantitySelector(
    //           canBeZero: false,
    //           title: 'Price: ${qty20Yard == 1 ? widget.item.pricing.first.price20yard :
    //           widget.item.pricing.first.price20yard * qty20Yard.toDouble()} ',
    //           onValueChange: (int val){
    //             setState(() {
    //               qty20Yard=val;
    //             });
    //           },
    //           subtitle: "Quantity",
    //         ),
    //         SizedBox(
    //           height: 20,
    //         ),
    //       ],
    //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    //     ),
    //     btnName: tr("Continue"),
    //     onTap: () async {
    //       print(widget.item.toJson());
    //
    //       List<BMOrder> bmOrders = [];
    //       if(qty20Yard!=0){
    //         bmOrders.add(BMOrder(
    //           product: widget.item,
    //             qty: qty20Yard,
    //             size: '20 Yard',
    //             total: qty20Yard * widget.item.pricing.first.price20yard,
    //             price: widget.item.pricing.first.price20yard,
    //         ));
    //       }
    //
    //       if(qty12Yard!=0){
    //         bmOrders.add(BMOrder(
    //           product: widget.item,
    //           qty: qty12Yard,
    //           size: '12 Yard',
    //           total: qty12Yard * widget.item.pricing.first.price12yard,
    //           price: widget.item.pricing.first.price12yard,
    //         ));
    //       }
    //
    //     await addBuildingOrder(bmOrders);
    //         CustomNavigator.navigateTo(context, BuildingTimeAndLocation(bmItem: widget.item,));
    //     },
    //     showButton: true,
    //   ),
    // );
  }
}
