import 'dart:async';
import 'http/basics/request-type.dart';
import 'package:haweyati/src/common/models/serializable.dart';
import 'package:haweyati/src/common/services/easy-rest/easy-rest.dart';

abstract class JwtStorage<T> {
  FutureOr<T> read();
  FutureOr<void> clear();
  FutureOr<void> write(T token);
  FutureOr<void> refreshCache();
}

class RequestConfig {
  final String endpoint;
  final RequestType type;

  const RequestConfig({
    this.type,
    this.endpoint
  }): assert(type != null),
      assert(endpoint != null);
}

typedef UserParser<T> = T Function(Map<String, dynamic> json);
typedef TokenParser<S> = S Function(Map<String, dynamic> json);

class _AuthServiceConfiguration {
  final UserParser userParser;
  final TokenParser tokenParser;

  final JwtStorage userStorage;
  final JwtStorage tokenStorage;

  final RequestConfig userRequest;
  final RequestConfig signInRequest;
  final RequestConfig signOutRequest;

  _AuthServiceConfiguration({
    this.userParser,
    this.tokenParser,
    this.userStorage,
    this.userRequest,
    this.tokenStorage,
    this.signInRequest,
    this.signOutRequest
  }): assert(userStorage != null),
      assert(tokenStorage != null),
      assert(userRequest != null),
      assert(signInRequest != null),
      assert(signOutRequest != null);
}

abstract class JwtAuthService<T, U> {
  T get user;
  U get token;
  bool get isAuthenticated;

  $user();
  $signOut();
  $signIn(Serializable data);

  static _JwtAuthServiceImpl _;
  static _AuthServiceConfiguration _config;
  static configure<T, U>({
     UserParser userParser,
     JwtStorage<T> userStorage,
     JwtStorage<U> tokenStorage,
     TokenParser tokenParser,
     RequestConfig userRequest,
     RequestConfig signInRequest,
     RequestConfig signOutRequest,
  }) async {
    _config = _AuthServiceConfiguration(
      userParser: userParser,
      userStorage: userStorage,
      tokenParser: tokenParser,
      userRequest: userRequest,
      tokenStorage: tokenStorage,
      signInRequest: signInRequest,
      signOutRequest: signOutRequest
    );

    await userStorage.refreshCache();
    await tokenStorage.refreshCache();

    _JwtAuthServiceImpl._isAuthenticated =
      (await tokenStorage.read()) != null && (await userStorage.read() != null);
  }

  factory JwtAuthService.create() {
    if (_ == null) {
      _ = _JwtAuthServiceImpl<T, U>();
    }

    return _ as _JwtAuthServiceImpl<T, U>;
  }
}

class _JwtAuthServiceImpl<T, U> implements JwtAuthService<T, U> {
  final _service = EasyRest();
  static var _isAuthenticated = false;

  /// 128.199.20.220
  @override
  $signIn(Serializable data) async {
    final resp = await _service.$raw(
      data: data,
      type: JwtAuthService._config.signInRequest.type,
      route: JwtAuthService._config.signInRequest.endpoint
    );

    JwtAuthService._config.tokenStorage.write(
      JwtAuthService._config.tokenParser(resp)
    );

    await $user();
    _isAuthenticated = true;
  }

  @override
  $signOut() async {
    // await RestHttpService.create().$raw(
    //   type: JwtAuthService._config.signInRequest.type,
    //   path: JwtAuthService._config.signInRequest.endpoint
    // );
    //
    // JwtAuthService._config.userStorage.clear();
    // JwtAuthService._config.tokenStorage.clear();
  }

  @override
  $user() async {
    final resp = await _service.$raw(
      type: JwtAuthService._config.userRequest.type,
      route: JwtAuthService._config.userRequest.endpoint
    );

    JwtAuthService._config.userStorage.write(
      JwtAuthService._config.userParser(resp)
    );
  }

  @override
  T get user => throw UnimplementedError();

  @override
  U get token => JwtAuthService._config.tokenStorage.read();

  @override
  bool get isAuthenticated => _isAuthenticated;
}
