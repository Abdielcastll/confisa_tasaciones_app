// To parse this JSON data, do
//
//     final referenciaValoracion = referenciaValoracionFromJson(jsonString);

import 'dart:convert';

List<ReferenciaValoracion> referenciaValoracionFromJson(String str) =>
    List<ReferenciaValoracion>.from(
        json.decode(str).map((x) => ReferenciaValoracion.fromJson(x)));

String referenciaValoracionToJson(List<ReferenciaValoracion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReferenciaValoracion {
  ReferenciaValoracion({
    this.noSolicitud,
    this.noTasacion,
    this.fecha,
    this.valor,
    this.fuente,
    this.resultado,
    this.mensaje,
  });
  int? noSolicitud;
  int? noTasacion;
  DateTime? fecha;
  double? valor;
  String? fuente;
  bool? resultado;
  String? mensaje;

  factory ReferenciaValoracion.fromJson(Map<String, dynamic> json) =>
      ReferenciaValoracion(
        noSolicitud: json["noSolicitud"] ?? null,
        noTasacion: json["noTasacion"] ?? null,
        fecha: DateTime.tryParse(json["fecha"] ?? ''),
        valor: json["valor"],
        fuente: json["fuente"],
        resultado: json["resultado"],
        mensaje: json["mensaje"],
      );

  Map<String, dynamic> toJson() => {
        "noSolicitud": noSolicitud ?? '',
        "noTasacion": noTasacion ?? '',
        "fecha": fecha?.toIso8601String() ?? '',
        "valor": valor,
        "fuente": fuente,
        "resultado": resultado,
        "mensaje": mensaje,
      };
}
