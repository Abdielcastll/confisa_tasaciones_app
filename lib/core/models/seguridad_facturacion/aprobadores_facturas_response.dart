import 'dart:convert';

import 'package:tasaciones_app/core/models/roles_response.dart';

AprobadoresFacturasResponse aprobadoresFacturasResponseFromJson(String str) =>
    AprobadoresFacturasResponse.fromJson(json.decode(str));

String aprobadoresFacturasResponseToJson(AprobadoresFacturasResponse data) =>
    json.encode(data.toJson());

class AprobadoresFacturasResponse {
  AprobadoresFacturasResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<AprobadoresFacturasData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory AprobadoresFacturasResponse.fromJson(Map<String, dynamic> json) =>
      AprobadoresFacturasResponse(
          data: json["data"]
              .map<AprobadoresFacturasData>(
                  (e) => AprobadoresFacturasData.fromJson(e))
              .toList(),
          totalCount: json["meta"]["totalCount"],
          totalPages: json["meta"]["totalPages"],
          pageSize: json["meta"]["pageSize"],
          currentPage: json["meta"]["currentPage"],
          hasNextPage: json["meta"]["hasNextPage"],
          hasPreviousPage: json["meta"]["hasPreviousPage"],
          nextPageUrl: json["meta"]["nextPageUrl"]);

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()),
        "totalCount": totalCount,
        "totalPage": totalPages,
        "pageSize": pageSize,
        "currentPage": currentPage,
        "hasNextPage": hasNextPage,
        "hasPreviousPage": hasPreviousPage,
        "nextPageUrl": totalCount,
      };
}

class AprobadoresFacturasData {
  AprobadoresFacturasData(
      {required this.id,
      required this.email,
      required this.emailConfirmed,
      required this.firtsName,
      required this.imageUrl,
      required this.isActive,
      required this.lastName,
      required this.nombreCompleto,
      required this.phoneNumber,
      required this.userName,
      required this.roles,
      required this.estadoAprobadorFactura,
      required this.idOficial});

  String id,
      userName,
      firtsName,
      lastName,
      email,
      phoneNumber,
      imageUrl,
      nombreCompleto;
  List<RolData2> roles;
  bool isActive, emailConfirmed, estadoAprobadorFactura;
  int idOficial;

  factory AprobadoresFacturasData.fromJson(Map<String, dynamic> json) =>
      AprobadoresFacturasData(
        id: json["id"] ?? '',
        userName: json["userName"] ?? '',
        firtsName: json["firtsName"] ?? '',
        lastName: json["lastName"] ?? '',
        email: json["email"] ?? '',
        phoneNumber: json["phoneNumber"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
        nombreCompleto: json["nombreCompleto"] ?? '',
        isActive: json["isActive"] ?? false,
        emailConfirmed: json["emailConfirmed"] ?? false,
        estadoAprobadorFactura: json["estadoAprobadorFactura"] ?? false,
        idOficial: json["idOficial"] ?? 0,
        roles:
            json["roles"].map<RolData2>((e) => RolData2.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "firtsName": firtsName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "imageUrl": imageUrl,
        "nombreCompleto": nombreCompleto,
        "isActive": isActive,
        "emailConfirmed": emailConfirmed,
        "estadoAprobadorFactura": estadoAprobadorFactura,
        "idOficial": idOficial,
        "roles": List<dynamic>.from(roles.map((x) => x)),
      };
}

AprobadoresFacturasResponse aprobadoresFacturasPOSTResponseFromJson(
        String str) =>
    AprobadoresFacturasResponse.fromJson(json.decode(str));

String aprobadoresFacturasPOSTResponseToJson(
        AprobadoresFacturasResponse data) =>
    json.encode(data.toJson());

class AprobadoresFacturasPOSTResponse {
  AprobadoresFacturasPOSTResponse({required this.data});

  bool data;

  factory AprobadoresFacturasPOSTResponse.fromJson(Map<String, dynamic> json) =>
      AprobadoresFacturasPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
