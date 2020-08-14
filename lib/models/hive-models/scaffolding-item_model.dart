
class ScaffoldingItemModel {
  String name;
  int qty;
  double price;
  double size;

  ScaffoldingItemModel({this.size,this.name,this.price,this.qty});

}

List<ScaffoldingItemModel> scaffoldingItems = [
  ScaffoldingItemModel(
    name: 'Main Frame',
    price: 345,
    qty: 1,
    size: 1.5,
  ),
  ScaffoldingItemModel(
    name: 'Cross Brace',
    price: 345,
    qty: 1,
    size: 1.5,
  ),
  ScaffoldingItemModel(
    name: 'Connecting Bar',
    price: 345,
    qty: 1,
    size: 1.5,
  ),
  ScaffoldingItemModel(
    name: 'Adjustable Base',
    price: 345,
    qty: 1,
    size: 1.5,
  ),
  ScaffoldingItemModel(
    name: 'Stabilizer',
    price: 345,
    qty: 1,
    size: 1.5,
  ),
  ScaffoldingItemModel(
    name: 'Wood Planks',
    price: 345,
    qty: 1,
    size: 1.5,
  ),
];