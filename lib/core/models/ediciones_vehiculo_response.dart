// To parse this JSON data, do
//
//     final edicionVehiculo = edicionVehiculoFromJson(jsonString);

import 'dart:convert';

List<EdicionVehiculo> edicionVehiculoFromJson(String str) =>
    List<EdicionVehiculo>.from(
        json.decode(str).map((x) => EdicionVehiculo.fromJson(x)));

String edicionVehiculoToJson(List<EdicionVehiculo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EdicionVehiculo {
  EdicionVehiculo({
    this.id,
    this.idModeloEasyBank,
    this.descripcionEasyBank,
    this.codigoEasyBank,
  });

  int? id;
  int? idModeloEasyBank;
  String? descripcionEasyBank;
  int? codigoEasyBank;

  factory EdicionVehiculo.fromJson(Map<String, dynamic> json) =>
      EdicionVehiculo(
        id: json["id"],
        idModeloEasyBank: json["idModeloEasyBank"],
        descripcionEasyBank: json["descripcionEasyBank"],
        codigoEasyBank: json["codigoEasyBank"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idModeloEasyBank": idModeloEasyBank,
        "descripcionEasyBank": descripcionEasyBank,
        "codigoEasyBank": codigoEasyBank,
      };
}
