import 'dart:convert';

RolClaimsResponse rolClaimsResponseFromJson(String str) =>
    RolClaimsResponse.fromJson(json.decode(str));

String rolClaimsResponseToJson(RolClaimsResponse data) =>
    json.encode(data.toJson());

class RolClaimsResponse {
  RolClaimsResponse({
    required this.data,
  });

  List<RolClaimsData> data;

  factory RolClaimsResponse.fromJson(Map<String, dynamic> json) =>
      RolClaimsResponse(
        data: json["data"]["permisos"]
            .map<RolClaimsData>((e) => RolClaimsData.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()),
      };
}

class RolClaimsResponseGet {
  RolClaimsResponseGet({
    required this.data,
  });

  List<RolClaimsDataGet> data;

  factory RolClaimsResponseGet.fromJson(Map<String, dynamic> json) =>
      RolClaimsResponseGet(
        data: json["data"]
            .map<RolClaimsDataGet>((e) => RolClaimsDataGet.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()),
      };
}

class RolClaimsData {
  RolClaimsData({required this.id, required this.descripcion});

  int id;
  String descripcion;

  factory RolClaimsData.fromJson(Map<String, dynamic> json) => RolClaimsData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
      };
}

class RolClaimsDataGet {
  RolClaimsDataGet({required this.id, required this.descripcion});

  int id;
  String descripcion;

  factory RolClaimsDataGet.fromJson(Map<String, dynamic> json) =>
      RolClaimsDataGet(
        id: json["permiso"]["id"] ?? 0,
        descripcion: json["permiso"]["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
      };
}
