import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/models/hive-models/orders/scaffolding-item_model.dart';

class ScaffoldingItem extends StatefulWidget {
  final item;
  final Function(dynamic) onValueChange;

  ScaffoldingItem({this.item, this.onValueChange});

  @override
  _ScaffoldingItemState createState() => _ScaffoldingItemState();
}

class _ScaffoldingItemState extends State<ScaffoldingItem> {
  var item;

  _increment() {
    setState(() {
     item.qty++;
    });
    item.total = item.qty * item.price;
    widget.onValueChange(item);
  }

  _decrement() {
    setState(() {
      item.qty--;
    });
    item.total = item.qty * item.price;
    widget.onValueChange(item);
  }

  @override
  void initState() {
    super.initState();
    item = widget.item;
    item.total = item.qty * item.price;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Color(0xfff2f2f2f2),
        borderRadius: BorderRadius.circular(15),
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    item.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (item.qty > 0) {
                              _decrement();
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "${item.qty }",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Theme.of(context).accentColor),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _increment();
                          },
                        ),
                      ),
                    ],
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),


         SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text((item.price * item.qty).toString()),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (item.size > 0.5) {
                              setState(() {
                                item.size -= 0.5;
                              });
                              widget.onValueChange(item);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "${item.size} Meter",
                              style:
                              TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Theme.of(context).accentColor),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (item.size < 4) {
                              setState(() {
                                item.size += 0.5;
                              });
                              widget.onValueChange(item);
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                ],
              )
            ],
          )),
    );
  }
}
