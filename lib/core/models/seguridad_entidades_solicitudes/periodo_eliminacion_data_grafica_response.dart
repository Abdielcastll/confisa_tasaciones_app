import 'dart:convert';

PeriodoEliminacionDataGraficaResponse
    periodoEliminacionDataGraficaResponseFromJson(String str) =>
        PeriodoEliminacionDataGraficaResponse.fromJson(json.decode(str));

String periodoEliminacionDataGraficaResponseToJson(
        PeriodoEliminacionDataGraficaResponse data) =>
    json.encode(data.toJson());

class PeriodoEliminacionDataGraficaResponse {
  PeriodoEliminacionDataGraficaResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<PeriodoEliminacionDataGraficaData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory PeriodoEliminacionDataGraficaResponse.fromJson(
          Map<String, dynamic> json) =>
      PeriodoEliminacionDataGraficaResponse(
          data: json["data"]
              .map<PeriodoEliminacionDataGraficaData>(
                  (e) => PeriodoEliminacionDataGraficaData.fromJson(e))
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

class PeriodoEliminacionDataGraficaData {
  PeriodoEliminacionDataGraficaData(
      {required this.id, required this.descripcion});

  String descripcion;
  int id;

  factory PeriodoEliminacionDataGraficaData.fromJson(
          Map<String, dynamic> json) =>
      PeriodoEliminacionDataGraficaData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
      };
}

PeriodoEliminacionDataGraficaResponse
    periodoEliminacionDataGraficaPOSTResponseFromJson(String str) =>
        PeriodoEliminacionDataGraficaResponse.fromJson(json.decode(str));

String periodoEliminacionDataGraficaPOSTResponseToJson(
        PeriodoEliminacionDataGraficaResponse data) =>
    json.encode(data.toJson());

class PeriodoEliminacionDataGraficaPOSTResponse {
  PeriodoEliminacionDataGraficaPOSTResponse({required this.data});

  bool data;

  factory PeriodoEliminacionDataGraficaPOSTResponse.fromJson(
          Map<String, dynamic> json) =>
      PeriodoEliminacionDataGraficaPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
