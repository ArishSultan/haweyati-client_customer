import 'package:haweyati/src/common/models/json_serializable.dart';

class TokenUpdate extends JsonSerializable {
  String id;
  String token;

  TokenUpdate(String id, String token):
    assert(id != null), assert(token != null);

  @override
  Map<String, dynamic> serialize() => {
    '_id': id, 'token': token
  };
}