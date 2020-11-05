import 'package:json_annotation/json_annotation.dart';

part 'sign-in_model.g.dart';

@JsonSerializable()
class SignInRequest {
  String username;
  String password;
  SignInRequest({this.username, this.password});

  toJson() => _$SignInRequestToJson(this);
  factory SignInRequest.fromJson(json) => _$SignInRequestFromJson(json);
}

@JsonSerializable()
class SignInResponse {
  @JsonKey(name: 'access_token')
  String accessToken;

  SignInResponse(this.accessToken);

  toJson(json) => _$SignInResponseToJson(json);
  factory SignInResponse.fromJson(json) => _$SignInResponseFromJson(json);
}
