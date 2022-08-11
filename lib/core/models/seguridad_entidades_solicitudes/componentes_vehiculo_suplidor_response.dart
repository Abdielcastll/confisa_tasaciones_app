import 'dart:convert';

ComponentesVehiculoSuplidorResponse componentesVehiculoSuplidorResponseFromJson(
        String str) =>
    ComponentesVehiculoSuplidorResponse.fromJson(json.decode(str));

String componentesVehiculoSuplidorResponseToJson(
        ComponentesVehiculoSuplidorResponse data) =>
    json.encode(data.toJson());

class ComponentesVehiculoSuplidorResponse {
  ComponentesVehiculoSuplidorResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<ComponentesVehiculoSuplidorData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory ComponentesVehiculoSuplidorResponse.fromJson(
          Map<String, dynamic> json) =>
      ComponentesVehiculoSuplidorResponse(
          data: json["data"]
              .map<ComponentesVehiculoSuplidorData>(
                  (e) => ComponentesVehiculoSuplidorData.fromJson(e))
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

class ComponentesVehiculoSuplidorResponseSinMeta {
  ComponentesVehiculoSuplidorResponseSinMeta({
    required this.data,
  });

  List<ComponentesVehiculoSuplidorData> data;

  factory ComponentesVehiculoSuplidorResponseSinMeta.fromJson(
          Map<String, dynamic> json) =>
      ComponentesVehiculoSuplidorResponseSinMeta(
        data: json["data"]
            .map<ComponentesVehiculoSuplidorData>(
                (e) => ComponentesVehiculoSuplidorData.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()),
      };
}

class ComponentesVehiculoSuplidorData {
  ComponentesVehiculoSuplidorData(
      {required this.id,
      required this.componenteDescripcion,
      required this.estado,
      required this.idComponente,
      required this.idSuplidor,
      required this.suplidorDescripcion});

  String componenteDescripcion, suplidorDescripcion;
  int id, idComponente, idSuplidor, estado;

  factory ComponentesVehiculoSuplidorData.fromJson(Map<String, dynamic> json) =>
      ComponentesVehiculoSuplidorData(
        id: json["id"] ?? 0,
        idComponente: json["idComponente"] ?? 0,
        idSuplidor: json["idSuplidor"] ?? 0,
        estado: json["estado"] ?? 0,
        componenteDescripcion: json["componenteDescripcion"] ?? '',
        suplidorDescripcion: json["suplidorDescripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idComponente": idComponente,
        "idSuplidor": idSuplidor,
        "estado": estado,
        "componenteDescripcion": componenteDescripcion,
        "suplidorDescripcion": suplidorDescripcion
      };
}

ComponentesVehiculoSuplidorResponse
    componentesVehiculoSuplidorPOSTResponseFromJson(String str) =>
        ComponentesVehiculoSuplidorResponse.fromJson(json.decode(str));

String componentesVehiculoSuplidorPOSTResponseToJson(
        ComponentesVehiculoSuplidorResponse data) =>
    json.encode(data.toJson());

class ComponentesVehiculoSuplidorPOSTResponse {
  ComponentesVehiculoSuplidorPOSTResponse({required this.data});

  bool data;

  factory ComponentesVehiculoSuplidorPOSTResponse.fromJson(
          Map<String, dynamic> json) =>
      ComponentesVehiculoSuplidorPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
