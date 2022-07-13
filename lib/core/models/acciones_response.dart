import 'dart:convert';

AccionesResponse accionesResponseFromJson(String str) =>
    AccionesResponse.fromJson(json.decode(str));

String accionesResponseToJson(AccionesResponse data) =>
    json.encode(data.toJson());

class AccionesResponse {
  AccionesResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<AccionesData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory AccionesResponse.fromJson(Map<String, dynamic> json) =>
      AccionesResponse(
          data: json["data"]
              .map<AccionesData>((e) => AccionesData.fromJson(e))
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

class AccionesData {
  AccionesData({required this.id, required this.estado, required this.nombre});

  String nombre;
  int id, estado;

  factory AccionesData.fromJson(Map<String, dynamic> json) => AccionesData(
      id: json["id"] ?? 0,
      estado: json["estado"] ?? 0,
      nombre: json["nombre"] ?? '');

  Map<String, dynamic> toJson() =>
      {"id": id, "estado": estado, "nombre": nombre};
}
