import 'package:twilio_sample/models/network.dart';
import 'package:twilio_sample/models/token_request.dart';
import 'dart:developer' as developer;

abstract class NetworkService {
  Future<Response> getToken(TokenRequest request);

  void printResponse(Response response) {
    developer.log(response.data.toString());
  }
}