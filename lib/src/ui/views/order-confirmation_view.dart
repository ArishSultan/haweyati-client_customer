import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/common/modals/confirmation-dialog.dart';
import 'package:haweyati/src/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:haweyati/src/rest/_new/auth_service.dart';
import 'package:haweyati/src/rest/haweyati-service.dart';
import 'package:haweyati/src/rest/orders_service.dart';
import 'package:haweyati/src/ui/modals/dialogs/order/unable-to-place-order_dialog.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/pages/auth/sign-in_page.dart';
import 'package:haweyati/src/ui/pages/orders/order-placed_page.dart';
import 'package:haweyati/src/ui/pages/payment/payment-methods_page.dart';
import 'package:haweyati/src/ui/snack-bars/payment/not-selected_snack-bar.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/ui/widgets/details-table.dart';
import 'package:haweyati/src/ui/widgets/location-picker.dart';
import 'package:haweyati/src/ui/widgets/table-rows.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';
import 'package:haweyati/src/utils/lazy_task.dart';
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati/src/utils/phone-verification.dart';
import 'package:haweyati/src/utils/simple-future-builder.dart';
import 'package:haweyati/src/utils/validations.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:haweyati_client_data_models/models/coupon-model.dart';
import 'package:haweyati_client_data_models/utils/toast_utils.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'header_view.dart';
import 'order-location_view.dart';

typedef OrderConfirmationBuilder<T extends OrderableProduct> = List<Widget>
    Function(AppLocalizations, Order<T>);

