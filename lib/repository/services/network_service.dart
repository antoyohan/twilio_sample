import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:twilio_sample/models/network.dart';
import 'package:twilio_sample/models/token_request.dart';
import 'package:twilio_sample/models/token_response.dart';
import 'package:twilio_sample/utils/Strings.dart';

import 'network_interface.dart';

const TAG = "network_service";

class NetworkService implements NetworkInterface {
  @override
  Future<Response> getToken(TokenRequest request) async {
    developer.log("getToken", name: TAG);
    var response = await http.get(Uri.parse(Strings.TOKEN_URL));
    if (response.statusCode == 201) {
      return Success<TokenResponse>(
          TokenResponse.fromMap(jsonDecode(response.body)),
          response.statusCode);
    } else {
      return Error(response.statusCode);
    }
  }
}
