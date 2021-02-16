part of 'building-material_pages.dart';

class BuildingMaterialOrderSelectionPage extends StatefulWidget {
  final BuildingMaterial product;

  BuildingMaterialOrderSelectionPage(this.product);

  @override
  _BuildingMaterialOrderSelectionPageState createState() =>
      _BuildingMaterialOrderSelectionPageState();
}

class _BuildingMaterialOrderSelectionPageState
    extends State<BuildingMaterialOrderSelectionPage> {
  // final _item1 = BuildingMaterialOrderable();
  // final _item2 = BuildingMaterialOrderable(BuildingMaterialSize.yards20);
  List<BuildingMaterialOrderable> items = [];
  final _order = Order<BuildingMaterialOrderable>(OrderType.buildingMaterial);
  List<BMPrice> pricing;
  @override
  void initState() {
    super.initState();
    // _item1.product = BuildingMaterial.from(widget.product);
    // _item2.product = BuildingMaterial.from(widget.product);
    // print(widget.product.pricing.first.price.length);
    pricing = widget.product.pricing.first.price;
    pricing.forEach((element) => items.add(BuildingMaterialOrderable(price: element,product: widget.product)));
    // _item1.price = widget.product.pricing.first.price.first.price;
    // _item2.price = widget.product.pricing.first.price.first.price;
  }

  bool allowToProceed() => items.any((element) => element.qty != 0);

  @override
  Widget build(BuildContext context) {
    return OrderProgressView(
        order: _order,
        allow: allowToProceed(),
        builder: (order) {
          return <Widget>[
            HeaderView(
              title: 'Product Details',
              subtitle: loremIpsum.substring(0, 70),
            ),
            for(int i=0; i<pricing.length; ++i)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ContainerDescription(text: pricing[i].unit, size: ''),
                _ContainerSelection(
                  price:  pricing[i].price,
                  qty: items[i].qty.toDouble(),
                  onChanged: (count) => setState(() => items[i].qty = count.toInt()),
                ),
              ],
            ),

            // _ContainerDescription(text: 'Big Container', size: ''),
            // _ContainerSelection(
            //   price: _item2.price,
            //   qty: _item2.qty.toDouble(),
            //   onChanged: (count) => setState(() => _item2.qty = count.toInt()),
            // ),
          ];
        },
        onContinue: (order) {
          order.clearProducts();
          items.forEach((element) {
            if(element.qty > 0){
              order.addProduct(element, element.price.price * element.qty);
            }
          });
          // if (_item1.qty > 0) {
          //   order.addProduct(_item1, _item1.price * _item1.qty);
          // }
          //
          // if (_item2.qty > 0) {
          //   order.addProduct(_item2, _item2.price * _item2.qty);
          // }

          navigateTo(context, BuildingMaterialTimeAndLocationPage(_order));
        });
  }
}

class BuildingMaterialTimeAndLocationPage extends StatefulWidget {
  final Order _order;

  BuildingMaterialTimeAndLocationPage(this._order);

  @override
  _BuildingMaterialTimeAndLocationPageState createState() =>
      _BuildingMaterialTimeAndLocationPageState();
}

class _BuildingMaterialTimeAndLocationPageState
    extends State<BuildingMaterialTimeAndLocationPage> {
  var _allow = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return OrderProgressView(
      progress: .5,
      allow: _allow,
      order: widget._order,
      builder: (Order order) => <Widget>[
        HeaderView(
          title: 'Time & Location',
          subtitle: loremIpsum.substring(0, 80),
        ),
        OrderLocationPicker(order),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: DropOffPicker(order, () => setState(() => _allow = true)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ImagePickerWidget(
            onImagePicked: (PickedFile file){
              order.addImage(File(file.path));
            },
            onImageDeleted: ()=> order.removeImage(),
          ),
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            style: TextStyle(fontFamily: 'Lato'),
            initialValue: widget._order.note,
            decoration: InputDecoration(
              labelText: 'Note',
              hintText: 'Write note here..',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            maxLines: 4,
            maxLength: 80,
            onSaved: (text) => widget._order.note = text,
          ),
        ),
      ],
      onContinue: (order) {
        _formKey.currentState.save();
        navigateTo(context, BuildingMaterialOrderConfirmationPage(order));
      },
    );
  }
}

class BuildingMaterialOrderConfirmationPage extends StatelessWidget {
  final Order<BuildingMaterialOrderable> _order;

  BuildingMaterialOrderConfirmationPage(this._order);

  @override
  Widget build(BuildContext context) {
    return OrderConfirmationView<BuildingMaterialOrderable>(
      order: _order,
      itemsBuilder: (lang, order) => order.products.map((holder) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: OrderConfirmationItem(
            title: holder.item.product.name +
                ' (${holder.item.price.unit})',
            image: holder.item.product.image.name,
            table: DetailsTableAlt([
              'Price',
              'Container'
            ], [
              '${holder.item.price.price.toStringAsFixed(0)} SAR',
              lang.nPieces(holder.item.qty)
            ]),
          ),
        );
      }).toList(),
      pricingBuilder: (lang, order) => order.products.map((holder) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: DetailsTable([
            DetailRow(
              '${holder.item.product.name} (${holder.item.price.unit})',
              lang.nPieces(holder.item.qty),
            ),
            PriceRow(
              'Price ${lang.nPieces(holder.item.qty)}',
              holder.item.price.price * holder.item.qty,
            )
          ]),
        );
      }).toList(),
    );
  }
}

/// Private Widgets
class _ContainerDescription extends RichText {
  _ContainerDescription({String text, String size})
      : super(
          text: TextSpan(
            text: text,
            style: TextStyle(
              color: Color(0xFF313F53),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: ' ' + size,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF313F53),
                ),
              )
            ],
          ),
        );
}

class _ContainerSelection extends DarkContainer {
  _ContainerSelection({
    double qty,
    double price,
    void Function(double qty) onChanged,
  }) : super(
          height: 80,
          margin: const EdgeInsets.only(top: 20, bottom: 30),
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Column(children: [
                  Text(
                    'Quantity',
                    style: TextStyle(
                      color: Color(0xFF313F53),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${price?.toStringAsFixed(2)} SAR',
                    style: TextStyle(
                      color: Color(0xFF313F53),
                    ),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ),
              Counter(initialValue: qty, onChange: onChanged)
            ],
          ),
        );
}
