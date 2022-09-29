import 'dart:convert';

ModulosResponse modulosResponseFromJson(String str) =>
    ModulosResponse.fromJson(json.decode(str));

String modulosResponseToJson(ModulosResponse data) =>
    json.encode(data.toJson());

class ModulosResponse {
  ModulosResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<ModulosData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory ModulosResponse.fromJson(Map<String, dynamic> json) =>
      ModulosResponse(
          data: json["data"]
              .map<ModulosData>((e) => ModulosData.fromJson(e))
              .toList(),
          totalCount: json["meta"]["totalCount"],
          totalPages: json["meta"]["totalPages"],
          pageSize: json["meta"]["pageSize"],
          currentPage: json["meta"]["currentPage"],
          hasNextPage: json["meta"]["hasNextPage"],
          hasPreviousPage: json["meta"]["hasPreviousPage"],
          nextPageUrl: json["meta"]["nextPageUrl"]);

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()),
        "totalCount": totalCount,
        "totalPage": totalPages,
        "pageSize": pageSize,
        "currentPage": currentPage,
        "hasNextPage": hasNextPage,
        "hasPreviousPage": hasPreviousPage,
        "nextPageUrl": totalCount,
      };
}

class ModulosData {
  ModulosData(
      {required this.id,
      required this.estado,
      required this.nombre,
      required this.moduloPadre,
      required this.cssIcon});

  String nombre, cssIcon;
  int id, estado, moduloPadre;

  factory ModulosData.fromJson(Map<String, dynamic> json) => ModulosData(
      id: json["id"] ?? 0,
      moduloPadre: json["moduloPadre"] ?? 0,
      estado: json["estado"] ?? 0,
      nombre: json["nombre"] ?? '',
      cssIcon: json["cssicon"] ?? '');

  Map<String, dynamic> toJson() =>
      {"id": id, "estado": estado, "nombre": nombre};
}
