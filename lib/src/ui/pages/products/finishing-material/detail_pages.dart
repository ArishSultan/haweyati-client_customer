part of 'finishing-material_pages.dart';

class FinishingMaterialCategoriesPage extends StatelessWidget {
  final _service = FinishingMaterialsRest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(hideHome: true),
      body: LiveScrollableView<FinishingMaterialBase>(
        title: 'Finishing Material',
        subtitle: loremIpsum.substring(0, 70),
        loader: () => _service.getCategories(),
        builder: (context, data) {
          return ProductListTile(
            name: data.name,
            image: data.image.name,
            onTap: () => navigateTo(context, FinishingMaterialsPage(data)),
          );
        },
      ),
    );
  }
}

class FinishingMaterialsPage extends StatefulWidget {
  final FinishingMaterialBase item;
  FinishingMaterialsPage(this.item);

  @override
  _FinishingMaterialsPageState createState() => _FinishingMaterialsPageState();
}

class _FinishingMaterialsPageState extends State<FinishingMaterialsPage> {
  Future<List<FinishingMaterial>> _future;

  var _allowRefresh = false;
  final _service = FinishingMaterialsRest();
  final _countListenable = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _future = _service.get(AppData().city, widget.item.id)
      ..then((value) {
        if (!_allowRefresh) setState(() => _allowRefresh = true);

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
              _future = _service.get(AppData().city, widget.item.id)
                ..then((value) => _countListenable.value = value.length);
              await _future;

              setState(() {});
            },
          ),
        SliverToBoxAdapter(
          child: Container(
            height: 90,
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xEEFFFFFF),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 1,
                      color: Colors.grey.shade300,
                    )
                  ],
                  image: DecorationImage(
                    image: NetworkImage(
                      HaweyatiService.resolveImage(widget.item.image.name),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  widget.item.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF313F53),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]),
          ),
        ),
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
                  return SliverFixedExtentList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => ProductListTile(
                        name: snapshot.data[i].name,
                        image: snapshot.data[i].image.name,
                        onTap: () => navigateTo(
                          context,
                          FinishingMaterialPage(snapshot.data[i]),
                        ),
                      ),
                      childCount: snapshot.data.length,
                    ),
                    itemExtent: 90,
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: Column(children: [
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: Text('Locating Services'),
                      )
                    ]),
                  );
                }
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return SliverFixedExtentList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => ProductListTile(
                        name: snapshot.data[i].name,
                        image: snapshot.data[i].image.name,
                        onTap: () => navigateTo(
                          context,
                          FinishingMaterialPage(snapshot.data[i]),
                        ),
                      ),
                      childCount: snapshot.data.length,
                    ),
                    itemExtent: 90,
                  );
                }
            }

            return SliverToBoxAdapter(child: Text('No Data was found'));
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
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 50,
      color: shrinkOffset > 0 ? Color(0xFF313F53) : Colors.white,
      child: Row(children: [
        ValueListenableBuilder<int>(
          valueListenable: value,
          child: Text(
            '${value.value} Items Available',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: shrinkOffset > 0.0 ? Colors.white : Color(0xFF313F53),
            ),
          ),
          builder: (context, val, widget) => Text(
            '${value.value} Items Available',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: shrinkOffset > 0.0 ? Colors.white : Color(0xFF313F53),
            ),
          ),
        ),
        Spacer(),
        GestureDetector(
          child: Icon(
            Icons.sort,
            color: shrinkOffset > 0.0 ? Colors.white : Color(0xFF313F53),
          ),
          onTap: () {},
        ),
        SizedBox(width: 10),
        GestureDetector(
          child: Icon(
            Icons.search,
            color: shrinkOffset > 0.0 ? Colors.white : Color(0xFF313F53),
          ),
          onTap: () {},
        ),
      ]),
      padding: const EdgeInsets.symmetric(horizontal: 15),
    );
  }

  @override
  double get maxExtent => 50;
  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class FinishingMaterialPage extends StatefulWidget {
  final FinishingMaterial item;
  FinishingMaterialPage(this.item);

  @override
  _FinishingMaterialPageState createState() => _FinishingMaterialPageState();
}

class _FinishingMaterialPageState extends State<FinishingMaterialPage> {
  final _appData = AppData();

  @override
  Widget build(BuildContext context) {
    return ProductDetailView(
      title: widget.item.name,
      image: widget.item.image.name,
      description: widget.item.description,
      bottom: Container(
        height: 80,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 7.5),
        child: Row(children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 7.5),
              constraints: BoxConstraints.expand(height: 40),
              child: FutureBuilder<bool>(
                future: _appData.canAddToCart(widget.item),
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  return FlatButton(
                    textColor: Colors.white,
                    color: Colors.red,
                    disabledColor: Color(0x77ff0000),
                    disabledTextColor: Colors.white,
                    shape: StadiumBorder(),
                    child: snapshot.connectionState == ConnectionState.done
                        ? Text(
                      snapshot.data ?? true
                          ? 'Add To Cart'
                          : 'Already Added',
                    )
                        : SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    onPressed: snapshot.data ?? true
                        ? () async {
                      await _appData.addToCart(widget.item);
                      setState(() {});
                    }
                        : null,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 7.5),
              constraints: BoxConstraints.expand(height: 40),
              child: FlatButton(
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                shape: StadiumBorder(),
                child: Text('Buy Now'),
                onPressed: () => navigateTo(
                    context, FinishingMaterialServiceDetailPage(widget.item)),
              ),
            ),
          ),
        ]),
      ),
      price: _buildPrice(),
    );
  }

  _buildPrice() {
    if (widget.item.variants?.isNotEmpty ?? false) {
      final range = _minAndMaxPrice(widget.item.variants);

      return TextSpan(
        text: '${range[0]?.toStringAsFixed(2)} SAR - ',
        style: TextStyle(
          color: Color(0xFF313F53),
        ),
        children: [
          TextSpan(
            text: '${range[1]?.toStringAsFixed(2)} SAR',
            style: TextStyle(
              color: Color(0xFF313F53),
            ),
          )
        ],
      );
    } else {
      return TextSpan(
        text: '${widget.item.price?.toStringAsFixed(2)} SAR',
        style: TextStyle(color: Color(0xFF313F53)),
      );
    }
  }

  static List<double> _minAndMaxPrice(List<Map<String, dynamic>> variants) {
    var min = double.tryParse(variants[0]['price']);
    var max = min;

    for (final variant in variants) {
      final price = double.tryParse(variant['price']) ?? 0.0;

      if (price < min) {
        min = price;
      }

      if (price > max) {
        max = price;
      }
    }

    return [min, max];
  }
}
