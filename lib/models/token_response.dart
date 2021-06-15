class TokenResponse {
  final String identity;
  final String token;
  final String name;

  TokenResponse(this.identity, this.token, this.name);

  factory TokenResponse.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    } else {
      return TokenResponse(data["identity"], data["token"], data["name"]);
    }
  }
}
