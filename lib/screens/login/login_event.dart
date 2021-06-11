abstract class LoginEvent{}

class LoginSubmitted extends LoginEvent{
  String userName;

  LoginSubmitted(this.userName);
}

class LoginComplete extends LoginEvent{}

class LoginFailed extends LoginEvent{}