import 'dart:convert';

AccionesPendientesResponse accionesPendientesResponseFromJson(String str) =>
    AccionesPendientesResponse.fromJson(json.decode(str));

String accionesPendientesResponseToJson(AccionesPendientesResponse data) =>
    json.encode(data.toJson());

class AccionesPendientesResponse {
  AccionesPendientesResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<AccionesPendientesData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory AccionesPendientesResponse.fromJson(Map<String, dynamic> json) =>
      AccionesPendientesResponse(
          data: json["data"]
              .map<AccionesPendientesData>(
                  (e) => AccionesPendientesData.fromJson(e))
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

class AccionesPendientesData {
  AccionesPendientesData({required this.id, required this.descripcion});

  String descripcion;
  int id;

  factory AccionesPendientesData.fromJson(Map<String, dynamic> json) =>
      AccionesPendientesData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {"id": id, "descipcion": descripcion};
}

AccionesPendientesResponse accionesPendientesPOSTResponseFromJson(String str) =>
    AccionesPendientesResponse.fromJson(json.decode(str));

String accionesPendientesPOSTResponseToJson(AccionesPendientesResponse data) =>
    json.encode(data.toJson());

class AccionesPendientesPOSTResponse {
  AccionesPendientesPOSTResponse({required this.data});

  bool data;

  factory AccionesPendientesPOSTResponse.fromJson(Map<String, dynamic> json) =>
      AccionesPendientesPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