class OrderConfirmationView<T extends OrderableProduct>
    extends StatelessWidget {
  final Order<T> order;
  final OrderConfirmationBuilder<T> itemsBuilder;
  final OrderConfirmationBuilder<T> pricingBuilder;

  OrderConfirmationView({
    @required this.order,
    @required this.itemsBuilder,
    @required this.pricingBuilder,
  })  : assert(order != null),
        assert(itemsBuilder != null),
        assert(pricingBuilder != null),
        notifier = TotalNotifier(order);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TotalNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    final items = itemsBuilder(lang, order);
    final pricing = pricingBuilder(lang, order);

    return ScrollableView(
      key: _scaffoldKey,
      appBar: HaweyatiAppBar(progress: .75, confirmOrderCancel: true),
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
      showBackground: true,
      children: [
        HeaderView(
          title: lang.orderConfirmationPageTitle,
          subtitle: lang.orderConfirmationPageSubtitle,
        ),
        ...items,
      if(order.type != OrderType.finishingMaterial)  Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: OrderLocationView(
            location: order.location,
            onEdit: Navigator.of(context).pop,
          ),
        ),
        ...pricing,
        DetailsTable([
          PriceRow('Subtotal', order.subtotal),
        ]),
        Divider(),
        if(order.type == OrderType.scaffolding || order.type == OrderType.buildingMaterial) DetailsTable([
          TableRow(
            children: [
              Text(
                "Delivery Fee",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontFamily: 'Lato',
                  height: 1.9,
                ),
              ),
              Text('Pending',
                style: TextStyle(
                  color: Color(0xFF313F53),
                  fontSize: 14,
                  fontFamily: 'Lato',
                ),
                textAlign: TextAlign.right,
              )
            ]
          )
        ]),
        ValueListenableBuilder(
          valueListenable: notifier.valueNotifier,
          builder: (context,value,child){
            return DetailsTable([
              PriceRow('Value Added Tax (VAT) ( ${Order.vatVal} %) ', order.vat),
              if(order.rewardPointsValue !=null)  PriceRow('Reward Points Value ', order.rewardPointsValue),
              if(order.couponValue !=null)  PriceRow('Discount (${order.coupon}) ', order.couponValue),
              TotalPriceRow(value)
            ]);
          },
        ),
       if(AppData().isAuthenticated) RewardPointsSelection(order,notifier)
      ],
      bottom: RaisedActionButton(
        label: 'Proceed',
        onPressed: () async {
          final location = await showDialog(
              context: context,
              builder: (context) => ConfirmationDialog(
                    title: Text('Confirm your Location'),
                    content: OrderLocationPicker(order, true),
                  ));

          if (location != true) return;

          if (order.payment == null) {
            if(order.type != OrderType.scaffolding && order.type != OrderType.buildingMaterial && order.type != OrderType.finishingMaterial){
              final result = await selectPayment(context, order.total);
              if (result == null) {
                _scaffoldKey.currentState
                    .showSnackBar(PaymentMethodNotSelectedSnackBar());
                return;
              } else {
                order.paymentType = result.method;
                order.paymentIntentId = result.intentId;
              }
            }
          }

          showDialog(
            context: context,
            builder: (context) => WaitingDialog(message: 'Verifying Customer'),
          );
          final _appData = AppData();
          print("Auth status ${_appData.isAuthenticated}");
          if (_appData.isAuthenticated) {
            if (_appData.user.profile.hasScope('guest')) {
              var guestPhone = _appData.user.profile.contact;

              var verify;
              if(guestPhone !=null || guestPhone.isNotEmpty) {
                //TODO
                if (isDebugMode)
                  verify = true;
                else
                  verify = await verifyPhoneNumber(context, guestPhone);
              }
              else{
                verify = await getVerifiedPhoneNumber(context);
              }

              print('section 1');

              if (verify == null) {
                Navigator.of(context).pop();
                // _scaffoldKey.currentState.showSnackBar(SnackBar(
                //     content: Text('Phone Number not verified')
                // ));
                return;
              }
              order.customer = _appData.user;
            } else {
              if (order.paymentType == 'COD') {
                print('section 2');

                //TODO
                var verify;
                if(isDebugMode) verify = true;
                else verify = await verifyPhoneNumber(context,AppData().user.profile.contact);
                if(verify == null) {
                  Navigator.pop(context);
                  return;
                }
              }
              order.customer = _appData.user;
            }
          } else {
            final number = await getPhoneNumber(context);
            if (number == null) {
              Navigator.pop(context);
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('You need to verify phone number to proceed with order.'),
              ));
              return;
            }

            final result =
            await AuthService.prepareForRegistration(context, number);

            if (result[0] == CustomerRegistrationType.new_) {
              print('section 3');

              var verify;
              if(isDebugMode) verify = true;
              else
                verify = await verifyPhoneNumber(context, number);
              if (verify == null) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Phone Number not verified')
                ));
                Navigator.pop(context);
                return;
              }

              showDialog(
                context: context,
                builder: (context) =>
                    WaitingDialog(message: 'Registering Guest'),
              );

              final _guest = await AuthService.createGuest(
                Customer()
                  ..profile = Profile(contact: number)
                  ..location = _appData.location,
              );
              AppData().user = _guest;
              order.customer = _guest;
            } else if (result[0] == CustomerRegistrationType.fromGuest) {
              print('section 4');

              var verify;
              if(isDebugMode) verify = true;
              else verify = await verifyPhoneNumber(context, number);
              if (verify == null) {
                Navigator.pop(context);
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Phone Number not verified')
                ));
                return;
              }

              showDialog(
                context: context,
                builder: (context) =>
                    WaitingDialog(message: 'Registering Guest'),
              );

              order.customer = await AuthService.getCustomer(number);
              _appData.user = order.customer;
            } else if (result[0] == CustomerRegistrationType.fromExisting ||
                result[0] == CustomerRegistrationType.noNeed) {
              await navigateTo(context, SignInPage());
              if (_appData.isAuthenticated) {
                order.customer = _appData.user;
              } else {
                Navigator.of(context).pop();
                return;
              }
            }
          }
          Navigator.of(context).pop();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => WaitingDialog(message: 'Placing your order'),
          );

          Order _order;
          try {
            // order.vat = order.subtotal * Order.vatVal;
          _order = await OrdersService().placeOrder(order);
          var customer = _order.customer;
            AppData().user = customer;
            print("Points after order placement ${AppData().user.points}");
            await Hive.openBox('supplier').then((value) async {
             await value.clear();
             await value.close();
            });

            if(order.type == OrderType.finishingMaterial){
              try{
                Hive.lazyBox<FinishingMaterial>('cart').clear();
              } catch (e) {

              }
            }
            order.clearProducts();
            if(order.image !=null)
            await HaweyatiService.patch('orders/add-image', FormData.fromMap({
              'id': _order.id,
              'image' : await MultipartFile.fromFile(order.image.path),
              'sort' : 'customer'
            }));
            Navigator.of(context).pop();
          } catch (e) {
            print(e);
            if(Navigator.canPop(context))
            Navigator.of(context).pop();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => UnableToPlaceOrderDialog(e),
            );
            return;
            throw e;
          }

          if (_order != null) {
            navigateTo(context, OrderPlacedPage(_order, () async {}));
          }
        }
      )
    );
  }
}

