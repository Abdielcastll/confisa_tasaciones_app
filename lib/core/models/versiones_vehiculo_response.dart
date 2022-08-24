// To parse this JSON data, do
//
//     final tipoCondicionesVehiculosResponse = tipoCondicionesVehiculosResponseFromJson(jsonString);

import 'dart:convert';

VersionesVehiculoResponse versionCondicionesVehiculosResponseFromJson(
        String str) =>
    VersionesVehiculoResponse.fromJson(json.decode(str));

String versionCondicionesVehiculosResponseToJson(
        VersionesVehiculoResponse data) =>
    json.encode(data.toJson());

class VersionesVehiculoResponse {
  VersionesVehiculoResponse({
    required this.data,
  });

  List<VersionVehiculoData> data;

  factory VersionesVehiculoResponse.fromJson(Map<String, dynamic> json) =>
      VersionesVehiculoResponse(
        data: List<VersionVehiculoData>.from(
            json["data"].map((x) => VersionVehiculoData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class VersionVehiculoData {
  VersionVehiculoData({
    required this.id,
    required this.descripcion,
  });

  int id;
  String descripcion;

  factory VersionVehiculoData.fromJson(Map<String, dynamic> json) =>
      VersionVehiculoData(
        id: json["id"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
      };
}
