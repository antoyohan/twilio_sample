import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_sample/repository/authentication_repository.dart';
import 'package:twilio_sample/screens/login/login_event.dart';
import 'package:twilio_sample/screens/login/login_state.dart';

const String TAG = "login_bloc";

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LoginState initialState, AuthenticationRepo repo)
      : super(initialState) {
    authRepo = repo;
  }

  AuthenticationRepoImpl authRepo;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginSubmitted) {
      yield Loading();
      initialiseLogin(event);
    } else if (event is LoginSuccess) {
      yield LoginSuccess();
    }
  }

  void initialiseLogin(LoginSubmitted event) async {
    developer.log("login Submitted", name: TAG);
    authRepo.status.listen((status) {
      developer.log("login status $status", name: TAG);
      if (status == AuthenticationStatus.authenticated) {
        add(LoginComplete());
      }
    });
    authRepo.login(name: event.userName, password: '');
  }

  @override
  Future<void> close() {
    authRepo.dispose();
    return super.close();
  }
}
