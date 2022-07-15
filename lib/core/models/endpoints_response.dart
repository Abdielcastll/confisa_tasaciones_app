import 'dart:convert';

import 'package:tasaciones_app/core/models/permisos_response.dart';

EndpointsResponse endpointsResponseFromJson(String str) =>
    EndpointsResponse.fromJson(json.decode(str));

String endpointsResponseToJson(EndpointsResponse data) =>
    json.encode(data.toJson());

class EndpointsResponse {
  EndpointsResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<EndpointsData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory EndpointsResponse.fromJson(Map<String, dynamic> json) =>
      EndpointsResponse(
          data: json["data"]
              .map<EndpointsData>((e) => EndpointsData.fromJson(e))
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

class EndpointsData {
  EndpointsData(
      {required this.id,
      required this.nombre,
      required this.controlador,
      required this.estado,
      required this.httpVerbo,
      required this.metodo,
      required this.permiso});

  String nombre, controlador, metodo, httpVerbo;
  int id;
  bool estado;
  PermisosData permiso;

  factory EndpointsData.fromJson(Map<String, dynamic> json) => EndpointsData(
        id: json["id"] ?? 0,
        nombre: json["nombre"] ?? '',
        controlador: json["controlador"] ?? '',
        metodo: json["metodo"] ?? '',
        httpVerbo: json["httpVerbo"] ?? '',
        estado: json["estado"] ?? false,
        permiso: PermisosData.fromJson(json["permiso"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "controlador": controlador,
        "metodo": metodo,
        "httpVerbo": httpVerbo,
        "estado": estado,
        "permiso": permiso,
      };
}

EndpointsResponse endpointsPOSTResponseFromJson(String str) =>
    EndpointsResponse.fromJson(json.decode(str));

String endpointsPOSTResponseToJson(EndpointsResponse data) =>
    json.encode(data.toJson());

class EndpointsPOSTResponse {
  EndpointsPOSTResponse({required this.data});

  bool data;

  factory EndpointsPOSTResponse.fromJson(Map<String, dynamic> json) =>
      EndpointsPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
