// import 'package:flutter/material.dart';
// import 'package:haweyati/src/common/simple-form.dart';
// import 'package:haweyati/src/ui/pages/services/scaffolding/adjustments/steel-adjustments_page.dart';
// import 'package:haweyati/src/ui/views/dotted-background_view.dart';
// import 'package:haweyati/src/ui/views/no-scroll_view.dart';
// import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
// import 'package:haweyati/src/utils/navigator.dart';
//
// class CeilingCalculation {
//   String width;
//   String height;
//   String length;
//
//   CeilingCalculation({
//     this.width,
//     this.height,
//     this.length
//   });
// }
//
// class CeilingCalculationPage extends StatelessWidget {
//   final _key = GlobalKey<SimpleFormState>();
//   final _calculation = CeilingCalculation();
//
//   @override
//   Widget build(BuildContext context) {
//     return NoScrollView(
//       body: DottedBackgroundView(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 15, vertical: 20
//         ),
//         child: SimpleForm(
//           key: _key,
//           onSubmit: () => navigateTo(context, SteelAdjustmentsPage(_calculation)),
//           child: Column(children: [
//             TextFormField(
//               style: TextStyle(fontFamily: 'Lato'),
//               decoration: InputDecoration(
//                 isDense: true,
//                 labelText: 'Length',
//               ),
//               keyboardType: TextInputType.number,
//               onSaved: (val) => _calculation.length = val,
//               validator: (value) => value.isEmpty ? "Please Enter Length" : null,
//             ),
//             SizedBox(height: 20),
//             TextFormField(
//               style: TextStyle(fontFamily: 'Lato'),
//               decoration: InputDecoration(
//                 isDense: true,
//                 labelText: 'Width',
//               ),
//               keyboardType: TextInputType.number,
//               onSaved: (val) => _calculation.width = val,
//               validator: (value) => value.isEmpty ? "Please Enter Length" : null,
//             ),
//             SizedBox(height: 20),
//             TextFormField(
//               style: TextStyle(fontFamily: 'Lato'),
//               decoration: InputDecoration(
//                 isDense: true,
//                 labelText: 'Height'
//               ),
//               keyboardType: TextInputType.number,
//               onSaved: (val) => _calculation.height = val,
//               validator: (value) => value.isEmpty ? "Please Enter Length" : null,
//             )
//           ]),
//         ),
//       ),
//
//       bottom: FlatActionButton(
//         label: 'Continue',
//         onPressed: () {
//           _key.currentState.submit();
//         }
//       ),
//     );
//   }
// }
