part of 'finishing-material_pages.dart';

class FinishingMaterialShops extends StatelessWidget {
  final _service = FinishingMaterialsRest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(hideHome: true),
      body: LiveScrollableView<Supplier>(
        title: 'Finishing Material Shops',
        subtitle: loremIpsum.substring(0, 70),
        loader: () => _service.getShops(
            AppData().city,
            AppData().location.latitude,
            AppData().location.longitude),
        builder: (context,Supplier data) {
          return ProductListTile(
            name: data.person.name,
            image: data.person.image.name,
            onTap: () => navigateTo(context, FinishingMaterialCategoriesPage(data)),
          );
        },
      ),
    );
  }
}

class FinishingMaterialCategoriesPage extends StatelessWidget {
  final _service = FinishingMaterialsRest();
  final Supplier supplier;
  FinishingMaterialCategoriesPage(this.supplier);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(hideHome: true),
      body: LiveScrollableView<FinishingMaterialBase>(
        title: 'Finishing Material Shops',
        subtitle: loremIpsum.substring(0, 70),
        loader: () => _service.getCategories(supplier.id),
        builder: (context, data) {
          return ProductListTile(
            name: data.name,
            image: data.image.name,
            onTap: () => navigateTo(context, FinishingMaterialsPage(data,supplier)),
          );
        },
      ),
    );
  }
}

class FinishingMaterialsPage extends StatefulWidget {
  final FinishingMaterialBase item;
  final Supplier supplier;
  FinishingMaterialsPage(this.item,this.supplier);

  @override
  _FinishingMaterialsPageState createState() => _FinishingMaterialsPageState();
}

class _FinishingMaterialsPageState extends State<FinishingMaterialsPage> {
  Future<List<FinishingMaterial>> _future;

  var _allowRefresh = false;
  final _service = FinishingMaterialsRest();
  final _countListenable = ValueNotifier<int>(0);
  TextEditingController search = TextEditingController();
  var searchTapped = false;

  @override
  void initState() {
    super.initState();
    _future = _service.get(widget.supplier.id, widget.item.id)
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
          sliver: !searchTapped ? SliverPersistentHeader(
            delegate: _SearchBarDelegate(_countListenable,(bool value){
              setState(() {
                searchTapped =true;
              });
                }),
            pinned: true,
          ) : SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: HaweyatiTextField(
                controller: search,
                label: 'Search',
                icon: CupertinoIcons.search,
                dense: true,
                onFieldSubmitted: (String val){
                  setState(() {
                    _future =  _service.search(val);
                  });
                },
              ),
            ),
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
                          FinishingMaterialPage(snapshot.data[i],widget.supplier),
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
                          FinishingMaterialPage(snapshot.data[i],widget.supplier),
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
  _SearchBarDelegate(this.value, this.onSearchTapped);
  final ValueListenable<int> value;
  final Function(bool) onSearchTapped;

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
        // GestureDetector(
        //   child: Icon(
        //     Icons.sort,
        //     color: shrinkOffset > 0.0 ? Colors.white : Color(0xFF313F53),
        //   ),
        //   onTap: () {},
        // ),
        SizedBox(width: 10),
        GestureDetector(
          child: Icon(
            Icons.search,
            color: shrinkOffset > 0.0 ? Colors.white : Color(0xFF313F53),
          ),
          onTap: () async {
           onSearchTapped(true);
          },
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
  final Supplier supplier;
  FinishingMaterialPage(this.item,this.supplier);

  @override
  _FinishingMaterialPageState createState() => _FinishingMaterialPageState();
}

class _FinishingMaterialPageState extends State<FinishingMaterialPage> {
  final _appData = AppData();

  @override
  Widget build(BuildContext context) {
    return ProductDetailView(
      shareableData: ShareableData(
        id: widget.item.id,
        type: OrderType.dumpster,
        socialMediaTitle: widget.item.name,
        socialMediaDescription: widget.item.description
      ),
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
                      Box<Supplier> box = await Hive.openBox('supplier');
                      if(box.isNotEmpty && widget.supplier.id != box.getAt(0).id){
                        Scaffold.of(context).
                        showSnackBar(SnackBar(
                            content: Text('You cannot add items from two different suppliers')));
                        return;
                      }

                      if(box.isEmpty){
                        await box.add(widget.supplier);
                        await widget.supplier.save();
                      }

                      await _appData.addToCart(widget.item);
                      await box.close();
                      setState(() {});
                    } : null,
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
                    context, FinishingMaterialServiceDetailPage(widget.item,widget.supplier)),
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
