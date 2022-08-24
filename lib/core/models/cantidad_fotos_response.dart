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

EntidadResponse entidadPOSTResponseFromJson(String str) =>
    EntidadResponse.fromJson(json.decode(str));

String entidadPOSTResponseToJson(EntidadResponse data) =>
    json.encode(data.toJson());

class EntidadPOSTResponse {
  EntidadPOSTResponse({required this.data});

  bool data;

  factory EntidadPOSTResponse.fromJson(Map<String, dynamic> json) =>
      EntidadPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}

OpcionesTiposResponse opcionesTiposResponseFromJson(String str) =>
    OpcionesTiposResponse.fromJson(json.decode(str));

String opcionesTiposResponseToJson(EntidadResponse data) =>
    json.encode(data.toJson());

class OpcionesTiposResponse {
  OpcionesTiposResponse({
    required this.data,
  });

  OpcionesTiposData data;

  factory OpcionesTiposResponse.fromJson(Map<String, dynamic> json) =>
      OpcionesTiposResponse(
        data: OpcionesTiposData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class OpcionesTiposData {
  OpcionesTiposData(
      {required this.id,
      required this.descripcionCatalogoParametros,
      required this.codigoEntidad,
      required this.descripcionEntidad,
      required this.valor});

  int id;
  String descripcionEntidad,
      codigoEntidad,
      descripcionCatalogoParametros,
      valor;

  factory OpcionesTiposData.fromJson(Map<String, dynamic> json) =>
      OpcionesTiposData(
          id: json["id"] ?? 0,
          codigoEntidad: json["codigoEntidad"] ?? '',
          descripcionEntidad: json["descripcionEntidad"] ?? '',
          descripcionCatalogoParametros:
              json["descripcionCatalogoParametros"] ?? '',
          valor: json["valor"] ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "codigoEntidad": codigoEntidad,
        "descripcionEntidad": descripcionEntidad,
        "descripcionCatalogoParametros": descripcionCatalogoParametros,
        "valor": valor
      };
}
