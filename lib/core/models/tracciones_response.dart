// To parse this JSON data, do
//
//     final tranccionesResponse = tranccionesResponseFromJson(jsonString);

import 'dart:convert';

TraccionesResponse tranccionesResponseFromJson(String str) =>
    TraccionesResponse.fromJson(json.decode(str));

String tranccionesResponseToJson(TraccionesResponse data) =>
    json.encode(data.toJson());

class TraccionesResponse {
  TraccionesResponse({
    required this.data,
  });

  List<TraccionesData> data;

  factory TraccionesResponse.fromJson(Map<String, dynamic> json) =>
      TraccionesResponse(
        data: List<TraccionesData>.from(
            json["data"].map((x) => TraccionesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TraccionesData {
  TraccionesData({
    required this.id,
    required this.descripcion,
    this.descripcion2,
  });

  int id;
  String descripcion;
  String? descripcion2;

  factory TraccionesData.fromJson(Map<String, dynamic> json) => TraccionesData(
        id: json["id"],
        descripcion: json["descripcion"],
        descripcion2: json["descripcion2"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "descripcion2": descripcion2,
      };
}
