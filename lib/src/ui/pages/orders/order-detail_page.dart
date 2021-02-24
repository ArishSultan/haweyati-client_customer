import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:haweyati/l10n/app_localizations.dart';
import 'package:haweyati/src/common/modals/confirmation-dialog.dart';
import 'package:haweyati/src/common/modals/util.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/orders_service.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/views/location-tracking_view.dart';
import 'package:haweyati/src/ui/views/order-confirmation_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/ui/widgets/details-table.dart';
import 'package:haweyati/src/ui/widgets/pickup-location_picker.dart';
import 'package:haweyati/src/ui/widgets/rate-bottom-sheet.dart';
import 'package:haweyati/src/ui/widgets/table-rows.dart';
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/rest/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/rich-price-text.dart';
import 'package:haweyati/src/ui/pages/orders/my-orders_page.dart';
import 'package:haweyati_client_data_models/models/order/products/delivery-vehicle_orderable.dart';
import 'package:haweyati_client_data_models/models/order/products/single-scaffolding_orderable.dart';
import 'package:haweyati_client_data_models/widgets/variants-tablerow.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
class OrderDetailPage extends StatefulWidget {
  final Order order;

  OrderDetailPage(this.order);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Order order;
  bool canCancel = false;
  bool awaitingPayment = false;
  bool isAwaitingSupplier = false;
  bool isAwaitingDriver = false;
  static bool hasSupplierSelectedItems = false;

