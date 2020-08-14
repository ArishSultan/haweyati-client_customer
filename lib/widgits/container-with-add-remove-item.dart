
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class QuantitySelector extends StatefulWidget {
  final String subtitle;
  final String title;
  final Function(int) onQuantityChange;
  final Function(int) onValueChange;
  final bool canBeZero;

  QuantitySelector({this.title,this.subtitle,this.canBeZero=false,this.onValueChange,this.onQuantityChange});

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {

  int quantity = 1;

  @override
  void initState() {
    super.initState();
    quantity = widget.canBeZero ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color:Color(0xfff2f2f2f2),
        borderRadius: BorderRadius.circular(15),
      ),

      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:CrossAxisAlignment.start,children: <Widget>[
              Text(
            widget.subtitle,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16),
          ),
            SizedBox(height: 10,),
            Text(
            widget.title,
            style: TextStyle(
                 fontSize: 16),
          ),],

          ),

        Row(children: <Widget>[
  Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      color: Theme.of(context).accentColor,  borderRadius:
    BorderRadius
        .circular(25),),
    child: IconButton(padding: EdgeInsets.zero,
      icon:
      Icon(Icons.remove,color: Colors.white,),
      onPressed: () {

      if(widget.canBeZero && quantity > 0){
        setState(() {
          quantity--;
          widget.onValueChange(quantity);
        });
      }else if(quantity>1){
        setState(() {
          quantity--;
          widget.onValueChange(quantity);
        });
      }

      },
    ),
  )
  ,
  Padding(
    padding: const EdgeInsets
        .symmetric(
        horizontal: 10),
    child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.white,),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Text(
          "$quantity",             style: TextStyle(
            fontSize: 12,color: Colors.black),
        ),
      ),
    ),
  ),
  Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
        borderRadius:
        BorderRadius
            .circular(25),
        color: Theme.of(context).accentColor),
    child: IconButton(padding: EdgeInsets.zero,
      icon:
      Icon(Icons.add,color: Colors.white,),
      onPressed: () {

        setState(() {
          quantity++;
        });
        widget.onValueChange(quantity);

      },
    ),
  )
  ,
],)


        ],mainAxisAlignment: MainAxisAlignment.spaceBetween,)
      ),
    );
  }
}
