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
    developer.log("getToken", name: TAG);
    var response = await http.get(Uri.parse(Strings.TOKEN_URL));
    if (response.statusCode == 201) {
      printResponse(response as Response);
      return Success<TokenResponse>(response.statusCode,
          TokenResponse.fromMap(jsonDecode(response.body)));
    } else {
      return Error(response.statusCode, "Failed");
    }
    /*TokenResponse response = TokenResponse(request.name, "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzBlNjNmOGE3NTU3YzQxMmJiODQ1NTIzMGMwMzY0ZDM5LTE2MjM2OTA4NTIiLCJncmFudHMiOnsiaWRlbnRpdHkiOiJkc2QiLCJjaGF0Ijp7InNlcnZpY2Vfc2lkIjoiSVNhNTJiZmM0OTljZDY0MmYwYWU4OTRhNTM3ZTQ5Yjc2OCJ9fSwiaWF0IjoxNjIzNjkwODUyLCJleHAiOjE2MjM2OTQ0NTIsImlzcyI6IlNLMGU2M2Y4YTc1NTdjNDEyYmI4NDU1MjMwYzAzNjRkMzkiLCJzdWIiOiJBQzMzOTNjZjAzODNlMTQ3YTUzMzg2ZTI4YzUwYmFiNTU0In0.0ITTXQrIaWleU6WxoJUFY2w7TvchF8uxEbYFbONyubc", request.name);
    return Future.value(Success<TokenResponse>(201, response));*/
  }
}
