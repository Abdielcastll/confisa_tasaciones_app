// To parse this JSON data, do
//
//     final coloresVehiculosResponse = coloresVehiculosResponseFromJson(jsonString);

import 'dart:convert';

ColoresVehiculosResponse coloresVehiculosResponseFromJson(String str) =>
    ColoresVehiculosResponse.fromJson(json.decode(str));

String coloresVehiculosResponseToJson(ColoresVehiculosResponse data) =>
    json.encode(data.toJson());

class ColoresVehiculosResponse {
  ColoresVehiculosResponse({
    required this.data,
  });

  List<ColorVehiculo> data;

  factory ColoresVehiculosResponse.fromJson(Map<String, dynamic> json) =>
      ColoresVehiculosResponse(
        data: List<ColorVehiculo>.from(
            json["data"].map((x) => ColorVehiculo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ColorVehiculo {
  ColorVehiculo({
    required this.id,
    required this.descripcion,
    required this.estado,
  });

  int id;
  String descripcion;
  bool estado;

  factory ColorVehiculo.fromJson(Map<String, dynamic> json) => ColorVehiculo(
        id: json["id"],
        descripcion: json["descripcion"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "estado": estado,
      };
}