  @override
  void initState() {
    super.initState();
    order = widget.order;
    hasSupplierSelectedItems = order.type == OrderType.finishingMaterial ? order.products.any((e) => (e.item as FinishingMaterialOrderable).selected == true) : false;

    canCancel = order.status == OrderStatus.pending ||
        order.status == OrderStatus.accepted || order.driver==null;

    awaitingPayment = order.type == OrderType.finishingMaterial ?
    (order.deliveryFee != null && order.paymentType == null
        && hasSupplierSelectedItems) : order.deliveryFee != null
        && order.paymentType == null;

     isAwaitingSupplier =order.deliveryFee == null &&
          order.status == OrderStatus.pending &&
          order.type != OrderType.deliveryVehicle;
     isAwaitingDriver = order.deliveryFee == null &&
          order.status == OrderStatus.accepted &&
          order.type != OrderType.deliveryVehicle &&
          order.type != OrderType.buildingMaterial;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableView.sliver(
      fab: order.status == OrderStatus.delivered && order.rating == null ?
      FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: Text("Rate",style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),textAlign: TextAlign.center,),
        onPressed: () async {
         await showModalBottomSheet(
             context: context, builder: (ctx){
            return RatingBottomSheet(order);
          },isScrollControlled: true
          );
        },
      ) : (order.shareUrl !=null) ? FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: Text("Track Driver",style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),textAlign: TextAlign.center,),
        onPressed: () async {
          navigateTo(context, LiveTrackingView(order));
        },
      ) : null,
      showBackground: true,
      padding: EdgeInsets.fromLTRB(15, 0, 15,
          (isAwaitingSupplier
          || awaitingPayment ||
          isAwaitingDriver) ? 20 : 20),
      appBar: HaweyatiAppBar(actions: [

        IconButton(
          icon: Image.asset(CustomerCareIcon, width: 20),
          onPressed: () => Navigator.of(context).pushNamed(HELPLINE_PAGE),
        ),
      ]),
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
            children: [
              awaitingPayment
                  ?  FlatActionButton(
                  label: 'Proceed Payment',
                  onPressed: () async {
                    if(widget.order.type == OrderType.finishingMaterial && widget.order.products.length > 1) {
                   bool reviewed =  await showConfirmationDialog(
                        context: context,
                        builder: (ctx) => ConfirmationDialog(
                        title: Text("Have you reviewed the items availability?"),
                        )
                      );
                   if(!reviewed ?? true) return;
                    }
                    var order = widget.order;
                    final result = await selectPayment(context, order.total);
                    if (result == null) {
                      //Todo: Snackbar
                      // Scaffold.of(context)
                      //     .showSnackBar(PaymentMethodNotSelectedSnackBar());
                      return;
                    } else {
                      order.paymentType = result.method;
                      order.paymentIntentId = result.intentId;
                    }

                    showDialog(
                        context: context,
                        builder: (context) {
                          return WaitingDialog(
                            message: 'Processing order',
                          );
                        });

                    await OrdersService().processPayment({
                      '_id': order.id,
                      'paymentType': order.paymentType,
                      'paymentIntentId': order.paymentIntentId,
                    });

                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ) : isAwaitingSupplier || isAwaitingDriver
                  ? FlatActionButton(
                  padding: EdgeInsets.only(left:20,right:20,bottom: 5),
                  label: "Order is awaiting confirmation from ${isAwaitingSupplier ? 'Supplier' : "Driver"}")
                  : SizedBox(),
           if(canCancel) FlatActionButton(
             padding: EdgeInsets.only(left:20,right:20,bottom: 5),
             icon: Icon(Icons.block),
                label: 'Cancel Order',
              onPressed: () async {
                bool confirmed = await showDialog(
                    context: context,
                    builder: (context) {
                      return ConfirmationDialog(
                        title:
                        Text("Are you sure, you want to cancel this order?"),
                      );
                    });
                if (confirmed ?? false) {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          WaitingDialog(message: 'Canceling Order'));
                  await OrdersService().cancelOrder(widget.order.id);
                  widget.order.status = OrderStatus.canceled;
                  Navigator.of(context).pop();
                  setState(() {});
                }
              },)
            ],
          ),
      children: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 0),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: SizedBox(
                width: 360,
                child: _OrderDetailHeader(widget.order.status),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: OrderMeta(widget.order)),
        if (order.type == OrderType.deliveryVehicle)
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 15, top: 15),
            sliver: SliverToBoxAdapter(
              child: PickUpLocationPicker(order.products.first.item, false),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 15, top: 0),
          sliver: SliverToBoxAdapter(
            child: DropOffLocation(order.location),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                _OrderProductWidget(widget.order.products[index],hasSupplierSelectedItems),
            childCount: widget.order.products.length,
          ),
        ),
        SliverToBoxAdapter(
          child: Table(
            textBaseline: TextBaseline.alphabetic,
            defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
            children: [
              TableRow(children: [
                Text(
                  'Sub Total',
                  style: TextStyle(
                    height: 2,
                    fontSize: 13,
                    fontFamily: 'Lato',
                    color: Colors.grey.shade600,
                  ),
                ),
                RichPriceText(
                  price: order.totalWithoutVat - (order.totalWithoutVat * .15),
                  fontSize: 13,
                )
              ]),
              TableRow(children: [
                Text(
                  'VAT (15%)',
                  style: TextStyle(
                    height: 2,
                    fontSize: 13,
                    fontFamily: 'Lato',
                    color: Colors.grey.shade600,
                  ),
                ),
                RichPriceText(
                  price: order.subtotal * 0.15,
                  fontSize: 13,
                )
              ]),
              if (order.deliveryFee != null)
                TableRow(children: [
                  Text(
                    'Delivery Fee',
                    style: TextStyle(
                      height: 2,
                      fontSize: 13,
                      fontFamily: 'Lato',
                      color: Colors.grey.shade600,
                    ),
                  ),
                  RichPriceText(
                    price: order.deliveryFee,
                    fontSize: 13,
                  )
                ]),
            ],
          ),
        ),
        SliverToBoxAdapter(child: Divider()),
        SliverToBoxAdapter(
          child: Table(
              children: [
                TableRow(children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      height: 2,
                      fontSize: 13,
                      fontFamily: 'Lato',
                      color: Colors.grey.shade600,
                    ),
                  ),
                  RichPriceText(
                    price: order.totalWithoutVat,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )
                ])
              ],
              textBaseline: TextBaseline.alphabetic,
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 15,),),
        if(order.supplier!=null ) personBuilder(type: 'Supplier',image: order.supplier?.person?.image?.name,name: order.supplier.person.name,contact: order.supplier.person.contact),
        if(order.driver!=null) personBuilder(type: 'Driver',image: order.driver?.profile?.image?.name,name: order.driver.profile.name,contact: order.driver.profile.contact),

      ],
    );
  }
}

