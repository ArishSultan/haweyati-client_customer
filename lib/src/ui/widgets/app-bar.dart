import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/routes.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/ui/modals/dialogs/order/cancel-order-confirmation_dialog.dart';
import 'package:haweyati/src/ui/pages/cart_page.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class HaweyatiAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool hideCart;
  final bool hideHome;
  final bool allowBack;
  final double progress;
  final List<Widget> actions;
  final bool confirmOrderCancel;

  const HaweyatiAppBar({
    this.allowBack = true,
    this.confirmOrderCancel = false,
    this.hideCart = false,
    this.hideHome = false,
    this.progress = 0.0,
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> _actions = [];
    if (!hideHome) _actions.add(
      IconButton(
        icon: Image.asset(HomeIcon, width: 23, color: Colors.white),
        onPressed: () async {
          if (confirmOrderCancel) {
            final result = await showDialog(
              context: context,
              builder: (context) => CancelOrderConfirmationDialog()
            );

            if (result ?? true) return;
          }
          Navigator
              .of(context)
              .popUntil((route) => route.settings.name == HOME_PAGE);
        },
      )
    );
    if (!hideCart) _actions.add(
      IconButton(
        onPressed: () => navigateTo(context, CartPage()),
        icon: Image.asset(CartIcon, width: 30)
      )
    );

    Widget _leading;
    if (Navigator.of(context).canPop() && allowBack) {
      _leading = IconButton(
        icon: Transform.rotate(
          angle: Localizations.localeOf(context).toString() == 'ar' ? 3.14159 : 0,
          child: Image.asset(ArrowBackIcon, width: 26, height: 26)
        ),
        onPressed: Navigator.of(context).pop,
      );
    }
    Widget _progress;
    if (progress > 0.0) {
      _progress = PreferredSize(
        preferredSize: Size.fromHeight(3),
        child: SizedBox(
          height: 3,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white,
          )
        )
      );
    }

    return AppBar(
      elevation: 0,
      bottom: _progress,
      leading: _leading,
      automaticallyImplyLeading: false,
      actions: actions ?? _actions,
      centerTitle: true,
      title: const Image(
        width: 33, height: 33,
        image: const AssetImage(AppLogo),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
