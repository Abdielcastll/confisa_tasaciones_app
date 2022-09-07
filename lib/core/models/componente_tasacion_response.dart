// To parse this JSON data, do
//
//     final componenteTasacion = componenteTasacionFromJson(jsonString);

import 'dart:convert';

List<ComponenteTasacion> componenteTasacionFromJson(String str) =>
    List<ComponenteTasacion>.from(
        json.decode(str).map((x) => ComponenteTasacion.fromJson(x)));

String componenteTasacionToJson(List<ComponenteTasacion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ComponenteTasacion {
  ComponenteTasacion({
    this.id,
    this.idComponente,
    this.idSuplidor,
    this.componenteDescripcion,
    this.suplidorDescripcion,
    this.estado,
    this.idSegmento,
    this.descripcionSegmento,
    this.idCondicion,
    this.descripcionCondicion,
  });

  int? id;
  int? idComponente;
  int? idSuplidor;
  String? componenteDescripcion;
  String? suplidorDescripcion;
  int? idSegmento;
  String? descripcionSegmento;
  int? idCondicion;
  String? descripcionCondicion;
  int? estado;

  factory ComponenteTasacion.fromJson(Map<String, dynamic> json) =>
      ComponenteTasacion(
        id: json["id"],
        idComponente: json["idComponente"],
        idSuplidor: json["idSuplidor"],
        componenteDescripcion: json["componenteDescripcion"],
        suplidorDescripcion: json[" suplidorDescripcion"],
        idSegmento: json[" idSegmento"],
        descripcionSegmento: json[" descripcionSegmento"],
        estado: json[" estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idComponente": idComponente,
        "idSuplidor": idSuplidor,
        "componenteDescripcion": componenteDescripcion,
        "suplidorDescripcion": suplidorDescripcion,
        "idSegmento": idSegmento,
        "descripcionSegmento": descripcionSegmento,
        "estado": estado,
      };
}
