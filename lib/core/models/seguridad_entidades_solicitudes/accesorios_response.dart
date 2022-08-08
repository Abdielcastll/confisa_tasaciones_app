import 'dart:convert';

AccesoriosResponse accesoriosResponseFromJson(String str) =>
    AccesoriosResponse.fromJson(json.decode(str));

String accesoriosResponseToJson(AccesoriosResponse data) =>
    json.encode(data.toJson());

class AccesoriosResponse {
  AccesoriosResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<AccesoriosData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory AccesoriosResponse.fromJson(Map<String, dynamic> json) =>
      AccesoriosResponse(
          data: json["data"]
              .map<AccesoriosData>((e) => AccesoriosData.fromJson(e))
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

class AccesoriosData {
  AccesoriosData(
      {required this.id,
      required this.descripcion,
      required this.idSegmento,
      required this.segmentoDescripcion});

  String descripcion, segmentoDescripcion;
  int id, idSegmento;

  factory AccesoriosData.fromJson(Map<String, dynamic> json) => AccesoriosData(
        id: json["id"] ?? 0,
        idSegmento: json["idSegmento"] ?? 0,
        segmentoDescripcion: json["segmentoDescripcion"] ?? '',
        descripcion: json["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "idSegmento": idSegmento,
        "segmentoDescripcion": segmentoDescripcion,
      };
}

AccesoriosResponse accesoriosPOSTResponseFromJson(String str) =>
    AccesoriosResponse.fromJson(json.decode(str));

String accesoriosPOSTResponseToJson(AccesoriosResponse data) =>
    json.encode(data.toJson());

class AccesoriosPOSTResponse {
  AccesoriosPOSTResponse({required this.data});

  bool data;

  factory AccesoriosPOSTResponse.fromJson(Map<String, dynamic> json) =>
      AccesoriosPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
