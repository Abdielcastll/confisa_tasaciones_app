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
    this.traccion,
    this.numeroPuertas,
    this.numeroCilindros,
    this.fuerzaMotriz,
    this.serie,
    this.idSerie,
    this.trim,
    this.idTrim,
  });

  int? codigoMarca;
  String? marca;
  int? codigoModelo;
  String? modelo;
  String? ano;
  String? tipoVehiculo;
  String? sistemaCambio;
  String? traccion;
  String? numeroPuertas;
  String? numeroCilindros;
  String? fuerzaMotriz;
  String? serie;
  int? idSerie;
  String? trim;
  int? idTrim;

  factory VinDecoderData.fromJson(Map<String, dynamic> json) => VinDecoderData(
        codigoMarca: json["codigoMarca"],
        marca: json["marca"],
        codigoModelo: json["codigoModelo"],
        modelo: json["modelo"],
        ano: json["ano"],
        tipoVehiculo: json["tipoVehiculo"],
        sistemaCambio: json["sistemaCambio"],
        traccion: json["traccion"],
        numeroPuertas: json["numeroPuertas"],
        numeroCilindros: json["numeroCilindros"],
        fuerzaMotriz: json["fuerzaMotriz"],
        serie: json["serie"],
        idSerie: json["idSerie"],
        trim: json["trim"],
        idTrim: json["idTrim"],
      );
  // factory VinDecoderData.fromJson(Map<String, dynamic> json) => VinDecoderData(
  //       codigoMarca: json["codigoMarca"] == '' ? null : json["codigoMarca"],
  //       marca: json["marca"] == '' ? null : json["marca"],
  //       codigoModelo: json["codigoModelo"] == '' ? null : json["codigoModelo"],
  //       modelo: json["modelo"] == '' ? null : json["modelo"],
  //       ano: json["ano"] == '' ? null : json["ano"],
  //       tipoVehiculo: json["tipoVehiculo"] == '' ? null : json["tipoVehiculo"],
  //       sistemaCambio:
  //           json["sistemaCambio"] == '' ? null : json["sistemaCambio"],
  //       traccion: json["traccion"] == '' ? null : json["traccion"],
  //       numeroPuertas:
  //           json["numeroPuertas"] == '' ? null : json["numeroPuertas"],
  //       numeroCilindros:
  //           json["numeroCilindros"] == '' ? null : json["numeroCilindros"],
  //       fuerzaMotriz: json["fuerzaMotriz"] == '' ? null : json["fuerzaMotriz"],
  //       serie: json["serie"] == '' ? null : json["serie"],
  //       idSerie: json["idSerie"] == '' ? null : json["idSerie"],
  //       trim: json["trim"] == '' ? null : json["trim"],
  //       idTrim: json["idTrim"] == '' ? null : json["idTrim"],
  //     );

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
      };
}
