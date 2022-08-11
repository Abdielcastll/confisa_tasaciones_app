// To parse this JSON data, do
//
//     final tipoCondicionesVehiculosResponse = tipoCondicionesVehiculosResponseFromJson(jsonString);

import 'dart:convert';

TipoVehiculoResponse tipoCondicionesVehiculosResponseFromJson(String str) =>
    TipoVehiculoResponse.fromJson(json.decode(str));

String tipoCondicionesVehiculosResponseToJson(TipoVehiculoResponse data) =>
    json.encode(data.toJson());

class TipoVehiculoResponse {
  TipoVehiculoResponse({
    required this.data,
  });

  List<TipoVehiculoData> data;

  factory TipoVehiculoResponse.fromJson(Map<String, dynamic> json) =>
      TipoVehiculoResponse(
        data: List<TipoVehiculoData>.from(
            json["data"].map((x) => TipoVehiculoData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TipoVehiculoData {
  TipoVehiculoData({
    required this.id,
    required this.descripcion,
    required this.codigoEasyBank,
  });

  int id;
  String descripcion;
  int codigoEasyBank;

  factory TipoVehiculoData.fromJson(Map<String, dynamic> json) =>
      TipoVehiculoData(
        id: json["id"],
        descripcion: json["descripcion"],
        codigoEasyBank: json["codigoEasyBank"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "codigoEasyBank": codigoEasyBank,
      };
}
