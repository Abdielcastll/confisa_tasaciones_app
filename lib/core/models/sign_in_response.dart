import 'dart:convert';

SignInResponse signInResponseFromJson(String str) =>
    SignInResponse.fromJson(json.decode(str));

String signInResponseToJson(SignInResponse data) => json.encode(data.toJson());

class SignInResponse {
  SignInResponse({
    required this.data,
  });

  SignInData data;

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
        data: SignInData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class SignInData {
  SignInData({
    required this.token,
    required this.refreshToken,
    required this.refreshTokenExpiryTime,
    required this.email,
    required this.nombreCompleto,
    required this.role,
  });

  String token;
  String refreshToken;
  DateTime refreshTokenExpiryTime;
  String email;
  String nombreCompleto;
  List<String> role;

  factory SignInData.fromJson(Map<String, dynamic> json) => SignInData(
        token: json["token"] ?? '',
        refreshToken: json["refreshToken"] ?? '',
        refreshTokenExpiryTime:
            DateTime.parse(json["refreshTokenExpiryTime"] ?? ''),
        email: json["email"] ?? '',
        nombreCompleto: json["nombreCompleto"] ?? '',
        role: List<String>.from(json["role"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "refreshToken": refreshToken,
        "refreshTokenExpiryTime": refreshTokenExpiryTime.toIso8601String(),
        "email": email,
        "nombreCompleto": nombreCompleto,
        "role": List<dynamic>.from(role.map((x) => x)),
      };
}
