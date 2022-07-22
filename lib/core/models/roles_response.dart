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
  RolData({required this.id, required this.name, required this.description});

  String id;
  String name;
  String description;

  factory RolData.fromJson(Map<String, dynamic> json) => RolData(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        description: json["description"] ?? '',
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

class RolData2 {
  RolData2(
      {required this.roleId,
      required this.roleName,
      required this.description,
      required this.enabled});

  String roleId;
  String roleName;
  String description;
  bool enabled;

  factory RolData2.fromJson(Map<String, dynamic> json) => RolData2(
        roleId: json["roleId"] ?? '',
        roleName: json["roleName"] ?? '',
        description: json["description"] ?? '',
        enabled: json["enabled"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "roleId": roleId,
        "roleName": roleName,
        "description": description,
        "enabled": enabled
      };
}
