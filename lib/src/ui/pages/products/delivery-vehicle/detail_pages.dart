part of 'delivery-vehicle_pages.dart';

class DeliveryVehiclesPage extends StatelessWidget {
  final _service = DeliveryVehicleRest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(hideHome: true),
      body: LiveScrollableView<DeliveryVehicle>(
        title: 'Delivery Vehicles',
        subtitle: loremIpsum.substring(0, 70),
        loader: () => _service.get(),
        builder: (context, data) => ProductListTile(
          name: data.name,
          image: data.image.name,
          // onTap: () => navigateTo(context, DeliveryVehicleSelectionPage(data)),
        ),
      ),
    );
  }
}

// class DeliveryVehiclePage extends StatelessWidget {
//   final DeliveryVehicle deliveryVehicle;
//   DeliveryVehiclePage(this.deliveryVehicle);
//
//   @override
//   Widget build(BuildContext context) {
//     final title = deliveryVehicle.name;
//
//     return ProductDetailView(
//       shareableData: ShareableData(
//         id: deliveryVehicle.id,
//         type: OrderType.deliveryVehicle,
//         socialMediaTitle: title,
//         socialMediaDescription: deliveryVehicle.name
//       ),
//       title: title,
//       image: deliveryVehicle.image.name,
//       // price: TextSpan(
//       //   text: '${deliveryVehicle.pricing.first.rent.toStringAsFixed(2)} SAR',
//       //   style: TextStyle(color: Color(0xFF313F53)),
//       //   children: [
//       //     TextSpan(
//       //       text: '   per ${deliveryVehicle.pricing.first.days} days ',
//       //       style: TextStyle(
//       //         fontSize: 13,
//       //         fontWeight: FontWeight.normal,
//       //         color: Colors.grey.shade600,
//       //       ),
//       //     )
//       //   ],
//       // ),
//       description: deliveryVehicle.name,
//       bottom: RaisedActionButton(
//         label: 'Buy Now',
//         onPressed: () => navigateTo(
//           context,
//           DumpsterOrderSelectionPage(deliveryVehicle),
//         ),
//       ),
//     );
//   }
// }
