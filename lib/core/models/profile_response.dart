// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  ProfileResponse({
    required this.data,
  });

  Profile data;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        data: Profile.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Profile {
  Profile({
    this.id,
    this.userName,
    this.firstName,
    this.lastName,
    this.email,
    this.isActive,
    this.emailConfirmed,
    this.phoneNumber,
    this.imageUrl,
    this.nombreCompleto,
    this.idSuplidor,
    this.nombreSuplidor,
    this.empresa,
  });

  String? id;
  String? userName;
  String? firstName;
  String? lastName;
  String? email;
  bool? isActive;
  bool? emailConfirmed;
  String? phoneNumber;
  String? imageUrl;
  String? nombreCompleto;
  int? idSuplidor;
  String? nombreSuplidor;
  String? empresa;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"] ?? '',
        userName: json["userName"] ?? '',
        firstName: json["firstName"] ?? '',
        lastName: json["lastName"] ?? '',
        email: json["email"] ?? '',
        isActive: json["isActive"] ?? false,
        emailConfirmed: json["emailConfirmed"] ?? false,
        phoneNumber: json["phoneNumber"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
        nombreCompleto: json["nombreCompleto"] ?? '',
        idSuplidor: json["idSuplidor"] ?? 0,
        nombreSuplidor: json["nombreSuplidor"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "isActive": isActive,
        "emailConfirmed": emailConfirmed,
        "phoneNumber": phoneNumber,
        "imageUrl": imageUrl,
        "nombreCompleto": nombreCompleto,
        "idSuplidor": idSuplidor,
        "nombreSuplidor": nombreSuplidor,
      };
}
