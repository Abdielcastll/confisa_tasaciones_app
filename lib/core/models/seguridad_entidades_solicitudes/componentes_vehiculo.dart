import 'dart:convert';

ComponentesVehiculoResponse componentesVehiculoResponseFromJson(String str) =>
    ComponentesVehiculoResponse.fromJson(json.decode(str));

String componentesVehiculoResponseToJson(ComponentesVehiculoResponse data) =>
    json.encode(data.toJson());

class ComponentesVehiculoResponse {
  ComponentesVehiculoResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<ComponentesVehiculoData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory ComponentesVehiculoResponse.fromJson(Map<String, dynamic> json) =>
      ComponentesVehiculoResponse(
          data: json["data"]
              .map<ComponentesVehiculoData>(
                  (e) => ComponentesVehiculoData.fromJson(e))
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

class ComponentesVehiculoData {
  ComponentesVehiculoData(
      {required this.id,
      required this.descripcion,
      required this.idSegmento,
      required this.segmentoDescripcion});

  String descripcion, segmentoDescripcion;
  int id, idSegmento;

  factory ComponentesVehiculoData.fromJson(Map<String, dynamic> json) =>
      ComponentesVehiculoData(
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

ComponentesVehiculoResponse componentesVehiculoPOSTResponseFromJson(
        String str) =>
    ComponentesVehiculoResponse.fromJson(json.decode(str));

String componentesVehiculoPOSTResponseToJson(
        ComponentesVehiculoResponse data) =>
    json.encode(data.toJson());

class ComponentesVehiculoPOSTResponse {
  ComponentesVehiculoPOSTResponse({required this.data});

  bool data;

  factory ComponentesVehiculoPOSTResponse.fromJson(Map<String, dynamic> json) =>
      ComponentesVehiculoPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
