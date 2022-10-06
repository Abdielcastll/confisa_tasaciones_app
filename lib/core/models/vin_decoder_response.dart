// To parse this JSON data, do
//
//     final vinDecoderResponse = vinDecoderResponseFromJson(jsonString);

import 'dart:convert';

VinDecoderResponse vinDecoderResponseFromJson(String str) =>
    VinDecoderResponse.fromJson(json.decode(str));

String vinDecoderResponseToJson(VinDecoderResponse data) =>
    json.encode(data.toJson());

class VinDecoderResponse {
  VinDecoderResponse({
    required this.data,
  });

  VinDecoderData data;

  factory VinDecoderResponse.fromJson(Map<String, dynamic> json) =>
      VinDecoderResponse(
        data: VinDecoderData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class VinDecoderData {
  VinDecoderData({
    this.codigoMarca,
    this.marca,
    this.codigoModelo,
    this.modelo,
    this.ano,
    this.tipoVehiculo,
    this.sistemaCambio,
    this.idSistemaCambio,
    this.traccion,
    this.idTraccion,
    this.numeroPuertas,
    this.numeroCilindros,
    this.fuerzaMotriz,
    this.serie,
    this.idSerie,
    this.trim,
    this.idTrim,
    this.message,
  });

  int? codigoMarca;
  String? marca;
  int? codigoModelo;
  String? modelo;
  int? ano;
  String? tipoVehiculo;
  String? sistemaCambio;
  int? idSistemaCambio;
  String? traccion;
  int? idTraccion;
  int? numeroPuertas;
  int? numeroCilindros;
  int? fuerzaMotriz;
  String? serie;
  int? idSerie;
  String? trim;
  int? idTrim;
  String? message;

  factory VinDecoderData.fromJson(Map<String, dynamic> json) => VinDecoderData(
        codigoMarca: json["codigoMarca"],
        marca: json["marca"],
        codigoModelo: json["codigoModelo"],
        modelo: json["modelo"],
        ano: int.tryParse(json["ano"] ?? ''),
        tipoVehiculo: json["tipoVehiculo"],
        sistemaCambio: json["sistemaCambio"],
        traccion: json["traccion"],
        numeroPuertas: int.tryParse(json["numeroPuertas"] ?? ''),
        numeroCilindros: int.tryParse(json["numeroCilindros"] ?? ''),
        fuerzaMotriz: double.tryParse(json["fuerzaMotriz"] ?? '')?.round(),
        serie: json["serie"],
        idSerie: json["idSerie"],
        trim: json["trim"],
        idTrim: json["idTrim"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "codigoMarca": codigoMarca,
        "marca": marca,
        "codigoModelo": codigoModelo,
        "modelo": modelo,
        "ano": ano,
        "tipoVehiculo": tipoVehiculo,
        "sistemaCambio": sistemaCambio,
        "traccion": traccion,
        "numeroPuertas": numeroPuertas,
        "numeroCilindros": numeroCilindros,
        "fuerzaMotriz": fuerzaMotriz,
        "serie": serie,
        "idSerie": idSerie,
        "trim": trim,
        "idTrim": idTrim,
        "message": message,
      };
}
