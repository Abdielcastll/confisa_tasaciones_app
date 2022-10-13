// To parse this JSON data, do
//
//     final accesoriosSuplidor = accesoriosSuplidorFromJson(jsonString);

import 'dart:convert';

List<AccesoriosSuplidor> accesoriosSuplidorFromJson(String str) =>
    List<AccesoriosSuplidor>.from(
        json.decode(str).map((x) => AccesoriosSuplidor.fromJson(x)));

String accesoriosSuplidorToJson(List<AccesoriosSuplidor> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccesoriosSuplidor {
  AccesoriosSuplidor({
    this.id,
    this.idAccesorio,
    this.idSuplidor,
    this.suplidorNombre,
    this.accesorioDescripcion,
    this.estado,
    this.isSelected = true,
  });

  int? id;
  int? idAccesorio;
  int? idSuplidor;
  String? suplidorNombre;
  String? accesorioDescripcion;
  int? estado;
  bool isSelected;

  factory AccesoriosSuplidor.fromJson(Map<String, dynamic> json) =>
      AccesoriosSuplidor(
        id: json["id"],
        idAccesorio: json["idAccesorio"],
        idSuplidor: json["idSuplidor"],
        suplidorNombre: json["suplidorNombre"],
        accesorioDescripcion: json["accesorioDescripcion"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idAccesorio": idAccesorio,
        "idSuplidor": idSuplidor,
        "suplidorNombre": suplidorNombre,
        "accesorioDescripcion": accesorioDescripcion,
        "estado": estado,
      };
}
