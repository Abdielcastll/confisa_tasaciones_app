import 'dart:convert';

CondicionesComponentesVehiculoResponse
    condicionesComponentesVehiculoResponseFromJson(String str) =>
        CondicionesComponentesVehiculoResponse.fromJson(json.decode(str));

String condicionesComponentesVehiculoResponseToJson(
        CondicionesComponentesVehiculoResponse data) =>
    json.encode(data.toJson());

class CondicionesComponentesVehiculoResponse {
  CondicionesComponentesVehiculoResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<CondicionesComponentesVehiculoData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory CondicionesComponentesVehiculoResponse.fromJson(
          Map<String, dynamic> json) =>
      CondicionesComponentesVehiculoResponse(
          data: json["data"]
              .map<CondicionesComponentesVehiculoData>(
                  (e) => CondicionesComponentesVehiculoData.fromJson(e))
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

class CondicionesComponentesVehiculoData {
  CondicionesComponentesVehiculoData(
      {required this.id, required this.descripcion});

  String descripcion;
  int id;

  factory CondicionesComponentesVehiculoData.fromJson(
          Map<String, dynamic> json) =>
      CondicionesComponentesVehiculoData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
      };
}

CondicionesComponentesVehiculoResponse
    condicionesComponentesVehiculoPOSTResponseFromJson(String str) =>
        CondicionesComponentesVehiculoResponse.fromJson(json.decode(str));

String condicionesComponentesVehiculoPOSTResponseToJson(
        CondicionesComponentesVehiculoResponse data) =>
    json.encode(data.toJson());

class CondicionesComponentesVehiculoPOSTResponse {
  CondicionesComponentesVehiculoPOSTResponse({required this.data});

  bool data;

  factory CondicionesComponentesVehiculoPOSTResponse.fromJson(
          Map<String, dynamic> json) =>
      CondicionesComponentesVehiculoPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
