// To parse this JSON data, do
//
//     final condicionComponente = condicionComponenteFromJson(jsonString);

import 'dart:convert';

List<CondicionComponente> condicionComponenteFromJson(String str) =>
    List<CondicionComponente>.from(
        json.decode(str).map((x) => CondicionComponente.fromJson(x)));

String condicionComponenteToJson(List<CondicionComponente> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CondicionComponente {
  CondicionComponente({
    this.id,
    this.idComponente,
    this.idCondicionParametroG,
    this.condicionDescripcion,
    this.componenteDescripcion,
    this.estado,
  });

  int? id;
  int? idComponente;
  int? idCondicionParametroG;
  String? condicionDescripcion;
  String? componenteDescripcion;
  int? estado;

  factory CondicionComponente.fromJson(Map<String, dynamic> json) =>
      CondicionComponente(
        id: json["id"],
        idComponente: json["idComponente"],
        idCondicionParametroG: json["idCondicionParametroG"],
        condicionDescripcion: json["condicionDescripcion"],
        componenteDescripcion: json["componenteDescripcion"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idComponente": idComponente,
        "idCondicionParametroG": idCondicionParametroG,
        "condicionDescripcion": condicionDescripcion,
        "componenteDescripcion": componenteDescripcion,
        "estado": estado,
      };
}
