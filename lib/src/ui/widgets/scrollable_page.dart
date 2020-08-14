import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/widgits/appBar.dart';

class ScrollablePage extends StatelessWidget {
  final String title;
  final Widget child;
  final String action;
  final AppBar appBar;
  final double padding;
  final String subtitle;
  final double distance;
  final Function onAction;
  final bool showBackgroundImage;
  final bool showButtonBackground;
  final GlobalKey<ScaffoldState> key;

  ScrollablePage({
    this.key,
    this.title,
    this.child,
    this.appBar,
    this.action,
    this.padding,
    this.subtitle,
    this.distance,
    this.onAction,
    this.showBackgroundImage = true,
    this.showButtonBackground = false
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: this.appBar ?? HaweyatiAppBar( showCart: false,showHome: false,),
      backgroundColor: Colors.white,
      body: Container(
        decoration: showBackgroundImage ? BoxDecoration(
            image: DecorationImage(
              alignment: Alignment(0, 1),
              image: AssetImage("assets/images/pattern.png"),
            )
        ) : null,
        padding: EdgeInsets.symmetric(horizontal: this.padding ?? 20),
        child: CustomScrollView(slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.only(top: 30, bottom: 10),
            sliver: SliverToBoxAdapter(child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )
            )),
          ),
          SliverToBoxAdapter(child: Text(
            subtitle,
            textAlign: TextAlign.center,
          )),

          SliverPadding(
            padding: EdgeInsets.only(top: distance ?? 40),
            sliver: child,
          )
        ]),
      ),

      extendBody: !showButtonBackground,
      bottomNavigationBar: Container(
        color: showButtonBackground ? Colors.white : null,
        child: this.action != null ? Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(height: 45),
            child: FlatButton(
              onPressed: onAction,
              shape: StadiumBorder(),
              textColor: Colors.white,
              child: Text(this.action),
              color: Theme.of(context).accentColor,
            ),
          ),
        ): null,
      ),
    );
  }
}
