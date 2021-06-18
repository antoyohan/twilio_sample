import 'dart:collection';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:twilio_sample/models/network.dart';
import 'package:twilio_sample/models/token_request.dart';
import 'package:twilio_sample/models/token_response.dart';
import 'package:twilio_sample/utils/string_contants.dart';

import 'network_interface.dart';

const TAG = "network_service";

class NetworkServiceImpl extends NetworkService {
  @override
  Future<Response> getToken(TokenRequest request) async {

    Map<String, String> queryParameters = HashMap();
    queryParameters.putIfAbsent("identity", () => request.name);
    queryParameters.putIfAbsent("password", () => 'password');
    var uri = Uri.http(Strings.TOKEN_URL, Strings.PATH, queryParameters);
    developer.log("get Token uri ${uri.toString()}", name: TAG);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      developer.log("response ${response.body}", name: TAG);
      return Success<TokenResponse>(response.statusCode,
          TokenResponse.fromMap(jsonDecode(response.body)));
    } else {
      developer.log("error ${response.statusCode}", name: TAG);
      return Error(response.statusCode, "Failed");
    }

   /* TokenResponse response = TokenResponse(identity: request.name, token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzBlNjNmOGE3NTU3YzQxMmJiODQ1NTIzMGMwMzY0ZDM5LTE2MjM5OTA5ODIiLCJncmFudHMiOnsiaWRlbnRpdHkiOiJnIiwiY2hhdCI6eyJzZXJ2aWNlX3NpZCI6IklTYTUyYmZjNDk5Y2Q2NDJmMGFlODk0YTUzN2U0OWI3NjgifX0sImlhdCI6MTYyMzk5MDk4MiwiZXhwIjoxNjIzOTk0NTgyLCJpc3MiOiJTSzBlNjNmOGE3NTU3YzQxMmJiODQ1NTIzMGMwMzY0ZDM5Iiwic3ViIjoiQUMzMzkzY2YwMzgzZTE0N2E1MzM4NmUyOGM1MGJhYjU1NCJ9.ZFIEhz2NF-JUD7r7ZXd7mmb-pCR76HYz1FbxWd9aeV0", name: request.name);
    return Future.value(Success<TokenResponse>(200, response));*/
  }
}
