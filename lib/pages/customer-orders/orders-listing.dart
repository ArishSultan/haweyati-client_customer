import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/models/hive-models/orders/order_model.dart';
// import 'package:haweyati/src/ui/pages/services/dumpsters/service-detail_page.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/services/order-service.dart';
import 'package:haweyati/src/utlis/date-formatter.dart';
import 'package:haweyati/src/utlis/simple-future-builder.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/widgits/emptyContainer.dart';

import 'order-details_page.dart';

class ViewAllOrders extends StatefulWidget {
  @override
  _ViewAllOrdersState createState() => _ViewAllOrdersState();
}

class _ViewAllOrdersState extends State<ViewAllOrders> {

  Future<List<Order>> orders = OrdersService().orders();

  Color orderStatusColor(String status){
    switch(status){
      case 'pending':
        return Colors.orange;
        break;
      case 'completed':
        return Theme.of(context).primaryColor;
        break;
      case  'active':
        return Colors.green;
        break;
      case 'cancelled':
        break;
      default:
        return Colors.orange;
        break;
    }
  }

  parseOrder(String service, Map<String,dynamic> json){
    switch(service){
      case 'Construction Dumpster':
        break;
    }
  }



  @override
  void initState() {
    super.initState();

    print(orders.then((value) => print(value)));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(context: context,showCart: false,),
      body: Column(
        children: [
          SimpleFutureBuilder.simpler(
            context: context,
            future: orders,
            builder: (AsyncSnapshot<List<Order>> orders){
              return Expanded(
                child: ListView.builder(
                  itemCount: orders.data.length,
                  itemBuilder: (context,index){
                    Order order = orders.data[index];
                    return GestureDetector(
                      onTap: (){
                        CustomNavigator.navigateTo(
                            context, OrderDetailPage(
                          order: order,
                        ));
                        },
                      child: EmptyContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Row(
                                children: <Widget>[
                                  // _buildtext("Order Date, ${formattedDate(DateTime.parse(order.createdAt))} ,"
                                  //     " ${TimeOfDay.fromDateTime(DateTime.parse(order.createdAt)).format(context)}"),

                                  Container(decoration: BoxDecoration(
                                      color:  orderStatusColor(order.status),
                                      borderRadius: BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        order.status,
                                        textAlign: TextAlign.center,style: TextStyle(fontSize: 10,color: Colors.white),
                                      ),
                                    ),
                                  ),

//                            item.buildWidget(context),
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),

                              SizedBox(height: 10,),
                              _buildtext("Order ID - ${order.number}",),
                              SizedBox(
                                height: 15,
                              ),
//                        _buildImageRow(order.order.items.size),
                              SizedBox(height: 20),
                              SizedBox(
//                          height: 400,
//                                 child: Column(
//                                     children: order._order.items.map<Widget>((elem) => elem.buildWidget(context)).toList()),
                              ),
//                        order.order.items.forEach((element) {})
//                        order.service != 'Construction Dumpster' ?
//                        Row(children: <Widget>[_buildtext("Quantity"),_buildtext("1 Piece"),],mainAxisAlignment: MainAxisAlignment.spaceBetween,)
//                            : SizedBox(),
                              SizedBox(height: 15),
                              // Row(children: <Widget>[_buildtext("Total"),Text("${order._order.netTotal} SR",
                              //   style: TextStyle(fontWeight: FontWeight.bold),)],
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  padding: EdgeInsets.all(10),
                ),
              );
            },
          ),
        ],
      ),
    );
  }



  Widget _buildtext(String text) {
    return Text(text,style: TextStyle(fontSize: 11),);
  }

}
