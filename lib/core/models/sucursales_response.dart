import 'dart:convert';

SucursalesResponse sucursalesResponseFromJson(String str) =>
    SucursalesResponse.fromJson(json.decode(str));

String sucursalesResponseToJson(SucursalesResponse data) =>
    json.encode(data.toJson());

class SucursalesResponse {
  SucursalesResponse({
    required this.data,
  });

  List<SucursalesData> data;

  factory SucursalesResponse.fromJson(Map<String, dynamic> json) =>
      SucursalesResponse(
        data: List<SucursalesData>.from(
            json["data"].map((x) => SucursalesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SucursalesData {
  SucursalesData(
      {required this.codigoEntidad,
      required this.codigoRelacionado,
      required this.codigoSucursal,
      required this.nombre});

  int codigoRelacionado;
  String codigoSucursal, codigoEntidad, nombre;

  factory SucursalesData.fromJson(Map<String, dynamic> json) => SucursalesData(
        codigoEntidad: json["codigoEntidad"] ?? "",
        codigoRelacionado: json["codigoRelacionado"] ?? 0,
        codigoSucursal: json["codigoSucursal"] ?? "",
        nombre: json["nombre"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "codigoEntidad": codigoEntidad,
        "codigoRelacionado": codigoRelacionado,
        "codigoSucursal": codigoSucursal,
        "nombre": nombre
      };
}
