import 'dart:convert';

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
  MenuData({required this.id, required this.nombre, this.recursos});

  String nombre;
  int id;
  List<MenuRecursoData>? recursos;

  factory MenuData.fromJson(Map<String, dynamic> json) => MenuData(
      id: json["id"] ?? 0,
      nombre: json["nombre"] ?? '',
      recursos: json["recursos"]
          .map<MenuRecursoData>((e) => MenuRecursoData.fromJson(e))
          .toList());

  Map<String, dynamic> toJson() => {"id": id, "nombre": nombre};
}

class MenuRecursoData {
  MenuRecursoData({
    required this.id,
    required this.nombre,
    this.recursos,
    this.moduloPadre,
    required this.url,
  });

  String nombre, url;
  int id;
  int? moduloPadre;
  List<MenuRecursoData>? recursos;

  factory MenuRecursoData.fromJson(Map<String, dynamic> json) =>
      MenuRecursoData(
          id: json["id"],
          nombre: json["nombre"],
          moduloPadre: json["moduloPadre"] ?? 0,
          url: json["url"] ?? "",
          recursos: json["recursos"] != null
              ? json["recursos"]
                  .map<MenuRecursoData>((e) => MenuRecursoData.fromJson(e))
                  .toList()
              : null);

  Map<String, dynamic> toJson() => {"id": id, "nombre": nombre};
}
