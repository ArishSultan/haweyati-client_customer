import 'package:haweyati/src/common/models/json_serializable.dart';

class Payment extends JsonSerializable {
  String type;
  String intentId;

  Payment({
    this.type,
    this.intentId
  });

  @override
  Map<String, dynamic> serialize() => {
    'type': type, 'intentId': intentId
  };
}