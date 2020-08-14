import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HaweyatiAppBar extends AppBar {
  final bool hideCart;
  final bool hideHome;

  HaweyatiAppBar(BuildContext context, {
    double progress = .5,
    this.hideCart = false,
    this.hideHome = false
  }): super(
      elevation: 0,
      centerTitle: true,
      brightness: Brightness.dark,

      title: Image.asset(
        "assets/images/haweyati_logo1.png",
        width: 40,
        height: 40,
      ),
      actions: [
        hideHome ? SizedBox() : GestureDetector(
          child: Icon(CupertinoIcons.home, size: 30),
          onTap: () {
            Navigator.of(context).popUntil((route) => route.settings.name == '/');
          },
        ),

        hideCart ? SizedBox() : GestureDetector(
          child: IconButton(
              onPressed: () {},
              icon: Icon(CupertinoIcons.shopping_cart, size: 30)
          ),
        )
      ],
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: Container(
              height: 3,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white,
              )
          )
      )
  );
}
