part of 'dumpster_pages.dart';

class DumpsterOrderSelectionPage extends StatelessWidget {
  final Dumpster _dumpster;

  final _item = DumpsterOrderable();
  final _order = Order<DumpsterOrderable>(OrderType.dumpster);

  DumpsterOrderSelectionPage(this._dumpster) {
    _item.product = _dumpster;
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
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Image.network(
                  HaweyatiService.resolveImage(_dumpster.image.name),
                  width: 50,
                  height: 50,
                ),
              ),
              Expanded(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${_dumpster.size} Yard Dumpster',
                      style: TextStyle(
                        color: Color(0xFF313F53),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${_dumpster.rent.toStringAsFixed(2)} SAR/${_dumpster.days} days',
                    style: TextStyle(color: Color(0xFF313F53)),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ),
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
                      'Add Extra Days',
                      style: TextStyle(
                        color: Color(0xFF313F53),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${_dumpster.extraDayRent.toStringAsFixed(2)} SAR/day',
                    style: TextStyle(color: Color(0xFF313F53)),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ),
              Counter(
                initialValue: _item.extraDays?.toDouble() ?? 0,
                onChange: (count) => _item.extraDays = count.round(),
              )
            ]),
          ),
          DarkContainer(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(
              children: [
                Text(
                  'Dumpster Quantity',
                  style: TextStyle(
                    color: Color(0xFF313F53),
                    fontWeight: FontWeight.bold,
                    fontFamily: '',
                  ),
                ),
                Spacer(),
                Counter(
                  minValue: 1,
                  initialValue: _item.qty?.toDouble() ?? 0,
                  onChange: (count) => _item.qty = count.round(),
                )
              ],
            ),
          ),
        ];
      },
      onContinue: (order) {
        order.clearProducts();

        _item.extraDaysPrice = _item.product.extraDayRent * _item.extraDays;
        _order.addProduct(
          _item,
          (_item.product.rent + _item.extraDaysPrice) * _item.qty,
        );

        navigateTo(context, DumpsterOrderTimeAndLocationPage(_order));
      },
    );
  }
}

class DumpsterOrderTimeAndLocationPage extends StatefulWidget {
  final Order<DumpsterOrderable> _order;
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
    return OrderProgressView<DumpsterOrderable>(
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
        navigateTo(context, DumpsterOrderConfirmationPage(order));
      },
    );
  }
}

class DumpsterOrderConfirmationPage extends StatelessWidget {
  final Order<DumpsterOrderable> _order;
  DumpsterOrderConfirmationPage(this._order);

  @override
  Widget build(BuildContext context) {
    return OrderConfirmationView<DumpsterOrderable>(
      order: _order,
      itemsBuilder: (lang, order) => order.products.map((holder) {
        return OrderConfirmationItem(
          title: '${holder.item.product.size} Yard Container',
          image: holder.item.product.image.name,
          table: DetailsTableAlt([
            'Price',
            'Quantity',
            'Days'
          ], [
            '${holder.item.product.rent.round()} SAR/'
                '${holder.item.product.days} days',
            lang.nPieces(holder.item.qty),
            (holder.item.product.days + holder.item.extraDays).toString()
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
            '${holder.item.product.size} Yards Container',
            lang.nPieces(holder.item.qty),
          ),
          PriceRow(
            'Price (${lang.nDays(holder.item.product.days)})',
            holder.item.product.rent * holder.item.qty,
          ),
          if (holder.item.extraDays > 0)
            PriceRow(
              'Extra (${lang.nDays(holder.item.extraDays)})',
              holder.item.extraDaysPrice * holder.item.qty,
            ),
        ]);
      }).toList(),
    );
  }
}
