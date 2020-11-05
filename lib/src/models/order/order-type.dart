class OrderType {
  final int index;
  final String value;

  const OrderType._(this.value, this.index);

  static const dumpster = OrderType._('Construction Dumpster', 0);
  static const scaffolding = OrderType._('Scaffolding', 1);
  static const delivery = OrderType._('Building Material', 2);
  static const buildingMaterial = OrderType._('Building Material', 3);
  static const finishingMaterial = OrderType._('Finishing Material', 4);

  String serialize() {
    return value;
  }

  factory OrderType.deserialize(String value) {
    final type = OrderType._(value, -1);

    if (type == dumpster) {
      return dumpster;
    } else if (type == scaffolding) {
      return scaffolding;
    } else if (type == buildingMaterial) {
      return buildingMaterial;
    } else if (type == finishingMaterial) {
      return finishingMaterial;
    } else {
      throw 'Invalid OrderType `$value`';
    }
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) => other is OrderType && other.value == value;
}
