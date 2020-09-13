import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/views/header_view.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/ui/widgets/counter.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/raised-action-button.dart';
import 'package:haweyati/src/utils/const.dart';

// class _ScaffoldingServicesDetailState extends State<ScaffoldingServicesDetail> {
//   List<ScaffoldingItemModel> orderItems = [];
//   int qty = 0;
//   double price = 0.0;
//
//   bool validateItems(){
//     orderItems.clear();
//     singleScaffoldingItems.forEach((element) {
//       if(element.qty!=0){
//         orderItems.add(
//             element
//         );
//       }
//       qty+=element.qty;
//     });
//     if(qty==0) return false;
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: HaweyatiAppBar(context: context,),
//       body: HaweyatiAppBody(
//             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
//                 ScaffoldingTimeAndLocation(
//                   order: orderItems,
//                   constructionService: widget.constructionService,
//                 )));
//
//           } else {
//             Scaffold.of(context).showSnackBar(SnackBar(
//               content: Text("You must select at least one item"),
//               behavior: SnackBarBehavior.floating,
//             ));
//           }
//
//
//       },showButton: true,
//         child: ListView(
//           padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
//           children: <Widget>[
//             ScaffoldingItem(
//               item: singleScaffoldingItems[0],
//               onValueChange: (ScaffoldingItemModel val){
//                 singleScaffoldingItems[0] = val;
//               },
//             ),
//             ScaffoldingItem(
//               item: singleScaffoldingItems[1],
//               onValueChange: (ScaffoldingItemModel val){
//                 singleScaffoldingItems[1] = val;
//               },
//             ),
//             ScaffoldingItem(
//               item: singleScaffoldingItems[1],
//               onValueChange: (ScaffoldingItemModel val){
//                 singleScaffoldingItems[1] = val;
//               },
//             ),
//             ScaffoldingItem(
//               item: singleScaffoldingItems[2],
//               onValueChange: (ScaffoldingItemModel val){
//                 singleScaffoldingItems[2] = val;
//               },
//             ),
//             ScaffoldingItem(
//               item: singleScaffoldingItems[3],
//               onValueChange: (ScaffoldingItemModel val){
//                 singleScaffoldingItems[3] = val;
//               },
//             ),
//             ScaffoldingItem(
//               item: singleScaffoldingItems[4],
//               onValueChange: (ScaffoldingItemModel val){
//                 singleScaffoldingItems[4] = val;
//                 print(val.toJson());
//               },
//             ),
//             ScaffoldingItem(
//               item: singleScaffoldingItems[5],
//               onValueChange: (ScaffoldingItemModel val){
//                 singleScaffoldingItems[5] = val;
//               },
//             ),
//           ],
//         ),
//       ),
