class SignInResponse {
  SignInResponse({
    required this.data,
  });

  Session data;

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
        data: Session.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"data": data.toJson()};
}

class Session {
  Session(
      {required this.token,
      required this.refreshToken,
      required this.refreshTokenExpiryTime,
      required this.tokenExpiryTime,
      required this.email,
      required this.nombreCompleto,
      required this.role,
      required this.typeRol});

  String token;
  String refreshToken;
  int typeRol;
  DateTime refreshTokenExpiryTime;
  DateTime tokenExpiryTime;
  String email;
  String nombreCompleto;
  List<String> role;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        token: json["token"] ?? '',
        refreshToken: json["refreshToken"] ?? '',
        refreshTokenExpiryTime:
            DateTime.parse(json["refreshTokenExpiryTime"] ?? ''),
        tokenExpiryTime: DateTime.parse(json["tokenExpiryTime"] ?? ''),
        email: json["email"] ?? '',
        typeRol: json["typeRol"] ?? 0,
        nombreCompleto: json["nombreCompleto"] ?? '',
        role: List<String>.from(json["role"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "refreshToken": refreshToken,
        "refreshTokenExpiryTime": refreshTokenExpiryTime.toIso8601String(),
        "tokenExpiryTime": tokenExpiryTime.toIso8601String(),
        "email": email,
        "nombreCompleto": nombreCompleto,
        "typeRol": typeRol,
        "role": List<dynamic>.from(role.map((x) => x)),
      };
}
