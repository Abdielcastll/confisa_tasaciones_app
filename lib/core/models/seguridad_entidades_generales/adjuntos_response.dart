import 'dart:convert';

AdjuntosResponse adjuntosResponseFromJson(String str) =>
    AdjuntosResponse.fromJson(json.decode(str));

String adjuntosResponseToJson(AdjuntosResponse data) =>
    json.encode(data.toJson());

class AdjuntosResponse {
  AdjuntosResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<AdjuntosData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory AdjuntosResponse.fromJson(Map<String, dynamic> json) =>
      AdjuntosResponse(
          data: json["data"]
              .map<AdjuntosData>((e) => AdjuntosData.fromJson(e))
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

class AdjuntosData {
  AdjuntosData({required this.id, required this.descripcion});

  String descripcion;
  int id;

  factory AdjuntosData.fromJson(Map<String, dynamic> json) => AdjuntosData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {"id": id, "descripcion": descripcion};
}

AdjuntosResponse adjuntosPOSTResponseFromJson(String str) =>
    AdjuntosResponse.fromJson(json.decode(str));

String adjuntosPOSTResponseToJson(AdjuntosResponse data) =>
    json.encode(data.toJson());

class AdjuntosPOSTResponse {
  AdjuntosPOSTResponse({required this.data});

  bool data;

  factory AdjuntosPOSTResponse.fromJson(Map<String, dynamic> json) =>
      AdjuntosPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
