import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:haweyati/src/models/user_model.dart';
import 'package:hive/hive.dart';

import 'http/basics/request-type.dart';
import 'package:haweyati/src/common/models/serializable.dart';
import 'package:haweyati/src/common/services/easy-rest/easy-rest.dart';

abstract class JwtStorage<T> {
  FutureOr<T> read();
  FutureOr<void> clear();
  FutureOr<void> write(T data);
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

  @override
  $signIn(Serializable data) async {
    var resp;

    try {
      resp = await _service.$raw(
        data: data,
        type: JwtAuthService._config.signInRequest.type,
        route: JwtAuthService._config.signInRequest.endpoint
      );
    } on DioError catch (error) {
      print(error.message);
      print(error.response);
      if (error.response.statusCode == 401) throw UnAuthorizedError();
    }

    JwtAuthService._config.tokenStorage.write(
      JwtAuthService._config.tokenParser(resp)
    );

    try {
      await $user();
    } on HiveError catch (err) {
      print(err.message);
      print(err.stackTrace.toString());
      rethrow;
    }
    _isAuthenticated = true;
    print(_isAuthenticated);
  }

  @override
  $signOut() async {
    try {
      await _service.$raw(
        type: JwtAuthService._config.signOutRequest.type,
        route: JwtAuthService._config.signOutRequest.endpoint
      );
    } catch (err) {}

    await JwtAuthService._config.userStorage.clear();
    await JwtAuthService._config.tokenStorage.clear();
    print('signing-out');
    _isAuthenticated = false;
  }

  @override
  $user() async {
    final resp = await _service.$raw(
      type: JwtAuthService._config.userRequest.type,
      route: JwtAuthService._config.userRequest.endpoint
    );
    final user = await _service.$raw(
      type: RequestType.get,
      route: 'customers/getProfile/${resp['profile']['contact']}'
    );

    user['profile'] = resp['profile'];
    User _user = JwtAuthService._config.userParser(user);

    _user.profile.token = await FirebaseMessaging().getToken();
    await _service.$patch(
      endpoint: 'persons',
      payload: _user.profile
    );

    await JwtAuthService._config.userStorage.write(_user);
  }

  @override
  T get user => JwtAuthService._config.userStorage.read();

  @override
  U get token => JwtAuthService._config.tokenStorage.read();

  @override
  bool get isAuthenticated => _isAuthenticated;
}

class UnAuthorizedError implements Exception {}
