part of 'single-scaffolding_pages.dart';

class SingleScaffoldingSelectionPage extends StatelessWidget {
  final SingleScaffolding _singleScaffolding;
  final _item = SingleScaffoldingOrderable();
  final _order = Order<SingleScaffoldingOrderable>(OrderType.scaffolding);

  SingleScaffoldingSelectionPage(this._singleScaffolding) {
    _item.product = _singleScaffolding;
  }

  @override
  Widget build(BuildContext context) {
    return OrderProgressView(
      order: _order,
      builder: (order) {
        return <Widget>[
          HeaderView(
            title: 'Service Details',
            subtitle: loremIpsum.substring(0, 120),
          ),
          DarkContainer(
            padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Image.asset(
                  "assets/images/singleScaffolding.png",
                  width: 50,
                  height: 50,
                ),
              ),
              Expanded(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(_singleScaffolding.type,
                      style: TextStyle(
                        color: Color(0xFF313F53),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${_singleScaffolding.rent.toStringAsFixed(2)} SAR/${_singleScaffolding.days} days',
                    style: TextStyle(color: Color(0xFF313F53)),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ),
            ]),
          ),
          DarkContainer(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(children: [
              Expanded(
                child: Text(
                  'Quantity',
                  style: TextStyle(
                    color: Color(0xFF313F53),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Counter(
                initialValue: 1,
                onChange: (count) => _item.qty = count.round(),
              )
            ]),
          ),
          DarkContainer(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(children: [
              Expanded(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Add Extra Days',
                      style: TextStyle(
                        color: Color(0xFF313F53),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${_singleScaffolding.extraDayRent.toStringAsFixed(2)} SAR/day',
                    style: TextStyle(color: Color(0xFF313F53)),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ),
              Counter(
                initialValue: 0,
                onChange: (count) => _item.days = count.round(),
              )
            ]),
          ),
          DarkContainer(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Mesh Form',
                  style: TextStyle(
                    color: Color(0xFF313F53),
                    fontWeight: FontWeight.bold,
                    fontFamily: '',
                  ),
                ),
                MeshSelector(item: _singleScaffolding,
                  onMeshTypeChanged: (String type){
                      _item.mesh = type;
                  },
                  onQuantityChanged: (int qty){
                  _item.meshQty = qty;
                  },
                ),
              ],
            ),
          ),
          DarkContainer(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(children: [
              Expanded(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Wheels',
                      style: TextStyle(
                        color: Color(0xFF313F53),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${_singleScaffolding.wheels.toStringAsFixed(2)} SAR (Set of 4)',
                    style: TextStyle(color: Color(0xFF313F53)),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ),
              Counter(
                initialValue: 0,
                onChange: (count) => _item.wheels = count.round(),
              )
            ]),
          ),
          DarkContainer(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(children: [
              Expanded(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Connections',
                      style: TextStyle(
                        color: Color(0xFF313F53),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${_singleScaffolding.connections.toStringAsFixed(2)} SAR (Set of 4)',
                    style: TextStyle(color: Color(0xFF313F53)),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ),
              Counter(
                initialValue: 0,
                onChange: (count) => _item.connections = count.round(),
              )
            ]),
          ),
        ];
      },
      onContinue: (order) {
        order.clearProducts();
        var subtotal = 0.0;
        subtotal+= (_item.product.rent + (_item.days * _item.product.extraDayRent)) * _item.qty;
        subtotal+= _item.mesh == null ? 0 : _item.product.meshPrice(_item.mesh) * _item.meshQty;
        _item.meshQty = _item.mesh == null ? null : _item.meshQty;
        _item.days = _item.product.days + _item.days;
        subtotal+= _item.wheels * _item.product.wheels;
        subtotal+= _item.connections * _item.product.connections;
        _order.addProduct(
          _item,
          subtotal,
        );

        navigateTo(context, DumpsterOrderTimeAndLocationPage(_order));
      },
    );
  }
}

class MeshSelector extends StatefulWidget {
  final SingleScaffolding item;
  final Function(String) onMeshTypeChanged;
  final Function(int) onQuantityChanged;
  MeshSelector({this.item,this.onMeshTypeChanged,this.onQuantityChanged});
  @override
  _MeshSelectorState createState() => _MeshSelectorState();
}

class _MeshSelectorState extends State<MeshSelector> {
  String selectedMesh;
  int meshQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Wrap(
            children: [
              RadioListTile(
                  title: Text("None"),
                  value: null,
                  dense: true,
                  groupValue: selectedMesh,
                  onChanged: (String val) {
                    setState(() {
                      selectedMesh=val;
                    });
                      widget.onMeshTypeChanged(null);
                      widget.onQuantityChanged(null);
                  }
              ),
          RadioListTile(
            title: Text("Half"),
              dense: true,
              subtitle: Text("(${widget.item.pricing.first.mesh.half} SAR)"),
              value: 'half',
            groupValue: selectedMesh,
            onChanged: (String val) {
              setState(() {
                selectedMesh=val;
                widget.onMeshTypeChanged(val);
              });
            }
          ),
          RadioListTile(
              title: Text("Full"),
              dense: true,
              subtitle: Text("(${widget.item.pricing.first.mesh.full} SAR)"),
              groupValue: selectedMesh,
              value: 'full',
              onChanged: (String val) {
                setState(() {
                  selectedMesh=val;
                  widget.onMeshTypeChanged(val);
                });
              }
          ),
        ]),
        if(selectedMesh != null)  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Quantity',
                style: TextStyle(
                  color: Color(0xFF313F53).withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                  fontFamily: '',
                ),
              ),
              Expanded(child: Container()),
             Counter(
                minValue: 1,
                initialValue: meshQuantity.toDouble(),
                onChange: (count) {
                  meshQuantity = count.round();
                  widget.onQuantityChanged(count.round());
                },
              )
            ],
          ),
        )
      ],
    );
  }
}


