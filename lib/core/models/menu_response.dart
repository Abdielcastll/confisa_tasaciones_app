import 'dart:convert';

import 'package:tasaciones_app/core/models/recursos_response.dart';

MenuResponse menuResponseFromJson(String str) =>
    MenuResponse.fromJson(json.decode(str));

String menuResponseToJson(MenuResponse data) => json.encode(data.toJson());

class MenuResponse {
  MenuResponse({required this.data});

  List<MenuData> data;

  factory MenuResponse.fromJson(Map<String, dynamic> json) => MenuResponse(
        data: json["data"].map<MenuData>((e) => MenuData.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()).toList(),
      };
}

class MenuData {
  MenuData({required this.id, required this.nombre, required this.recursos});

  String nombre;
  int id;
  List<MenuRecursoData> recursos;

  factory MenuData.fromJson(Map<String, dynamic> json) => MenuData(
      id: json["id"] ?? 0,
      nombre: json["nombre"] ?? '',
      recursos: json["recursos"]
          .map<MenuRecursoData>((e) => MenuRecursoData.fromJson(e))
          .toList());

  Map<String, dynamic> toJson() => {"id": id, "nombre": nombre};
}

class MenuRecursoData {
  MenuRecursoData(
      {required this.id,
      required this.nombre,
      required this.recursos,
      this.moduloPadre});

  String nombre;
  int id;
  int? moduloPadre;
  List<RecursosData> recursos;

  factory MenuRecursoData.fromJson(Map<String, dynamic> json) =>
      MenuRecursoData(
          id: json["id"] ?? 0,
          nombre: json["nombre"] ?? '',
          moduloPadre: json["moduloPadre"],
          recursos: json["recursos"] != null
              ? json["recursos"]
                  .map<RecursosData>((e) => RecursosData.fromJson(e))
                  .toList()
              : []);

  Map<String, dynamic> toJson() => {"id": id, "nombre": nombre};
}
