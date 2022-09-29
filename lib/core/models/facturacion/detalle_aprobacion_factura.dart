// To parse this JSON data, do
//
//     final detalleAprobacionFactura = detalleAprobacionFacturaFromJson(jsonString);

import 'dart:convert';

List<DetalleAprobacionFactura> detalleAprobacionFacturaFromJson(String str) =>
    List<DetalleAprobacionFactura>.from(
        json.decode(str).map((x) => DetalleAprobacionFactura.fromJson(x)));

String detalleAprobacionFacturaToJson(List<DetalleAprobacionFactura> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetalleAprobacionFactura {
  DetalleAprobacionFactura({
    this.id,
    this.idFactura,
    this.idAprobador,
    this.orden,
    this.estadoAprobacion,
    this.fecha,
    this.descripcionEstado,
    this.nombreAprobador,
  });

  int? id;
  int? idFactura;
  String? idAprobador;
  String? nombreAprobador;
  String? descripcionEstado;
  int? orden;
  int? estadoAprobacion;
  DateTime? fecha;

  factory DetalleAprobacionFactura.fromJson(Map<String, dynamic> json) =>
      DetalleAprobacionFactura(
        id: json["id"],
        idFactura: json["idFactura"],
        idAprobador: json["idAprobador"],
        orden: json["orden"],
        estadoAprobacion: json["estadoAprobacion"],
        nombreAprobador: json["nombreAprobador"],
        descripcionEstado: json["descripcionEstado"],
        fecha: DateTime.parse(json["fecha"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idFactura": idFactura,
        "idAprobador": idAprobador,
        "orden": orden,
        "estadoAprobacion": estadoAprobacion,
        "descripcionEstado": descripcionEstado,
        "nombreAprobador": nombreAprobador,
        "fecha": fecha?.toIso8601String(),
      };
}
