part of 'finishing-material_pages.dart';

class FinishingMaterialServiceDetailPage extends StatefulWidget {
  final FinishingMaterial item;
  final Supplier supplier;
  FinishingMaterialServiceDetailPage(this.item,this.supplier);

  @override
  _FinishingMaterialServiceDetailPageState createState() =>
      _FinishingMaterialServiceDetailPageState();
}

class _FinishingMaterialServiceDetailPageState
    extends State<FinishingMaterialServiceDetailPage> {
  final _order = Order<FinishingMaterialOrderable>(OrderType.finishingMaterial);
  final _item = FinishingMaterialOrderable();
  Map<String,dynamic> selectedVariantObj = {};
  final _selectedVariants = <String, String>{};
  final _availableVariants = <String, List<String>>{};

  @override
  void initState() {
    super.initState();

    _order.location = OrderLocation()..update(AppData().location);
    //Todo: When a variant is selected it's volume is not included, it should be sent.
    if (widget.item.variants?.isNotEmpty ?? false) {
      for (final option in widget.item.options) {
        final values = option.values;
        _selectedVariants[option.name] = values[0];
        _availableVariants[option.name] = values;
      }

      final element = widget.item.variants?.firstWhere((element) {
        for (final key in element.keys) {
          if (key == 'price' || key =='cbmWidth' || key == 'volumetricWeight' ||
              key == 'cbmLength' || key == 'cbmHeight') continue;
          if (_selectedVariants[key] != element[key]) return false;
        }

        return true;
      }, orElse: () => null);

      if (element != null) {
        selectedVariantObj = element;
        _item.price = double.tryParse(element['price']) ?? 0.0;
      }
    } else {
      _item.price = widget.item.price;
    }

    _item.product = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return OrderProgressView.sliver(
      children: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
          sliver: SliverToBoxAdapter(
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
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      HaweyatiService.resolveImage(widget.item.image.name),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    widget.item.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF313F53),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
        if (widget.item.variants?.isNotEmpty ?? false) ..._buildVariants(),
        SliverToBoxAdapter(
          child: DarkContainer(
            height: 80,
            margin: const EdgeInsets.only(top: 20, bottom: 30),
            padding: const EdgeInsets.all(15),
            child: Row(children: [
              Column(children: [
                Text(
                  'Quantity',
                  style: TextStyle(
                    color: Color(0xFF313F53),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  '${_item.price?.toStringAsFixed(2)} SAR',
                  style: TextStyle(
                    color: Color(0xFF313F53),
                  ),
                )
              ], crossAxisAlignment: CrossAxisAlignment.start),
              Counter(
                initialValue: _item.qty.toDouble(),
                onChange: (count) => setState(() => _item.qty = count?.round()),
              )
            ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ),
        ),
        SliverToBoxAdapter(
          child: LocationPicker(
            initialValue: _order.location,
            onChanged: (Location location) => _order.location = location,
          ),
        ),
      ],
      onContinue: _item.qty > 0
          ? () {
              _order.clearProducts();

              _item.variants = selectedVariantObj;
              _order.addProduct(_item, _item.price * _item.qty);
              _order.supplier = widget.supplier;
              navigateTo(
                  context, FinishingMaterialOrderConfirmationPage(_order));
            }
          : null,
    );
  }

  List<Widget> _buildVariants() {
    List<Widget> list = [];

    _availableVariants.forEach((key, values) {
      list.add(SliverPadding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
        sliver: SliverToBoxAdapter(
          child: Text(
            key,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF313F53),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));

      list.add(SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width / 55,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            return Row(children: [
              Radio(
                visualDensity: VisualDensity.comfortable,
                value: values[index],
                groupValue: _selectedVariants[key],
                onChanged: (val) => _changedVariants(key, val),
              ),
              Text(values[index])
            ]);
          }, childCount: values.length),
        ),
      ));
    });

    return list;
  }

  _changedVariants(String key, String value) {
    print('variant changed => ' + key + ' ' + value);
    _selectedVariants[key] = value;

    final element = widget.item.variants?.firstWhere((element) {
      for (final key in element.keys) {
        if (key == 'price' || key =='cbmWidth' || key == 'volumetricWeight' ||
            key == 'cbmLength' || key == 'cbmHeight') continue;

        if (_selectedVariants[key] != element[key]) return false;
      }

      return true;
    }, orElse: () => null);

    if (element != null) {
      selectedVariantObj = element;
      _item.price = double.tryParse(element['price']) ?? 0.0;
    }

    setState(() {});
  }
}

class FinishingMaterialOrderConfirmationPage extends StatelessWidget {
  final Order<FinishingMaterialOrderable> _order;
  final bool _fromCart;

  FinishingMaterialOrderConfirmationPage(this._order, [this._fromCart = false]);

  @override
  Widget build(BuildContext context) {
    return OrderConfirmationView<FinishingMaterialOrderable>(
      order: _order,
      itemsBuilder: (lang, order) => order.products.map((holder) {
        return OrderConfirmationItem(
          title: holder.item.product.name,
          image: holder.item.product.image.name,
          table: DetailsTable([
            ...buildVariants(holder.item.variants),
            DetailRow('Quantity', lang.nPieces(holder.item.qty), false),
            PriceRow('Price', holder.item.price),
            DetailRow('', ''),
            PriceRow('Total', holder.item.price * holder.item.qty),
          ]),
        );
      }).toList(),
      pricingBuilder: (lang, order) => [],
    );
  }

}
