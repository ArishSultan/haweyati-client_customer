// import 'package:flutter/material.dart';
// import 'package:haweyati/src/rest/scaffolding_service.dart';
// import 'package:haweyati/src/ui/views/no-scroll_view.dart';
// import 'package:haweyati/src/utils/simple-future-builder.dart';
// import 'package:haweyati/src/ui/views/dotted-background_view.dart';
// import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
// import 'package:haweyati/src/models/services/scaffolding/scaffolding-types.dart';
//
// class WrapperPage extends StatefulWidget {
//   final ScaffoldingType type;
//   final void Function() onPressed;
//   final List<Widget> Function(ScaffoldingPrice) builder;
//
//   WrapperPage({
//     this.type,
//     this.builder,
//     this.onPressed
//   });
//
//   @override
//   _WrapperPageState createState() => _WrapperPageState();
// }
//
// class _WrapperPageState extends State<WrapperPage> {
//   Future<ScaffoldingPrice> _pricing;
//   final ScaffoldingService service = ScaffoldingService();
//
//   @override
//   void initState() {
//     super.initState();
//
//     switch (widget.type) {
//       case ScaffoldingType.steel:
//         _pricing = service.steelScaffoldingPrice();
//         break;
//       case ScaffoldingType.single:
//         _pricing = service.singleScaffoldingPrice();
//         break;
//       case ScaffoldingType.patented:
//         _pricing = service.patentedScaffoldingPrice();
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return NoScrollView(
//       body: DottedBackgroundView(
//         padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//         child: SimpleFutureBuilder(
//           future: _pricing,
//           context: context,
//           builder: (snapshot) => ListView(
//             children: widget.builder(snapshot.data)
//           ),
//
//           errorBuilder: (value) {
//             return Center(child: Text('Service not available'));
//           },
//           noneChild: Center(child: Text('Service not available')),
//           noDataChild: Center(child: Text('Service not available')),
//           activeChild: Center(child: CircularProgressIndicator(strokeWidth: 2)),
//           waitingChild: Center(child: CircularProgressIndicator(strokeWidth: 2)),
//           unknownChild: Center(child: Text('Service not available')),
//         ),
//       ),
//       bottom: RaisedActionButton(
//         label: 'Rent Now',
//         onPressed: widget.onPressed
//       )
//     );
//   }
// }
