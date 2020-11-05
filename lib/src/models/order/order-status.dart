import 'package:haweyati/src/common/models/serializable.dart';

class OrderStatus implements Serializable<int> {
  final int value;
  const OrderStatus._(this.value);

  static const pending = OrderStatus._(0);
  static const approved = OrderStatus._(1);
  static const accepted = OrderStatus._(2);
  static const preparing = OrderStatus._(3);
  static const dispatched = OrderStatus._(4);
  static const delivered = OrderStatus._(5);
  static const rejected = OrderStatus._(6);
  static const canceled = OrderStatus._(7);

  @override
  String toString() {
    switch (value) {
      case 0: return 'Pending';
      case 1: return 'Approved';
      case 2: return 'Accepted';
      case 3: return 'Preparing';
      case 4: return 'Dispatched';
      case 5: return 'Delivered';
      case 6: return 'Rejected';
      case 7: return 'Canceled';
    }

    return 'Unknown';
  }

  @override
  int serialize() => value;
  factory OrderStatus.deserialize(int value) {
    if (value > -1 && value < 6) {
      return OrderStatus._(value);
    }

    throw 'Invalid value `$value`';
  }

  @override
  bool operator ==(Object other) {
    return other is OrderStatus && other.value == value;
  }

  @override
  int get hashCode => super.hashCode;
}
