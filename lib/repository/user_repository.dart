import 'package:shared_preferences/shared_preferences.dart';
import 'package:twilio_sample/utils/Strings.dart';

abstract class UserRepo {
  Future<String> getName();

  Future<String> getToken();

  Future<String> getId();

  Future<bool> setName(String name);

  Future<bool> setToken(String token);

  Future<bool> setId(String id);
}

class UserRepoImpl implements UserRepo {
  @override
  Future<String> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(Strings.id_preference) ?? 0;
    return Future.value(id);
  }

  @override
  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString(Strings.name_preference) ?? 0;
    return Future.value(name);
  }

  @override
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(Strings.token_preference) ?? 0;
    return Future.value(token);
  }

  @override
  Future<bool> setId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Strings.id_preference, id);
  }

  @override
  Future<bool> setName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Strings.name_preference, name);
  }

  @override
  Future<bool> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Strings.token_preference, token);
  }
}
