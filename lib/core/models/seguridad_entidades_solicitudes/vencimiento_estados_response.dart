import 'dart:convert';

VencimientoEstadosResponse vencimientoEstadosResponseFromJson(String str) =>
    VencimientoEstadosResponse.fromJson(json.decode(str));

String vencimientoEstadosResponseToJson(VencimientoEstadosResponse data) =>
    json.encode(data.toJson());

class VencimientoEstadosResponse {
  VencimientoEstadosResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<VencimientoEstadosData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory VencimientoEstadosResponse.fromJson(Map<String, dynamic> json) =>
      VencimientoEstadosResponse(
          data: json["data"]
              .map<VencimientoEstadosData>(
                  (e) => VencimientoEstadosData.fromJson(e))
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

class VencimientoEstadosData {
  VencimientoEstadosData(
      {required this.id,
      required this.estadoDescripcion,
      required this.estadoId,
      required this.periodo});

  String estadoDescripcion;
  int id, estadoId, periodo;

  factory VencimientoEstadosData.fromJson(Map<String, dynamic> json) =>
      VencimientoEstadosData(
        id: json["id"] ?? 0,
        estadoId: json["estadoId"] ?? 0,
        estadoDescripcion: json["estadoDescripcion"] ?? '',
        periodo: json["periodo"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "estadoDescripcion": estadoDescripcion,
        "estadoId": estadoId,
        "periodo": periodo,
      };
}

VencimientoEstadosResponse vencimientoEstadosPOSTResponseFromJson(String str) =>
    VencimientoEstadosResponse.fromJson(json.decode(str));

String vencimientoEstadosPOSTResponseToJson(VencimientoEstadosResponse data) =>
    json.encode(data.toJson());

class VencimientoEstadosPOSTResponse {
  VencimientoEstadosPOSTResponse({required this.data});

  bool data;

  factory VencimientoEstadosPOSTResponse.fromJson(Map<String, dynamic> json) =>
      VencimientoEstadosPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