Widget personBuilder({String type,String image,String name,String contact}){
  return SliverToBoxAdapter(
    child: DarkContainer(
      margin: const EdgeInsets.only(bottom: 10,top: 0),
      padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(type,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14
          ),),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Color(0xEEFFFFFF),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 1,
                        color: Colors.grey.shade500
                    )
                  ],
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: image !=null? NetworkImage(HaweyatiService.resolveImage(image))
                          : AssetImage("assets/images/app-logo.png")
                  )
              ),
            ),
            title: Text(name, style: TextStyle()),
            subtitle: Text(contact, style: TextStyle()),
            trailing: Padding(
              padding: const EdgeInsets.only(bottom:10.0),
              child: FlatButton.icon(
                  minWidth: 30,
                  color: Color(0xFFFF974D),
                  label: SizedBox(),
                  shape: CircleBorder(),
                  icon: Padding(
                    padding: const EdgeInsets.only(left:12.0),
                    child: Icon(CupertinoIcons.phone_fill,size: 20,color: Colors.white,),
                  ), onPressed: () async {
                launch("tel:${contact}");
              }),
            ),
          )
        ],),
    ),
  );
}

class _OrderProductWidget extends StatelessWidget {
  final OrderProductHolder holder;
  final bool hasSupplierSelectedItems;
  _OrderProductWidget(this.holder,[this.hasSupplierSelectedItems=false]);

