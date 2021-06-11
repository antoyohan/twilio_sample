import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:twilio_sample/models/network.dart';
import 'package:twilio_sample/models/token_request.dart';
import 'package:twilio_sample/models/token_response.dart';
import 'package:twilio_sample/utils/Strings.dart';

import 'network_interface.dart';

const TAG = "network_service";

class NetworkServiceImpl extends NetworkService {
  @override
  Future<Response> getToken(TokenRequest request) async {
    developer.log("getToken", name: TAG);
    /*var response = await http.get(Uri.parse(Strings.TOKEN_URL));
    if (response.statusCode == 201) {
      printResponse(response as Response);
      return Success<TokenResponse>(response.statusCode,
          TokenResponse.fromMap(jsonDecode(response.body)));
    } else {
      return Error(response.statusCode, "Failed");
    }*/
    //todo Remove this Bypass
    TokenResponse response = TokenResponse(request.name, "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzBlNjNmOGE3NTU3YzQxMmJiODQ1NTIzMGMwMzY0ZDM5LTE2MjM0MjMwNjQiLCJncmFudHMiOnsiaWRlbnRpdHkiOiJBbnRvIiwiY2hhdCI6eyJzZXJ2aWNlX3NpZCI6IklTYTUyYmZjNDk5Y2Q2NDJmMGFlODk0YTUzN2U0OWI3NjgifX0sImlhdCI6MTYyMzQyMzA2NCwiZXhwIjoxNjIzNDI2NjY0LCJpc3MiOiJTSzBlNjNmOGE3NTU3YzQxMmJiODQ1NTIzMGMwMzY0ZDM5Iiwic3ViIjoiQUMzMzkzY2YwMzgzZTE0N2E1MzM4NmUyOGM1MGJhYjU1NCJ9.BWizUyoNXmVK5qsBd9CG8yDE8mIxpIf_dXAZORWdVeE", "Test");
    return Future.value(Success<TokenResponse>(201, response));
  }
}
