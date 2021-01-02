part of 'delivery-vehicle_pages.dart';

class DeliveryVehicleSelectionPage extends StatelessWidget {
  final DeliveryVehicle _deliveryVehicle;

  final _item = DeliveryVehicleOrderable();
  final _order = Order<DeliveryVehicleOrderable>(OrderType.deliveryVehicle);

  DeliveryVehicleSelectionPage(this._deliveryVehicle) {
    _item.product = _deliveryVehicle;
  }

  @override
  Widget build(BuildContext context) {
    return OrderProgressView(
      order: _order,
      builder: (order) {
        return <Widget>[
          HeaderView(
            title: 'Service Details',
            subtitle: loremIpsum.substring(0, 0),
          ),
          DarkContainer(
            padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
            child: Column(
              children: [
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Image.network(
                      HaweyatiService.resolveImage(_deliveryVehicle.image.name),
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _deliveryVehicle.name,
                        style: TextStyle(
                          color: Color(0xFF313F53),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ]),
                Table(
                  textBaseline: TextBaseline.alphabetic,
                  defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
                  children: [
                  TableRow(
                      children: [
                        Text("Min Weight",style: TextStyle(color: Colors.grey,fontSize: 13),),
                        Text("Max Weight",style: TextStyle(color: Colors.grey,fontSize: 13),),
                        Text("Min Volume",style: TextStyle(color: Colors.grey,fontSize: 13),),
                        Text("Max Volume",style: TextStyle(color: Colors.grey,fontSize: 13),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Text(_deliveryVehicle.minWeight.toString(),textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF313F53))),
                        ),
                        Text(_deliveryVehicle.maxWeight.toString(),textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF313F53))),
                        Text(_deliveryVehicle.minVolume.toString(),textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF313F53))),
                        Text(_deliveryVehicle.maxVolume.toString(),textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF313F53))),
                      ]
                  ),
                ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:15.0),
            child: PickUpLocationPicker(_item,true),
          ),
          OrderLocationPicker(order,true),
        ];
      },
      // allow: _item.pickUpLocation !=null && _order.location !=null,
      onContinue:  (order) async {
        order.clearProducts();
        var _rest = await EstimatedPriceRest().getPrice({
          'vehicle' : _deliveryVehicle.id,
          'pickUpLat' : _item.pickUpLocation.latitude,
          'pickUpLng' : _item.pickUpLocation.longitude,
          'dropOffLat' : _order.location.latitude,
          'dropOffLng' : _order.location.longitude,
        });
        _item.distance = _rest.distance;
        _order.addProduct(
          _item, _rest.price,
        );
        navigateTo(context, DeliveryVehicleOrderTimeAndLocationPage(_order));
      },
    );
  }
}

class DeliveryVehicleOrderTimeAndLocationPage extends StatefulWidget {
  final Order<DeliveryVehicleOrderable> _order;
  DeliveryVehicleOrderTimeAndLocationPage(this._order);

  @override
  _DeliveryVehicleOrderTimeAndLocationPageState createState() =>
      _DeliveryVehicleOrderTimeAndLocationPageState();
}

class _DeliveryVehicleOrderTimeAndLocationPageState
    extends State<DeliveryVehicleOrderTimeAndLocationPage> {
  var _allow = false;
  final _formKey = GlobalKey<SimpleFormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return OrderProgressView<DeliveryVehicleOrderable>(
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
        navigateTo(context, DeliveryVehicleOrderConfirmationPage(order));
      },
    );
  }
}

class DeliveryVehicleOrderConfirmationPage extends StatelessWidget {
  final Order<DeliveryVehicleOrderable> _order;
  DeliveryVehicleOrderConfirmationPage(this._order);

  @override
  Widget build(BuildContext context) {
    print(_order.total);
    return OrderConfirmationView<DeliveryVehicleOrderable>(
      order: _order,
      itemsBuilder: (lang, order) => order.products.map((holder) {
        return OrderConfirmationItem(
          title: holder.item.product.name,
          image: holder.item.product.image.name,
          table: DetailsTableAlt([
            'Price',
            'Quantity',
            'Days'
          ], [
            '${_order.total} SAR',
            lang.nPieces(holder.item.qty),
            "1"
          ], [
            2,
            1,
            1
          ]),
        );
      }).toList(),
      pricingBuilder: (lang, order) => order.products.map((holder) {
        return DetailsTable([
          DetailRow(
            holder.item.product.name,
            lang.nPieces(holder.item.qty),
          ),
          PriceRow(
            'Price',
            _order.subtotal,
          ),
        ]);
      }).toList(),
    );
  }
}
