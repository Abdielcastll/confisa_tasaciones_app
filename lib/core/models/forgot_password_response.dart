class ForgotPasswordResponse {
  ForgotPasswordResponse({
    required this.data,
  });

  Data data;

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponse(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.email,
    required this.token,
  });

  String email;
  String token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json["email"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "token": token,
      };
}
