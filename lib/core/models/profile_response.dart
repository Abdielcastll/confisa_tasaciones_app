// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

import 'package:tasaciones_app/core/models/permisos_response.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';

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
  Profile(
      {this.id,
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
      this.roles});

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
  List<RolData2>? roles;

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
        roles:
            json["roles"].map<RolData2>((e) => RolData2.fromJson(e)).toList(),
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
        "roles": List<dynamic>.from(roles!.map((x) => x)),
      };
}

ProfilePermisoResponse profilePermisoResponseFromJson(String str) =>
    ProfilePermisoResponse.fromJson(json.decode(str));

String profilePermisoResponseToJson(ProfilePermisoResponse data) =>
    json.encode(data.toJson());

class ProfilePermisoResponse {
  ProfilePermisoResponse({
    required this.data,
  });

  List<ProfilePermiso> data;

  factory ProfilePermisoResponse.fromJson(Map<String, dynamic> json) =>
      ProfilePermisoResponse(
        data: json["data"]
            .map<ProfilePermiso>((e) => ProfilePermiso.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}

class ProfilePermiso {
  ProfilePermiso(
      {required this.id,
      required this.name,
      required this.description,
      required this.permisos,
      required this.typeRol,
      required this.typeRolDescription});

  String id;
  String name;
  String description;
  String typeRolDescription;
  int typeRol;
  List<PermisosData>? permisos;

  factory ProfilePermiso.fromJson(Map<String, dynamic> json) => ProfilePermiso(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        typeRol: json["typeRol"] ?? 0,
        typeRolDescription: json["typeRolDescription"] ?? '',
        permisos: json["permisos"]
            .map<PermisosData>((e) => PermisosData.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "typeRol": typeRol,
        "permisos": List<dynamic>.from(permisos!.map((x) => x)),
      };
}
