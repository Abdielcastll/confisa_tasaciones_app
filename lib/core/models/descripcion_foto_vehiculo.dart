// To parse this JSON data, do
//
//     final descripcionFotoVehiculos = descripcionFotoVehiculosFromJson(jsonString);

import 'dart:convert';

List<TipoFotoVehiculos> descripcionFotoVehiculosFromJson(String str) =>
    List<TipoFotoVehiculos>.from(
        json.decode(str).map((x) => TipoFotoVehiculos.fromJson(x)));

String descripcionFotoVehiculosToJson(List<TipoFotoVehiculos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TipoFotoVehiculos {
  TipoFotoVehiculos({
    this.id,
    this.esFotoVehiculo,
    this.descripcion,
    this.orden,
    this.prefijo,
  });

  int? id;
  int? esFotoVehiculo;
  String? descripcion;
  int? orden;
  String? prefijo;

  factory TipoFotoVehiculos.fromJson(Map<String, dynamic> json) =>
      TipoFotoVehiculos(
        id: json["id"],
        esFotoVehiculo: json["esFotoVehiculo"],
        descripcion: json["descripcion"],
        orden: json["orden"],
        prefijo: json["prefijo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "esFotoVehiculo": esFotoVehiculo,
        "descripcion": descripcion,
        "orden": orden,
        "prefijo": prefijo,
      };
}
