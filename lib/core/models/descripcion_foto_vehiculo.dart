// To parse this JSON data, do
//
//     final descripcionFotoVehiculos = descripcionFotoVehiculosFromJson(jsonString);

import 'dart:convert';

List<DescripcionFotoVehiculos> descripcionFotoVehiculosFromJson(String str) =>
    List<DescripcionFotoVehiculos>.from(
        json.decode(str).map((x) => DescripcionFotoVehiculos.fromJson(x)));

String descripcionFotoVehiculosToJson(List<DescripcionFotoVehiculos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DescripcionFotoVehiculos {
  DescripcionFotoVehiculos({
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

  factory DescripcionFotoVehiculos.fromJson(Map<String, dynamic> json) =>
      DescripcionFotoVehiculos(
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
