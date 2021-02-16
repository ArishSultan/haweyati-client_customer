part of 'delivery-vehicle_pages.dart';

class DeliveryVehicleSelectionPage extends StatelessWidget {
  final DeliveryVehicle _deliveryVehicle;
  final Location pickUp;

  final _item = DeliveryVehicleOrderable();
  final _order = Order<DeliveryVehicleOrderable>(OrderType.deliveryVehicle);
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  DeliveryVehicleSelectionPage(this._deliveryVehicle,this.pickUp) {
    _item.product = _deliveryVehicle;
    _item.pickUpLocation = pickUp;
  }

  @override
  Widget build(BuildContext context) {
    return OrderProgressView(
      order: _order,
      // key: key,
      builder: (order) {
        return <Widget>[
          HeaderView(
            title: 'Service Details',
            subtitle: loremIpsum.substring(0, 80),
          ),
          DarkContainer(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
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
                      child: ListTile(
                        title: Text(
                          _deliveryVehicle.name,
                          style: TextStyle(
                            color: Color(0xFF313F53),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                         "Weight:  " +  _deliveryVehicle.volumetricWeight.toString(),
                          style: TextStyle(
                            color: Color(0xFF313F53),
                            fontSize: 12
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
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
        if(_order.location == null){
          showDialog(context: context,builder: (ctx)=> AlertDialog(
              content:Text("Please select drop-off location.")));
          return;
        }
        order.clearProducts();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WaitingDialog(message: 'Processing'),
        );
        var _rest = await EstimatedPriceRest().getPrice({
          'vehicle' : _deliveryVehicle.id,
          'pickUpLat' : _item.pickUpLocation.latitude,
          'pickUpLng' : _item.pickUpLocation.longitude,
          'dropOffLat' : _order.location.latitude,
          'dropOffLng' : _order.location.longitude,
        });
        Navigator.pop(context);

        final location = await showDialog(
            context: context,
            builder: (context) => ConfirmationDialog(
              title: Text('Proceed'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DetailsTable([
                    PriceRow(
                      'Price',
                      _rest.price,
                    ),
                    PriceRow(
                      'Price per km',
                      _item.product.deliveryCharges,
                    ),
                    TableRow(
                        children: [
                          Text("Distance",style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontFamily: 'Lato',
                            height: 1.9,
                          ),),
                          Text(_rest.distance.toString() + " km",textAlign: TextAlign.right,),
                        ]
                    )
                  ]),
                ],
              ),
            ));

        if (location != true) return;


        _item.distance = _rest.distance;
        _order.addProduct(
          _item, _rest.price,
        );
        navigateTo(context, DeliveryVehicleOrderConfirmationPage(_order));
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
            child: ImagePickerWidget(
                onImagePicked: (PickedFile file){
                order.addImage(File(file.path));
            },
              onImageDeleted: ()=> order.removeImage(),
            ),
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
    return OrderConfirmationView<DeliveryVehicleOrderable>(
      order: _order,
      itemsBuilder: (lang, order) => order.products.map((holder) {
        return OrderConfirmationItem(
          title: holder.item.product.name,
          image: holder.item.product.image.name,
          table: DetailsTableAlt([
            'Price',
            'Quantity',
          ], [
            '${holder.subtotal.toStringAsFixed(2)} SAR',
            lang.nPieces(holder.item.qty),
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
          PriceRow(
            'Price per km',
            holder.item.product.deliveryCharges,
          ),
          TableRow(
            children: [
              Text("Distance",style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontFamily: 'Lato',
                height: 1.9,
              ),),
              Text(holder.item.distance.toString() + " km",textAlign: TextAlign.right,),
            ]
          )
        ]);
      }).toList(),
    );
  }
}
