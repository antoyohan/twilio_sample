import 'dart:async';

import 'package:flutter/material.dart';
import 'package:twilio_sample/models/network.dart';
import 'package:twilio_sample/models/token_request.dart';
import 'package:twilio_sample/models/token_response.dart';
import 'package:twilio_sample/repository/services/network_interface.dart';
import 'package:twilio_sample/repository/user_repository.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

abstract class AuthenticationRepo {
  Future<void> login({@required String name, @required String password});
}

class AuthenticationRepoImpl implements AuthenticationRepo {
  final _controller = StreamController<AuthenticationStatus>();

  AuthenticationRepoImpl(this._networkService, this._userRepo);

  NetworkService _networkService;
  UserRepo _userRepo;

  Stream<AuthenticationStatus> get status async* {
    yield* _controller.stream;
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();

  @override
  Future<void> login({String name, String password}) async {
    _controller.add(AuthenticationStatus.unauthenticated);
    Response response =
        await _networkService.getToken(TokenRequest(name: name, password: ""));

    if (response.statusCode == 200) {
      await saveUserInfo(response);
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  Future<void> saveUserInfo(Response response) async{
    TokenResponse tokenResponse = response.data as TokenResponse;
    await _userRepo.setName(tokenResponse.name);
    await _userRepo.setToken(tokenResponse.token);
    await _userRepo.setId(tokenResponse.identity);
  }
}
