import 'dart:convert';

RolResponse rolResponseFromJson(String str) =>
    RolResponse.fromJson(json.decode(str));

String rolResponseToJson(RolResponse data) => json.encode(data.toJson());

class RolResponse {
  RolResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<RolData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory RolResponse.fromJson(Map<String, dynamic> json) => RolResponse(
      data: json["data"].map<RolData>((e) => RolData.fromJson(e)).toList(),
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

class RolData {
  RolData(
      {required this.id,
      required this.name,
      required this.description,
      required this.typeRole,
      required this.typeRoleDescription});

  String id;
  String name;
  String description;
  int typeRole;
  String typeRoleDescription;

  factory RolData.fromJson(Map<String, dynamic> json) => RolData(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        typeRole: json["typeRole"] ?? 0,
        typeRoleDescription: json["typeRoleDescription"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}

RolResponse rolPOSTResponseFromJson(String str) =>
    RolResponse.fromJson(json.decode(str));

String rolPOSTResponseToJson(RolResponse data) => json.encode(data.toJson());

class RolPOSTResponse {
  RolPOSTResponse({required this.data});

  bool data;

  factory RolPOSTResponse.fromJson(Map<String, dynamic> json) =>
      RolPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}

class RolResponse2 {
  RolResponse2(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<RolData2> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory RolResponse2.fromJson(Map<String, dynamic> json) => RolResponse2(
      data: json["data"].map<RolData2>((e) => RolData2.fromJson(e)).toList(),
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

class RolData2 {
  RolData2(
      {required this.roleId,
      required this.roleName,
      required this.description,
      required this.enabled,
      required this.typeRol,
      required this.typeRolDescription});

  String roleId;
  String roleName;
  String description;
  String typeRolDescription;
  int typeRol;
  bool enabled;

  factory RolData2.fromJson(Map<String, dynamic> json) => RolData2(
        roleId: json["roleId"] ?? '',
        roleName: json["roleName"] ?? '',
        description: json["description"] ?? '',
        enabled: json["enabled"] ?? true,
        typeRol: json["typeRole"] ?? 0,
        typeRolDescription: json["typeRoleDescription"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "roleId": roleId,
        "roleName": roleName,
        "description": description,
        "enabled": enabled
      };
}

RolResponse rolTipeResponseFromJson(String str) =>
    RolResponse.fromJson(json.decode(str));

String rolTipeResponseToJson(RolResponse data) => json.encode(data.toJson());

class RolTipeResponse {
  RolTipeResponse({
    required this.data,
    /* required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl */
  });

  List<RolTipeData> data;
  /*  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage; */

  factory RolTipeResponse.fromJson(Map<String, dynamic> json) =>
      RolTipeResponse(
        data: json["data"]
            .map<RolTipeData>((e) => RolTipeData.fromJson(e))
            .toList(),
        /* totalCount: json["meta"]["totalCount"] ?? 0,
          totalPages: json["meta"]["totalPages"] ?? 0,
          pageSize: json["meta"]["pageSize"] ?? 0,
          currentPage: json["meta"]["currentPage"] ?? 0,
          hasNextPage: json["meta"]["hasNextPage"] ?? false,
          hasPreviousPage: json["meta"]["hasPreviousPage"] ?? false,
          nextPageUrl: json["meta"]["nextPageUrl"] ?? '' */
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()),
        /* "totalCount": totalCount,
        "totalPage": totalPages,
        "pageSize": pageSize,
        "currentPage": currentPage,
        "hasNextPage": hasNextPage,
        "hasPreviousPage": hasPreviousPage,
        "nextPageUrl": totalCount, */
      };
}

class RolTipeData {
  RolTipeData({required this.id, required this.descripcion});

  int id;
  String descripcion;

  factory RolTipeData.fromJson(Map<String, dynamic> json) => RolTipeData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
      };
}
