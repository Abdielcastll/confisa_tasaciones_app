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
    this.valor,
    this.fuente,
    this.resultado,
    this.mensaje,
  });

  double? valor;
  String? fuente;
  bool? resultado;
  String? mensaje;

  factory ReferenciaValoracion.fromJson(Map<String, dynamic> json) =>
      ReferenciaValoracion(
        valor: json["valor"],
        fuente: json["fuente"],
        resultado: json["resultado"],
        mensaje: json["mensaje"],
      );

  Map<String, dynamic> toJson() => {
        "valor": valor,
        "fuente": fuente,
        "resultado": resultado,
        "mensaje": mensaje,
      };
}
