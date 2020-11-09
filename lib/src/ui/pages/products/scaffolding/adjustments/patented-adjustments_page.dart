// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:haweyati/src/models/order/dumpster_orderable.dart';
// import 'package:haweyati/src/models/order/order_model.dart';
// import 'package:haweyati/src/models/order/scaffoldings/dumpster_orderable.dart';
// import 'package:haweyati/src/models/services/scaffolding/patented-scaffolding_model.dart';
// import 'package:haweyati/src/models/services/scaffolding/scaffolding-types.dart';
// import 'package:haweyati/src/rest/scaffolding_service.dart';
// import 'package:haweyati/src/ui/views/header_view.dart';
// import 'package:haweyati/src/ui/views/scroll_view.dart';
// import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
// import 'package:haweyati/src/const.dart';
// import 'package:haweyati/src/ui/widgets/scaffolding-item-selector.dart';
// import 'package:haweyati/src/utils/simple-future-builder.dart';
//
// class PatentedAdjustmentsPage extends StatefulWidget {
//   @override
//   _PatentedAdjustmentsPageState createState() => _PatentedAdjustmentsPageState();
// }
//
// class _PatentedAdjustmentsPageState extends State<PatentedAdjustmentsPage> {
//   final _service = ScaffoldingService();
//   final _scaffolding = PatentedScaffolding();
//
//   @override
//   Widget build(BuildContext context) {
//     ScaffoldingService().steelScaffoldingPrice();
//     var _allow = _scaffolding.woodPlanks.qty +
//         _scaffolding.stairs.qty +
//         _scaffolding.stabilizers.qty +
//         _scaffolding.adjustableBase.qty +
//         _scaffolding.standardBars.qty +
//         _scaffolding.ledgerBars.qty > 0;
//
//     return SimpleFutureBuilder(
//       context: context,
//       future: _service.steelScaffoldingPrice(),
//       builder: (context) => ScrollableView(
//         showBackground: true,
//         padding: const EdgeInsets.fromLTRB(
//           15, 0, 15, 100
//         ),
//         children: [
//           HeaderView(
//             title: 'Scaffolding Details',
//             subtitle: loremIpsum.substring(0, 50),
//           ),
//
//           ScaffoldingItemSelector(
//             price: 100,
//             text: 'Standard Bars',
//             item: _scaffolding.standardBars,
//             onChange: () => setState(() {}),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 15),
//             child: ScaffoldingItemSelector(
//               item: _scaffolding.ledgerBars,
//               text: 'Ledger Bars',
//               price: 100,
//               onChange: () => setState(() {}),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 15),
//             child: ScaffoldingItemSelector(
//               item: _scaffolding.adjustableBase,
//               text: 'Adjustable Base',
//               price: 100,
//               onChange: () => setState(() {}),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 15),
//             child: ScaffoldingItemSelector(
//               item: _scaffolding.stabilizers,
//               text: 'Stabilizers',
//               price: 100,
//               onChange: () => setState(() {}),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 15),
//             child: ScaffoldingItemSelector(
//               item: _scaffolding.stairs,
//               text: 'Stairs',
//               price: 100,
//               onChange: () => setState(() {}),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 15),
//             child: ScaffoldingItemSelector(
//               item: _scaffolding.woodPlanks,
//               text: 'Wood planks',
//               price: 100,
//               onChange: () => setState(() {}),
//             ),
//           )
//         ],
//
//         bottom: RaisedActionButton(
//           label: 'Rent Now',
//           onPressed: _allow ? () {
//             final _order = Order(OrderType.scaffolding,
//               items: [OrderItemHolder(
//                 product: ScaffoldingOrderItem(
//                   product: _scaffolding,
//                   type: ScaffoldingType.patented
//                 )
//               )],
//             );
//
//             // navigateTo(context, OrderConfirmationPage())
//           } : null
//         )
//       ),
//       errorBuilder: (value) {
//         return Scaffold(
//           body: Center(child: Text('Service not available')),
//         );
//       },
//       waitingChild: Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//           ),
//         ),
//       ),
//       noDataChild: Scaffold(
//         body: Center(child: Text('Service not available')),
//       ),
//       noneChild: Scaffold(
//         body: Center(child: Text('Service not available')),
//       ),
//       activeChild: Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//           ),
//         ),
//       )
//     );
//   }
// }
//
//
//
