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

class ComponentesVehiculoSuplidorData {
  ComponentesVehiculoSuplidorData(
      {required this.id,
      required this.componentesDescripcion,
      required this.estado,
      required this.idComponentes,
      required this.idSuplidor,
      required this.suplidorDescripcion});

  String componentesDescripcion, suplidorDescripcion;
  int id, idComponentes, idSuplidor, estado;

  factory ComponentesVehiculoSuplidorData.fromJson(Map<String, dynamic> json) =>
      ComponentesVehiculoSuplidorData(
        id: json["id"] ?? 0,
        idComponentes: json["idComponentes"] ?? 0,
        idSuplidor: json["idSuplidor"] ?? 0,
        estado: json["estado"] ?? 0,
        componentesDescripcion: json["componenteDescripcion"] ?? '',
        suplidorDescripcion: json["suplidorDescripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idComponentes": idComponentes,
        "idSuplidor": idSuplidor,
        "estado": estado,
        "componentesDescripcion": componentesDescripcion,
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
