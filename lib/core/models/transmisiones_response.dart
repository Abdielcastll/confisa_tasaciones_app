// To parse this JSON data, do
//
//     final transmisionesResponse = transmisionesResponseFromJson(jsonString);

import 'dart:convert';

TransmisionesResponse transmisionesResponseFromJson(String str) =>
    TransmisionesResponse.fromJson(json.decode(str));

String transmisionesResponseToJson(TransmisionesResponse data) =>
    json.encode(data.toJson());

class TransmisionesResponse {
  TransmisionesResponse({
    required this.data,
  });

  List<TransmisionesData> data;

  factory TransmisionesResponse.fromJson(Map<String, dynamic> json) =>
      TransmisionesResponse(
        data: List<TransmisionesData>.from(
            json["data"].map((x) => TransmisionesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TransmisionesData {
  TransmisionesData({
    required this.id,
    required this.descripcion,
  });

  int id;
  String descripcion;

  factory TransmisionesData.fromJson(Map<String, dynamic> json) =>
      TransmisionesData(
        id: json["id"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
      };
}