class TotalNotifier {
  final Order order;
  ValueNotifier valueNotifier;

   TotalNotifier(this.order){
    this.valueNotifier = ValueNotifier(order.total);
  }

  void changeOrderTotal(double value) {
    // order.total = value;
    valueNotifier.value = order.total;
  }

  @override
  void dispose() {
    valueNotifier.dispose();
  }


}


class RewardPointsSelection extends StatefulWidget {
  final Order order;
  final TotalNotifier notifier;
  RewardPointsSelection(this.order,this.notifier);
  @override
  _RewardPointsSelectionState createState() => _RewardPointsSelectionState();
}

class _RewardPointsSelectionState extends State<RewardPointsSelection> {

  Future rewardsFuture;
  TotalNotifier notifier;
  bool hasDiscountCode = false;
  var discountCode = TextEditingController();
  bool discountCodeApplied = false;

  @override
  void initState() {
    super.initState();
    rewardsFuture = AppData().rewardPointSarValue;
    notifier = widget.notifier;
  }

  @override
  void dispose() {
    print("dispose called");
    widget.order.rewardPointsValue = null;
    widget.order.couponValue=null;
    widget.order.coupon=null;
    notifier.changeOrderTotal(widget.order.total);
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
         if(!hasDiscountCode && AppData().user.points > 0) SimpleFutureBuilder<double>.simpler(
           context: context,
           future: rewardsFuture,
           builder: (double snapshot){
             double sarVal = double.tryParse(snapshot.toString());
             return CheckboxListTile(dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: snapshot!=null ? Text("Use ${AppData().user.points}  Reward Points ( ${ (sarVal * AppData().user.points).toStringAsFixed(2) } SAR )") : SizedBox(),
                  value: widget.order.rewardPointsValue !=null, onChanged: (bool value){
                 setState(() {
                  if(value) {
                    final requiredPoints = widget.order.total;
                    final currentPoints = sarVal * AppData().user.points;
                    print('required points: ' + requiredPoints.toString());
                    print('current points: ' + currentPoints.toString());

                    if (requiredPoints <= currentPoints) {
                      widget.order.rewardPointsValue = requiredPoints;
                    } else {
                      widget.order.rewardPointsValue = currentPoints;
                    }
                  } else {
                    widget.order.rewardPointsValue = null;
                  }

                    notifier.changeOrderTotal(widget.order.total);
                 });
           });},
         ),

          if(widget.order.rewardPointsValue == null && widget.order.coupon == null)  CheckboxListTile(dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("Have Discount Code?") ,
                value: hasDiscountCode, onChanged: (bool value){
                  setState(() {
                      hasDiscountCode = value;
                  });
                }),
           if(hasDiscountCode && widget.order.coupon == null) HaweyatiTextField(
              label: 'Discount Code',
              controller: discountCode,
              validator: (value)=> emptyValidator(value, 'Discount Code'),
              onSaved: (val)=> discountCode.text = val,
            ),
          if(hasDiscountCode && widget.order.coupon == null)  TextButton(onPressed: () async {
            if(discountCode.text.isEmpty) {
              showErrorToast("Please input discount code");
            } else {
              await performLazyTask(context, () async {
                var res;
                try{
                  res =  await HaweyatiService.post('coupons/check-coupon-validity', {
                    'code' : discountCode.text,
                    'user' : AppData().user.id
                  });
                  Coupon coupon = Coupon.fromJson(res.data);

                  showSuccessToast("Discount Code Applied");
                  widget.order.coupon = coupon.code;
                  widget.order.couponValue = widget.order.total * coupon.value / 100;
                  notifier.changeOrderTotal(widget.order.total);
                } catch (e){

                }
              },message: 'Applying Discount Code');
            }
          }, child: Text("Apply")),
            if(hasDiscountCode && widget.order.coupon != null)
              ListTile(dense: true,
                leading: Icon(CupertinoIcons.check_mark_circled_solid,color: Colors.green,),
                title: Text("Discount Code (${widget.order.coupon}) Applied"),
              )
          ],
        );
  }
}


Future<PaymentResponse> selectPayment(
  BuildContext context,
  double payment,
) async =>
    (await navigateTo(context, PaymentMethodPage(amount: payment.round())))
        as PaymentResponse;

verifyLocation() {}
