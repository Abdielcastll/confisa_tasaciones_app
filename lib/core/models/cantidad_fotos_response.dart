// To parse this JSON data, do
//
//     final cantidadFotosResponse = cantidadFotosResponseFromJson(jsonString);

import 'dart:convert';

EntidadResponse cantidadFotosResponseFromJson(String str) =>
    EntidadResponse.fromJson(json.decode(str));

String cantidadFotosResponseToJson(EntidadResponse data) =>
    json.encode(data.toJson());

class EntidadResponse {
  EntidadResponse({
    required this.data,
  });

  EntidadData data;

  factory EntidadResponse.fromJson(Map<String, dynamic> json) =>
      EntidadResponse(
        data: EntidadData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class EntidadData {
  EntidadData({
    this.id,
    this.descripcion,
  });

  int? id;
  String? descripcion;

  factory EntidadData.fromJson(Map<String, dynamic> json) => EntidadData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
      };
}
