import 'dart:io';

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
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati/src/utils/phone-verification.dart';
import 'package:haweyati/src/utils/simple-future-builder.dart';
import 'package:haweyati_client_data_models/data.dart';
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
        Padding(
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
              TotalPriceRow(value)
            ]);
          },
        ),
        RewardPointsSelection(order,notifier)
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
              if(guestPhone !=null || guestPhone.isNotEmpty)
                //TODO
                verify = true;
                // verify = await verifyPhoneNumber(context, guestPhone);
              else
                verify = await getVerifiedPhoneNumber(context);

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
                //TODO
                // final verify = await verifyPhoneNumber(context,AppData().user.profile.contact);
                final verify = true;
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
              //TODO
              final verify = true;
              // final verify = await verifyPhoneNumber(context, number);
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
              final verify = true;
              //TODO
              // final verify = await verifyPhoneNumber(context, number);
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
          _appData.user.points = _order.customer.points;
            await _appData.user.save();
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
            await HaweyatiService.patch('orders/add-image', FormData.from({
              'id': _order.id,
              'image' : UploadFileInfo(File(order.image.path), order.image.path),
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
    valueNotifier.value = value;
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

  @override
  void initState() {
    super.initState();
    rewardsFuture = Dio().get(apiUrl + '/unit/point-value');
    notifier = widget.notifier;
  }

  @override
  Widget build(BuildContext context) {
    return (AppData().user.points > 0) ? SimpleFutureBuilder.simpler(
      context: context,
      future: rewardsFuture,
      builder: (AsyncSnapshot snapshot){
        double sarVal = double.tryParse(snapshot.data.toString());
        return CheckboxListTile(dense: true,
            controlAffinity: ListTileControlAffinity.leading,
            title: snapshot.data!=null ? Text("Use ${AppData().user.points}  Reward Points ( ${ (sarVal * AppData().user.points).toStringAsFixed(2) } SAR )") : SizedBox(),
            value: widget.order.rewardPointsValue !=null, onChanged: (bool value){
          setState(() {
            if(value){
              double sarRewardValue =  sarVal * AppData().user.points;
              if(sarRewardValue >= widget.order.total){
                widget.order.rewardPointsValue = widget.order.total;
                widget.order.total= 0;
                notifier.changeOrderTotal(0);
              } else {
                widget.order.rewardPointsValue = sarRewardValue;
                notifier.changeOrderTotal(widget.order.total-sarRewardValue);
              }
            } else {
              notifier.changeOrderTotal(widget.order.total);
            }
          });
        });
      },
    ) : SizedBox();
  }
}


Future<PaymentResponse> selectPayment(
  BuildContext context,
  double payment,
) async =>
    (await navigateTo(context, PaymentMethodPage(amount: payment.round())))
        as PaymentResponse;

verifyLocation() {}