class DumpsterOrderTimeAndLocationPage extends StatefulWidget {
  final Order<SingleScaffoldingOrderable> _order;
  DumpsterOrderTimeAndLocationPage(this._order);

  @override
  _DumpsterOrderTimeAndLocationPageState createState() =>
      _DumpsterOrderTimeAndLocationPageState();
}

class _DumpsterOrderTimeAndLocationPageState
    extends State<DumpsterOrderTimeAndLocationPage> {
  var _allow = false;
  final _formKey = GlobalKey<SimpleFormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return OrderProgressView<SingleScaffoldingOrderable>(
      key: _scaffoldKey,
      progress: .5,
      allow: _allow,
      order: widget._order,
      builder: (order) {
        return <Widget>[
          HeaderView(
            title: 'Time & Location',
            subtitle: loremIpsum.substring(0, 80),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: OrderLocationPicker(order, true),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: DropOffPicker(order, () => setState(() => _allow = true)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ImagePickerWidget(),
          ),
          SimpleForm(
            key: _formKey,
            onSubmit: () {},
            child: TextFormField(
              style: TextStyle(fontFamily: 'Lato'),
              initialValue: widget._order.note,
              decoration: InputDecoration(
                labelText: 'Note',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'Write note here..',
              ),
              maxLines: 4,
              maxLength: 80,
              onSaved: (text) => widget._order.note = text,
            ),
          )
        ];
      },
      onContinue: (order) async {
        await _formKey.currentState.submit();
        navigateTo(context, SingleScaffoldingOrderConfirmationPage(order));
      },
    );
  }
}

class SingleScaffoldingOrderConfirmationPage extends StatelessWidget {
  final Order<SingleScaffoldingOrderable> _order;
  SingleScaffoldingOrderConfirmationPage(this._order);

  @override
  Widget build(BuildContext context) {
    return OrderConfirmationView<SingleScaffoldingOrderable>(
      order: _order,
      itemsBuilder: (lang, order) => order.products.map((holder) {
        return OrderConfirmationItem(
          title: holder.item.product.type,
          assetImage: true,
          image: "assets/images/singleScaffolding.png",
          table: DetailsTableAlt([
            'Price',
            'Quantity',
            'Days'
          ], [
            '${holder.subtotal} SAR/'
                '${holder.item.product.days + holder.item.days} days',
            lang.nPieces(holder.item.qty),
            (holder.item.product.days + holder.item.days).toString()
          ], [
            2,
            1,
            1
          ]),
        );
      }).toList(),
      pricingBuilder: (lang, order) => order.products.map((holder) {
        print( holder.item.days);
        return DetailsTable([
          DetailRow(holder.item.product.type,
            lang.nPieces(holder.item.qty),
          ),
          PriceRow(
            'Price (${lang.nDays(holder.item.product.days)})',
            holder.item.product.rent * holder.item.qty,
          ),
            PriceRow(
              'Extra (${lang.nDays(holder.item.days)})',
              (holder.item.days * holder.item.product.extraDayRent).toDouble(),
            ),
         if(holder.item.mesh !=null) PriceRow(
              'Mesh (${holder.item.meshQty} ${holder.item.mesh})',
              holder.item.product.meshPrice(holder.item.mesh) * holder.item.meshQty,),
          PriceRow(
            'Connections (${holder.item.connections} Sets of 4)',
            holder.item.connections * holder.item.product.connections
          ),
          PriceRow(
              'Wheels (${holder.item.wheels}  Sets of 4)',
              holder.item.wheels * holder.item.product.wheels
          ),
        ]);
      }).toList(),
    );
  }
}
