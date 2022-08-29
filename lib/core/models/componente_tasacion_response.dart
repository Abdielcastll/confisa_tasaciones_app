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
    this.idSolicitud,
    this.idComponenteVehiculo,
    this.descripcionComponenteVehiculo,
    this.idCondicionComponenteVehiculo,
    this.descripcionCondicionComponenteVehiculo,
  });

  int? id;
  int? idSolicitud;
  int? idComponenteVehiculo;
  String? descripcionComponenteVehiculo;
  int? idCondicionComponenteVehiculo;
  String? descripcionCondicionComponenteVehiculo;

  factory ComponenteTasacion.fromJson(Map<String, dynamic> json) =>
      ComponenteTasacion(
        id: json["id"],
        idSolicitud: json["idSolicitud"],
        idComponenteVehiculo: json["idComponenteVehiculo"],
        descripcionComponenteVehiculo: json["descripcionComponenteVehiculo"],
        idCondicionComponenteVehiculo: json["idCondicionComponenteVehiculo"],
        descripcionCondicionComponenteVehiculo:
            json["descripcionCondicionComponenteVehiculo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idSolicitud": idSolicitud,
        "idComponenteVehiculo": idComponenteVehiculo,
        "descripcionComponenteVehiculo": descripcionComponenteVehiculo,
        "idCondicionComponenteVehiculo": idCondicionComponenteVehiculo,
        "descripcionCondicionComponenteVehiculo":
            descripcionCondicionComponenteVehiculo,
      };
}
