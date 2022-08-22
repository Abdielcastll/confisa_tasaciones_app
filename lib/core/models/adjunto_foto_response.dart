// To parse this JSON data, do
//
//     final adjuntosFotoResponse = adjuntosFotoResponseFromJson(jsonString);

import 'dart:convert';

AdjuntosFotoResponse adjuntosFotoResponseFromJson(String str) =>
    AdjuntosFotoResponse.fromJson(json.decode(str));

String adjuntosFotoResponseToJson(AdjuntosFotoResponse data) =>
    json.encode(data.toJson());

class AdjuntosFotoResponse {
  AdjuntosFotoResponse({
    required this.data,
  });

  List<AdjuntoFoto> data;

  factory AdjuntosFotoResponse.fromJson(Map<String, dynamic> json) =>
      AdjuntosFotoResponse(
        data: List<AdjuntoFoto>.from(
            json["data"].map((x) => AdjuntoFoto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AdjuntoFoto {
  AdjuntoFoto({
    required this.id,
    required this.adjunto,
    required this.descripcion,
  });

  int id;
  String adjunto;
  String descripcion;

  factory AdjuntoFoto.fromJson(Map<String, dynamic> json) => AdjuntoFoto(
        id: json["id"],
        adjunto: json["adjunto"],
        descripcion: json["infoAdjuntos"][0]["descripcion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "adjunto": adjunto,
        "descripcion": descripcion,
      };
}
