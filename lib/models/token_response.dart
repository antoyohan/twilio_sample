class TokenResponse {
  final String identity;
  final String token;

  TokenResponse(this.identity, this.token);

  factory TokenResponse.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    } else {
      return TokenResponse(data["identity"], data["token"]);
    }
  }
}
