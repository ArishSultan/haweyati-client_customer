import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/utils/simple-future-builder.dart';

// ignore: must_be_immutable
class LiveScrollableView<T> extends StatefulWidget {
  final Widget header;
  final String title, subtitle,loadingTitle;
  final Future<List<T>> Function() loader;
  final Widget Function(BuildContext context, T data) builder;

  LiveScrollableViewState _state;

  LiveScrollableView({
    Key key,
    this.title,this.loadingTitle,
    this.header,
    this.subtitle,
    @required this.loader,
    @required this.builder
  }): assert(loader != null),
      assert(builder != null);

  Future reload() {
    return _state.loadDataAgain();
  }

  @override
  LiveScrollableViewState<T> createState() {
    _state = LiveScrollableViewState<T>();
    return _state;
  }
}

class LiveScrollableViewState<T> extends State<LiveScrollableView<T>> {
  Future<List<T>> _future;
  bool _allowRefresh = false;

  @override
  void initState() {
    super.initState();
    _future = widget.loader()..then((value) {
      if (!_allowRefresh) setState(() => _allowRefresh = true);
    })..catchError((error) {
      setState(() => _allowRefresh = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(key: widget.key, slivers: [
      if (_allowRefresh)
        CupertinoSliverRefreshControl(
          onRefresh: () => loadDataAgain(),
        ),

      if (widget.header != null)
        SliverToBoxAdapter(child: widget.header),

      if (widget.title != null)
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

      if (widget.subtitle != null)
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          sliver: SliverToBoxAdapter(child: Text(widget.subtitle, textAlign: TextAlign.center)),
        ),

      SimpleFutureBuilder.simplerSliver(
        future: _future,
        context: context,
        builder: ( AsyncSnapshot<List<T>> snapshot) {
          return SliverList(delegate: SliverChildBuilderDelegate(
                  (context, i) => widget.builder(context, snapshot.data[i]),
              childCount: snapshot.data.length
          ));
        },
      )
    ]);
  }
  
  loadDataAgain() async {
    _future = widget.loader();
    await _future;

    setState(() {});
  }
}
