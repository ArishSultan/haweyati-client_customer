import 'package:flutter/material.dart';
import 'package:haweyati/l10n/app_localizations.dart';
import 'package:haweyati/src/common/modals/confirmation-dialog.dart';
import 'package:haweyati/src/rest/_new/auth_service.dart';
import 'package:haweyati/src/rest/orders_service.dart';
import 'package:haweyati/src/ui/modals/dialogs/order/unable-to-place-order_dialog.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/pages/auth/sign-in_page.dart';
import 'package:haweyati/src/ui/pages/orders/order-placed_page.dart';
import 'package:haweyati/src/ui/pages/otp-page.dart';
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
import 'package:haweyati_client_data_models/data.dart';

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
        assert(pricingBuilder != null);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        DetailsTable([
          PercentRow('Value Added Tax (VAT)', Order.vat),
          TotalPriceRow(order.total)
        ])
      ],
      bottom: RaisedActionButton(
        label: 'Proceed',
        onPressed: () async {
          final location = await showDialog(
              context: context,
              builder: (context) => ConfirmationDialog(
                    title: Text('Confirm our Location'),
                    content: OrderLocationPicker(order, true),
                  ));

          if (location != true) return;

          if (order.payment == null) {
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
                verify = await verifyPhoneNumber(context, guestPhone);
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
                final verify = await verifyPhoneNumber(context,AppData().user.profile.contact);
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
              final verify = await verifyPhoneNumber(context, number);
              if (verify == null) {
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

              final _guest = await AuthService.createGuest(
                Customer()
                  ..profile = Profile(contact: number)
                  ..location = _appData.location,
              );
              AppData().user = _guest;
              order.customer = _guest;
            } else if (result[0] == CustomerRegistrationType.fromGuest) {
              final verify = await verifyPhoneNumber(context, number);
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
            // print(order.customer);
            _order = await OrdersService().placeOrder(order);

            // _order.images = [];
            // for (final image in order.images) {
            //   print(_order.id);
            //   _order.images.add(OrderImage(
            //     sort: 'loc',
            //     name: await _service.addImage(
            //       _order.id,
            //       image.sort,
            //       image.name,
            //     ),
            //   ));
            // }

            Navigator.of(context).pop();
          } catch (e) {
            if(Navigator.canPop(context))
            Navigator.of(context).pop();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => UnableToPlaceOrderDialog(e),
            );
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

Future<PaymentResponse> selectPayment(
  BuildContext context,
  double payment,
) async =>
    (await navigateTo(context, PaymentMethodPage(amount: payment.round())))
        as PaymentResponse;

verifyLocation() {}
