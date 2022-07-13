import 'dart:convert';

RecursosResponse recursosResponseFromJson(String str) =>
    RecursosResponse.fromJson(json.decode(str));

String recursosResponseToJson(RecursosResponse data) =>
    json.encode(data.toJson());

class RecursosResponse {
  RecursosResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<RecursosData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory RecursosResponse.fromJson(Map<String, dynamic> json) =>
      RecursosResponse(
          data: json["data"]
              .map<RecursosData>((e) => RecursosData.fromJson(e))
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

class RecursosData {
  RecursosData(
      {required this.id,
      required this.estado,
      required this.nombre,
      required this.idModulo});

  String nombre;
  int id, estado, idModulo;

  factory RecursosData.fromJson(Map<String, dynamic> json) => RecursosData(
      id: json["id"] ?? 0,
      estado: json["estado"] ?? 0,
      idModulo: json["idModulo"] ?? 0,
      nombre: json["nombre"] ?? '');

  Map<String, dynamic> toJson() =>
      {"id": id, "estado": estado, "nombre": nombre, "idModulo": idModulo};
}