  Widget _buildFinishingMaterial(
    BuildContext context,
    FinishingMaterialOrderable item,
  ) {
    return Table(
        children: [
          ...buildVariants(item.variants),
          DetailRow('Quantity', AppLocalizations.of(context).nProducts(item.qty),false),
          PriceRow('Price', item.price),
          PriceRow('Total', item.price),
          TableRow(children: [
            Text(
              'Total',
              style: TextStyle(
                height: 2.5,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            RichPriceText(price: holder.subtotal, fontWeight: FontWeight.bold)
          ])
        ],
        textBaseline: TextBaseline.alphabetic,
        defaultVerticalAlignment: TableCellVerticalAlignment.baseline);
  }

  @override
  Widget build(BuildContext context) {
    final qty = _qty(holder);

    return DarkContainer(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        OrderProductTile(holder,hasSupplierSelectedItems),
        if (holder.item is DumpsterOrderable)
          DetailsTable([
            DetailRow('Quantity',
                (holder.item as DumpsterOrderable).qty.toString(), false),
            DetailRow('Extra Days',
                (holder.item as DumpsterOrderable).extraDays.toString(), false),
            PriceRow('Extra Days Price',
                (holder.item as DumpsterOrderable).extraDaysPrice),
          ]),
        if (holder.item is DeliveryVehicleOrderable)
          DetailsTable([
            DetailRow(
                'Quantity',
                (holder.item as DeliveryVehicleOrderable).qty.toString(),
                false),
            DetailRow(
                'Distance',
                (holder.item as DeliveryVehicleOrderable).distance.toString() +
                    "km",
                false),
            PriceRow(
                'Price Per Km',
                (holder.item as DeliveryVehicleOrderable)
                    .product
                    .deliveryCharges),
          ]),
        if (holder.item is BuildingMaterialOrderable)
          DetailsTable([
            DetailRow(
                'Quantity',
                (holder.item as BuildingMaterialOrderable).qty.toString(),
                false),
          ]),
        if (holder.item is SingleScaffoldingOrderable)
          Table(children: [
            TableRow(children: [
              Text("Quantity",
                  style: TextStyle(
                    height: 1.6,
                    fontSize: 13,
                    color: Colors.grey,
                  )),
              Text(
                '${(holder.item as SingleScaffoldingOrderable).qty}',
                textAlign: TextAlign.right,
                style: TextStyle(color: Color(0xFF313F53)),
              )
            ]),
            TableRow(children: [
              Text("Days",
                  style: TextStyle(
                    height: 1.6,
                    fontSize: 13,
                    color: Colors.grey,
                  )),
              Text(
                '${(holder.item as SingleScaffoldingOrderable).days}',
                textAlign: TextAlign.right,
                style: TextStyle(color: Color(0xFF313F53)),
              )
            ]),
            TableRow(children: [
              Text("Wheels (Set of 4)",
                  style: TextStyle(
                    height: 1.6,
                    fontSize: 13,
                    color: Colors.grey,
                  )),
              Text(
                '${(holder.item as SingleScaffoldingOrderable).wheels}',
                textAlign: TextAlign.right,
                style: TextStyle(color: Color(0xFF313F53)),
              )
            ]),
            TableRow(children: [
              Text("Connections (Set of 4)",
                  style: TextStyle(
                    height: 1.6,
                    fontSize: 13,
                    color: Colors.grey,
                  )),
              Text(
                '${(holder.item as SingleScaffoldingOrderable).connections}',
                textAlign: TextAlign.right,
                style: TextStyle(color: Color(0xFF313F53)),
              )
            ]),
            if ((holder.item as dynamic).mesh != null)
              TableRow(children: [
                Text("Mesh",
                    style: TextStyle(
                      height: 1.6,
                      fontSize: 13,
                      color: Colors.grey,
                    )),
                Text(
                  '${(holder.item as SingleScaffoldingOrderable).mesh} (Quantity: ${(holder.item as SingleScaffoldingOrderable).meshQty})',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Color(0xFF313F53)),
                )
              ]),
            // TableRow(children: [
            //   Text(lang.price, style: TextStyle(
            //     height: 1.6,
            //     fontSize: 13,
            //     color: Colors.grey,
            //   )),
            //
            //   RichPriceText(price: (holder.item as SingleScaffoldingOrderable))
            // ]),
          ], defaultVerticalAlignment: TableCellVerticalAlignment.baseline),
        if (holder.item is FinishingMaterialOrderable)
          _buildFinishingMaterial(context, holder.item)
        else
          DetailsTable([
            // DetailRow('Quantity', AppLocalizations.of(context).nProducts(qty)),
            PriceRow('Price', holder.subtotal / qty),
            PriceRow('Total', holder.subtotal),
          ]),
      ]),
    );
  }

  static int _qty(OrderProductHolder holder) {
    if (holder.item is BuildingMaterialOrderable) {
      return (holder.item as BuildingMaterialOrderable).qty;
    } else if (holder.item is DumpsterOrderable) {
      return (holder.item as DumpsterOrderable).qty;
    }

    return 1;
  }
}

class OrderProductTile extends StatelessWidget {
  final OrderProductHolder item;
  final bool hasSupplierSelectedItems;

  OrderProductTile(this.item,[this.hasSupplierSelectedItems=false]);

