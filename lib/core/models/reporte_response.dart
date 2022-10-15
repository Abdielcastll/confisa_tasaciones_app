// To parse this JSON data, do
//
//     final reporte = reporteFromJson(jsonString);

import 'dart:convert';

Reporte reporteFromJson(String str) => Reporte.fromJson(json.decode(str));

String reporteToJson(Reporte data) => json.encode(data.toJson());

class Reporte {
  Reporte({
    this.reporteNombre,
    this.byteArrayImg,
  });

  String? reporteNombre;
  String? byteArrayImg;

  factory Reporte.fromJson(Map<String, dynamic> json) => Reporte(
        reporteNombre: json["reporteNombre"],
        byteArrayImg: json["byteArrayImg"],
      );

  Map<String, dynamic> toJson() => {
        "reporteNombre": reporteNombre,
        "byteArrayImg": byteArrayImg,
      };
}
