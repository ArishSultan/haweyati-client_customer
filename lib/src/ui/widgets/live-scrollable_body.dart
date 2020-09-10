import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LiveScrollableView extends StatefulWidget {
  final Widget child;

  final String title;
  final String subtitle;

  final Function onRefresh;

  LiveScrollableView({
    this.child,
    this.title,
    this.subtitle,
    this.onRefresh,
  });

  @override
  _LiveScrollableViewState createState() => _LiveScrollableViewState();
}

class _LiveScrollableViewState extends State<LiveScrollableView> {
  bool _allowRefresh = false;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      if (_allowRefresh)
        CupertinoSliverRefreshControl(
          onRefresh: widget.onRefresh,
        ),

      SliverPadding(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
        sliver: SliverToBoxAdapter(child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold
          )
        )),
      ),

      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        sliver: SliverToBoxAdapter(child: Text(widget.subtitle, textAlign: TextAlign.center)),
      ),
      SliverPadding(padding: const EdgeInsets.only(top: 40), sliver: widget.child)
    ]);
  }
}