  @override
  Widget build(BuildContext context) {
    String title;
    String imageUrl;
    String imagePath;
    dynamic product = item.item.product;
    bool isItemSelected;
    if (item.item is DumpsterOrderable) {
      title = '${product.size} Yards';
      imageUrl = product.image.name;
    } else if (item.item is BuildingMaterialOrderable) {
      title = product.name + " (${(item.item as dynamic).price.unit})";
      imageUrl = product.image.name;
    } else if (item.item is FinishingMaterialOrderable) {
      title = product.name;
      imageUrl = product.image.name;
      isItemSelected = (item.item as FinishingMaterialOrderable).selected;
    } else if (item.item is SingleScaffoldingOrderable) {
      title = product.type;
      imagePath = "assets/images/singleScaffolding.png";
    } else if (item.item is DeliveryVehicleOrderable) {
      title = product.name;
      imageUrl = product.image.name;
    }

    return ListTile(
      contentPadding: const EdgeInsets.only(bottom: 15),
      leading: Container(
        width: 60,
        decoration: BoxDecoration(
            color: Color(0xEEFFFFFF),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  blurRadius: 5, spreadRadius: 1, color: Colors.grey.shade500)
            ],
            image: DecorationImage(
                fit: BoxFit.contain,
                image: imagePath == null
                    ? NetworkImage(HaweyatiService.resolveImage(imageUrl))
                    : AssetImage(imagePath))),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      trailing: (item.item is FinishingMaterialOrderable && hasSupplierSelectedItems) ?
      Icon( isItemSelected ? Icons.done : Icons.close,color:  isItemSelected ? Colors.green : Colors.red,)  : null,
    );
  }
}


class _OrderDetailHeader extends StatelessWidget {
  final OrderStatus status;

  _OrderDetailHeader(this.status);

