// To parse this JSON data, do
//
//     final factura = facturaFromJson(jsonString);

import 'dart:convert';

List<Factura> facturaFromJson(String str) =>
    List<Factura>.from(json.decode(str).map((x) => Factura.fromJson(x)));

String facturaToJson(List<Factura> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Factura {
  Factura({
    this.id,
    this.noFactura,
    this.idSuplidor,
    this.idEstado,
    this.tipoFactura,
    this.periodoFacturacionInicial,
    this.periodoFacturacionFinal,
    this.ncf,
    this.codigoEntidad,
    this.subTotal,
    this.itbis,
    this.totalHonorarios,
    this.totalApagar,
    this.descripcionEntidad,
    this.descripcionEstado,
    this.descripcionSuplidor,
  });

  int? id;
  int? noFactura;
  int? idSuplidor;
  int? idEstado;
  int? tipoFactura;
  DateTime? periodoFacturacionInicial;
  DateTime? periodoFacturacionFinal;
  String? ncf;
  String? codigoEntidad;
  String? descripcionEntidad;
  String? descripcionSuplidor;
  String? descripcionEstado;
  double? subTotal;
  double? itbis;
  double? totalHonorarios;
  double? totalApagar;

  factory Factura.fromJson(Map<String, dynamic> json) => Factura(
        id: json["id"],
        noFactura: json["noFactura"],
        idSuplidor: json["idSuplidor"],
        idEstado: json["idEstado"],
        tipoFactura: json["tipoFactura"],
        periodoFacturacionInicial:
            DateTime.parse(json["periodoFacturacionInicial"]),
        periodoFacturacionFinal:
            DateTime.parse(json["periodoFacturacionFinal"]),
        ncf: json["ncf"],
        codigoEntidad: json["codigoEntidad"],
        subTotal: json["subTotal"],
        itbis: json["itbis"],
        totalHonorarios: json["totalHonorarios"],
        totalApagar: json["totalApagar"],
        descripcionEntidad: json["descripcionEntidad"],
        descripcionEstado: json["descripcionEstado"],
        descripcionSuplidor: json["descripcionSuplidor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "noFactura": noFactura,
        "idSuplidor": idSuplidor,
        "idEstado": idEstado,
        "tipoFactura": tipoFactura,
        "periodoFacturacionInicial":
            periodoFacturacionInicial?.toIso8601String(),
        "periodoFacturacionFinal": periodoFacturacionFinal?.toIso8601String(),
        "ncf": ncf,
        "codigoEntidad": codigoEntidad,
        "subTotal": subTotal,
        "itbis": itbis,
        "totalHonorarios": totalHonorarios,
        "totalApagar": totalApagar,
        "descripcionEntidad": descripcionEntidad,
        "descripcionEstado": descripcionEstado,
        "descripcionSuplidor": descripcionSuplidor,
      };
}
