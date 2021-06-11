import 'package:twilio_sample/models/network.dart';
import 'package:twilio_sample/models/token_request.dart';

abstract class NetworkInterface {
  Future<Response> getToken(TokenRequest request);
}