import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/payment_model.dart';
import 'package:haweyati/src/services/orders_service.dart';
import 'package:haweyati/src/ui/modals/dialogs/order/unable-to-place-order_dialog.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/pages/auth/sign-in_page.dart';
import 'package:haweyati/src/ui/pages/orders/order-placed_page.dart';
import 'package:haweyati/src/ui/pages/payment/payment-methods_page.dart';
import 'package:haweyati/src/ui/snack-bars/payment/not-selected_snack-bar.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/models/order/order_model.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class OrderConfirmationView extends StatelessWidget {
  final Order order;
  final bool fromCart;
  final List<Widget> children;
  final FutureOr Function() preProcess;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  OrderConfirmationView({
    this.order,
    this.fromCart = false,
    this.children,
    this.preProcess
  });

  @override
  Widget build(BuildContext context) {
    return ScrollableView(
      key: _scaffoldKey,
      appBar: HaweyatiAppBar(progress: .75, confirmOrderCancel: true),
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
      showBackground: true,
      children: children,
      extendBody: true,

      bottom: RaisedActionButton(
        label: 'Proceed',
        onPressed: () async {
          final _appData = AppData.instance();
          if (!_appData.isAuthenticated) {
            navigateTo(context, SignInPage());
          }

          order.customer = AppData.instance().user;
          _scaffoldKey.currentState.hideCurrentSnackBar();

          if (preProcess != null) await preProcess();

          final result = await navigateTo(context, PaymentMethodPage(
            amount: order.total.toInt(),
          ));

          if (result == null) {
            _scaffoldKey.currentState.showSnackBar(PaymentMethodNotSelectedSnackBar());
            return;
          }

          order.payment = Payment(
            type: result.method,
            intentId: result.intentId
          );

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => WaitingDialog(message: 'Placing your order')
          );

          try {
            final _service = OrdersService();
            final _order = await _service.placeOrder(order);

            /// loc, bd-s, bd-d, ad
            _order.images = [];
            for (final image in order.images) {
              print(_order.id);
              _order.images.add(OrderImage(
                sort: 'loc',
                name: await _service.addImage(_order.id, image.sort, image.name)
              ));
            }

            Navigator.of(context).pop();
            navigateTo(context, OrderPlacedPage(_order, () async {}));
          } catch (e) {
            Navigator.of(context).pop();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => UnableToPlaceOrderDialog(e)
            );
          }
        }
      )
    );
  }
}
