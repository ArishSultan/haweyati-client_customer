import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/models/hive-models/orders/order_model.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/src/utlis/date-formatter.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/emptyContainer.dart';

class OrderDetailPage extends StatefulWidget {
  // final Order order;
  // OrderDetailPage({this.order});
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {



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


  // Order order;

  @override
  void initState() {
    super.initState();
    // order = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(context: context,),
      body: ListView(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildColumn(
                    color: Colors.orange,
                    imgpath: "assets/images/tick.png",
                    text: "Order Placed"),
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: Colors.black,
                )),
                _buildColumn(
                    color: Colors.orange,
                    imgpath: "assets/images/settings.png",
                    text: "Preparing"),
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: Colors.black,
                )),
                _buildColumn(
                    color: Color(0xfff2f2f2f2),
                    imgpath: "assets/images/dispatched.png",
                    text: "Dispatched"),
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: Colors.black,
                )),
                _buildColumn(
                    color: Color(0xfff2f2f2f2),
                    imgpath: "assets/images/home.png",
                    text: "Delivered"),
              ],
            ),
          ),
            SizedBox(height:40,),
          Row(
            children: <Widget>[
              // _buildtext("Order Date, ${formattedDate(DateTime.parse(order.createdAt))} ,"
              //     " ${TimeOfDay.fromDateTime(DateTime.parse(order.createdAt)).format(context)}"),
              // Container(decoration: BoxDecoration(
              //     color: orderStatusColor(order.status),
              //     borderRadius: BorderRadius.circular(12)),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Text(
              //       order.status,
              //       textAlign: TextAlign.center,style: TextStyle(fontSize: 10,
              //         color: Colors.white
              //     ),
              //     ),
              //   ),
              // )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),

          SizedBox(height: 5,),
//           _buildtext("Order ID - ${order.number}",),
// SizedBox(height: 20,),


          EmptyContainer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Drop off Location",
                    style: boldText,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).accentColor,
                      ),
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 10),
                      //     child: Text(
                      //         order.dropOff.dropOffAddress),
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ),

          // SizedBox(
          //   child: Column(children: order._order.items.map<Widget>((elem) => elem.buildWidget(context)).toList()),
          // ),


//         , _buildRow(type: "Delivery Fee",detail:"65 SR" ),

          SizedBox(height: 10,),
          // _buildRowBold(type: "Total",detail: "${widget.order._order.netTotal} SR")
        ],
      ),
    );
  }

  Widget _buildColumn({Color color, String imgpath, String text}) {
    return Column(
      children: <Widget>[
        CircleAvatar(
            backgroundColor: color,
            radius: 25,
            child: Image.asset(
              imgpath,
              width: 20,
              height: 20,
            )),
        SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 12),
        )
      ],
    );
  }

  Widget _buildtext(String text) {
    return Text(text,style: TextStyle(fontSize: 11),);
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
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }





  Widget _buildRowBold({
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
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

}
