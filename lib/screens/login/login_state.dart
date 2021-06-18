import 'package:twilio_sample/models/network.dart';

class LoginState {}

class Loading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final Error error;

  LoginFailure({this.error});
}

class UnknownState extends LoginState {}
