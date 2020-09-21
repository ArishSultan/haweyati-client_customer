import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haweyati/src/models/services/finishing-material/category_model.dart';
import 'package:haweyati/src/models/services/finishing-material/model.dart';
import 'package:haweyati/src/services/fn-sublist_service.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/pages/services/finishing-material/item_page.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/service-list-tile.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';

class FinishingMaterialSubList extends StatefulWidget {
 final FinishingMaterialCategory item;
 FinishingMaterialSubList(this.item);

  @override
  _FinishingMaterialSubListState createState() => _FinishingMaterialSubListState();
}

class _FinishingMaterialSubListState extends State<FinishingMaterialSubList> {
  Future<List<FinishingMaterial>> _future;
  
  var _allowRefresh = false;
  final _service = FinishingMaterialsService();
  final _countListenable = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _future = _service.getFinSublist(widget.item.id)
      ..then((value) {
        if (!_allowRefresh)
          setState(() => _allowRefresh = true);

        _countListenable.value = value.length;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(),
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        if (_allowRefresh)
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _future = _service.getFinSublist(widget.item.id)
                ..then((value) => _countListenable.value = value.length);
              await _future;

              setState(() {});
            }
          ),
        
        SliverToBoxAdapter(child: Container(
          height: 90,
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.symmetric(
            horizontal: 15
          ),
          child: Row(children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: Color(0xEEFFFFFF),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 1,
                    color: Colors.grey.shade300
                  )
                ],
                image: DecorationImage(
                  image: NetworkImage(HaweyatiService.resolveImage(widget.item.image.name))
                )
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(widget.item.name, style: TextStyle(
                fontSize: 16,
                color: Color(0xFF313F53),
                fontWeight: FontWeight.bold
              )),
            )
          ]),
        )),

        SliverPadding(
          padding: const EdgeInsets.only(bottom: 10),
          sliver: SliverPersistentHeader(
            delegate: _SearchBarDelegate(_countListenable),
            pinned: true,
          ),
        ),

        FutureBuilder<List<FinishingMaterial>>(
          future: _future,
          builder: (context, AsyncSnapshot<List<FinishingMaterial>> snapshot) {
            if (snapshot.hasError) {
              return SliverToBoxAdapter(
                child: Text(snapshot.error.toString()),
              );
            }

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return SliverToBoxAdapter(child: Text('No Data was found'));
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (_allowRefresh) {
                  return SliverFixedExtentList(delegate: SliverChildBuilderDelegate(
                    (context, i) => ServiceListItem(
                      name: snapshot.data[i].name,
                      image: snapshot.data[i].images.name,
                      onTap: () => navigateTo(context, FinishingMaterialItemPage(snapshot.data[i]))
                    ),
                    childCount: snapshot.data.length
                  ), itemExtent: 90);
                } else {
                  return SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: CircularProgressIndicator(strokeWidth: 2)
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 13),
                          child: Text('Locating Services'),
                        )
                      ],
                    ),
                  );
                }
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return SliverFixedExtentList(delegate: SliverChildBuilderDelegate(
                    (context, i) => ServiceListItem(
                      name: snapshot.data[i].name,
                      image: snapshot.data[i].images.name,
                      onTap: () => navigateTo(context, FinishingMaterialItemPage(snapshot.data[i]))
                    ),
                    childCount: snapshot.data.length
                  ), itemExtent: 90);
                }
            }

            return SliverToBoxAdapter(
              child: Text('No Data was found'),
            );
          },
        ),
      ]),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  _SearchBarDelegate(this.value);
  final ValueListenable<int> value;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    print(shrinkOffset);

    return Container(
      height: 50,
      color: shrinkOffset > 0 ? Color(0xFF313F53) : Colors.white,
      child: Row(children: [
        ValueListenableBuilder<int>(
          valueListenable: value,
          child: Text('${value.value} Items Available', style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold,
            color: shrinkOffset > 0.0 ? Colors.white : Color(0xFF313F53)
          )),
          builder: (context, val, widget) => Text('${value.value} Items Available', style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold,
            color: shrinkOffset > 0.0 ? Colors.white : Color(0xFF313F53)
          ))
        ),

        Spacer(),

        GestureDetector(
          child: Icon(Icons.sort,
            color: shrinkOffset > 0.0 ? Colors.white : Color(0xFF313F53)
          ),
          onTap: () {}
        ),
        SizedBox(width: 10),
        GestureDetector(
          child: Icon(Icons.search,
            color: shrinkOffset > 0.0 ? Colors.white : Color(0xFF313F53)
          ),
          onTap: () {}
        ),
      ]),
      padding: const EdgeInsets.symmetric(horizontal: 15),
    );
  }

  @override double get maxExtent => 50;
  @override double get minExtent => 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
