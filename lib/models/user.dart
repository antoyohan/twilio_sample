
class User {
  final String _id;
  final String _token;

  static User _user;

  User._internal(this._id, this._token);

  factory User(String name, String token) {
    if (_user == null) {
      _user = User._internal(name, token);
    }
    return _user;
  }
}