  Widget build(BuildContext context) {
    return Container(
      height: 65,
      child: Stack(
        children: [
          CustomPaint(painter: _OrderStatusPainter(status.index)),
          Positioned(
            left: 30,
            top: 10,
            child: Icon(Icons.done_all, size: 20, color: Colors.white),
          ),
          Positioned(
            top: 7,
            left: 95,
            child: Image.asset(CartIcon, width: 28, color: Colors.white,),
          ),
          Positioned(
            top: 9,
            left: 169,
            child: Image.asset(SettingsIcon, width: 22, color: Colors.white,),
          ),
          Positioned(
            top: 7,
            left: 237,
            child: Image.asset(TruckIcon, width: 28, color: Colors.white,),
          ),
          Positioned(
            left: 310,
            top: 9,
            child: Image.asset(HomeIcon, width: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _OrderStatusPainter extends CustomPainter {
  final int progress;

  _OrderStatusPainter(this.progress);

  static TextPainter _genText(String text) {
    return TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
      textDirection: ui.TextDirection.ltr,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final xOffset1 = 40.0;
    final xOffset2 = 110.0;
    final xOffset3 = 180.0;
    final xOffset4 = 250.0;
    final xOffset5 = 320.0;

    final txt1 = _genText('Order Placed')..layout();
    final txt2 = _genText('Accepted')..layout();
    final txt3 = _genText('Preparing')..layout();
    final txt4 = _genText('Dispatched')..layout();
    final txt5 = _genText('Delivered')..layout();

    final _donePainter = Paint()
      ..color = Color(0xFFFF974D)
      ..strokeWidth = 1;

    final _unDonePainter = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    txt1.paint(canvas, Offset(xOffset1 - txt1.width / 2, 50));
    txt2.paint(canvas, Offset(xOffset2 - txt2.width / 2, 50));
    txt3.paint(canvas, Offset(xOffset3 - txt3.width / 2, 50));
    txt4.paint(canvas, Offset(xOffset4 - txt4.width / 2, 50));
    txt5.paint(canvas, Offset(xOffset5 - txt5.width / 2, 50));

    canvas.drawLine(Offset(xOffset1, 20), Offset(xOffset2, 20),
        progress > 0 ? _donePainter : _unDonePainter);
    canvas.drawLine(Offset(xOffset2, 20), Offset(xOffset3, 20),
        progress > 2 ? _donePainter : _unDonePainter);
    canvas.drawLine(Offset(xOffset3, 20), Offset(xOffset4, 20),
        progress > 4 ? _donePainter : _unDonePainter);
    canvas.drawLine(Offset(xOffset4, 20), Offset(xOffset5, 20),
        progress > 5 ? _donePainter : _unDonePainter);

    canvas.drawCircle(Offset(xOffset1, 20), 20,
        progress >= 0 ? _donePainter : _unDonePainter);
    canvas.drawCircle(Offset(xOffset2, 20), 20,
        progress >= 1 ? _donePainter : _unDonePainter);
    canvas.drawCircle(Offset(xOffset3, 20), 20,
        progress >= 2 ? _donePainter : _unDonePainter);
    canvas.drawCircle(Offset(xOffset4, 20), 20,
        progress >= 3 ? _donePainter : _unDonePainter);
    canvas.drawCircle(Offset(xOffset5, 20), 20,
        progress >= 4 ? _donePainter : _unDonePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// class _OrderStatusPainter extends CustomPainter {
//   final int progress;
//   _OrderStatusPainter(this.progress);
//
//   static TextPainter _genText(String text) {
//     return TextPainter(
//         text: TextSpan(
//             text: text,
//             style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
//         textDirection: TextDirection.ltr);
//   }
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final xOffset1 = 40.0;
//     final xOffset2 = 120.0;
//     final xOffset3 = 200.0;
//     final xOffset4 = 280.0;
//
//     final txt1 = _genText('Order Placed')..layout();
//     final txt2 = _genText('Preparing')..layout();
//     final txt3 = _genText('Dispatched')..layout();
//     final txt4 = _genText('Delivered')..layout();
//
//     final _donePainter = Paint()
//       ..color = Color(0xFFFF974D)
//       ..strokeWidth = 1;
//
//     final _unDonePainter = Paint()
//       ..color = Colors.grey.shade300
//       ..strokeWidth = 1;
//
//     txt1.paint(canvas, Offset(xOffset1 - txt1.width / 2, 50));
//     txt2.paint(canvas, Offset(xOffset2 - txt2.width / 2, 50));
//     txt3.paint(canvas, Offset(xOffset3 - txt3.width / 2, 50));
//     txt4.paint(canvas, Offset(xOffset4 - txt4.width / 2, 50));
//
//     canvas.drawLine(Offset(xOffset1, 20), Offset(xOffset2, 20),
//         progress > 1 ? _donePainter : _unDonePainter);
//     canvas.drawLine(Offset(xOffset2, 20), Offset(xOffset3, 20),
//         progress > 2 ? _donePainter : _unDonePainter);
//     canvas.drawLine(Offset(xOffset3, 20), Offset(xOffset4, 20),
//         progress > 3 ? _donePainter : _unDonePainter);
//
//     canvas.drawCircle(
//         Offset(xOffset1, 20), 20, progress > 0 ? _donePainter : _unDonePainter);
//     canvas.drawCircle(
//         Offset(xOffset2, 20), 20, progress > 1 ? _donePainter : _unDonePainter);
//     canvas.drawCircle(
//         Offset(xOffset3, 20), 20, progress > 2 ? _donePainter : _unDonePainter);
//     canvas.drawCircle(
//         Offset(xOffset4, 20), 20, progress > 3 ? _donePainter : _unDonePainter);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }


class DropOffLocation extends StatelessWidget {
  final OrderLocation location;
  DropOffLocation(this.location);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationPicker(onChanged: null,initialValue: location),
        if(location.dropOffTime != null)  DarkContainer(
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 11),
                    child: _Title('Drop-off Date'),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 17),
                    child: _Title('Drop-off Time'),
                  ),
                ),
              ]),
              Row(children: [
                Expanded(
                  child: DarkContainer(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            DateFormat(DateFormat.YEAR_MONTH_DAY).format(location.dropOffDate),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        Image.asset(CalendarIcon, width: 25),
                      ]),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: DarkContainer(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            location.dropOffTime.from.format(context) + '  -  ' + location.dropOffTime.to.format(context),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        Image.asset(ClockIcon, width: 25),
                      ]),
                    ),
                  ),
                ),
              ]),
            ],
          ),)],
    );
  }
}

class _Title extends Text {
  _Title(String title)
      : super(
    title,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
    ),
  );
}