import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LiveScrollableBody extends StatelessWidget {
  final String title;
  final Widget child;
  final String subtitle;
  final Function onRefresh;
  final bool showBackgroundImage;

  LiveScrollableBody({
    this.title,
    this.child,
    this.subtitle,
    this.onRefresh,
    this.showBackgroundImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: this.showBackgroundImage ? DecorationImage(
          alignment: Alignment(0, 1),
          image: AssetImage("assets/images/pattern.png"),
        ) : null
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomScrollView(slivers: <Widget>[
        onRefresh != null ? CupertinoSliverRefreshControl(
          onRefresh: onRefresh,
        ) : SliverToBoxAdapter(child: SizedBox()),
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

        SliverToBoxAdapter(child: Text(subtitle, textAlign: TextAlign.center)),
        SliverPadding(padding: const EdgeInsets.only(top: 40), sliver: child)
      ]),
    );
  }
}
