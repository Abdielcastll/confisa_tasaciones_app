import 'dart:convert';

AuditoriaResponse auditoriaResponseFromJson(String str) =>
    AuditoriaResponse.fromJson(json.decode(str));

String auditoriaResponseToJson(AuditoriaResponse data) =>
    json.encode(data.toJson());

class AuditoriaResponse {
  AuditoriaResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<AuditoriaData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory AuditoriaResponse.fromJson(Map<String, dynamic> json) =>
      AuditoriaResponse(
          data: json["data"]
              .map<AuditoriaData>((e) => AuditoriaData.fromJson(e))
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

class AuditoriaData {
  AuditoriaData(
      {required this.id,
      required this.columnasAfectadas,
      required this.fecha,
      required this.nombreTabla,
      required this.primaryKey,
      required this.tipo,
      required this.userId,
      required this.valoresAnteriores,
      required this.valoresNuevos});

  String userId,
      tipo,
      nombreTabla,
      fecha,
      valoresAnteriores,
      valoresNuevos,
      columnasAfectadas,
      primaryKey;
  int id;

  factory AuditoriaData.fromJson(Map<String, dynamic> json) => AuditoriaData(
        id: json["id"] ?? 0,
        userId: json["userId"] ?? '',
        tipo: json["tipo"] ?? '',
        nombreTabla: json["nombreTabla"] ?? '',
        fecha: json["fecha"] ?? '',
        valoresAnteriores: json["valoresAnteriores"] ?? '',
        valoresNuevos: json["valoresNuevos"] ?? '',
        columnasAfectadas: json["columnasAfectadas"] ?? '',
        primaryKey: json["primaryKey"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "tipo": tipo,
        "nombreTabla": nombreTabla,
        "fecha": fecha,
        "valoresAnteriores": valoresAnteriores,
        "valoresNuevos": valoresNuevos,
        "columnasAfectadas": columnasAfectadas,
        "primaryKey": primaryKey
      };
}

AuditoriaResponse auditoriaPOSTResponseFromJson(String str) =>
    AuditoriaResponse.fromJson(json.decode(str));

String auditoriaPOSTResponseToJson(AuditoriaResponse data) =>
    json.encode(data.toJson());

class AuditoriaPOSTResponse {
  AuditoriaPOSTResponse({required this.data});

  bool data;

  factory AuditoriaPOSTResponse.fromJson(Map<String, dynamic> json) =>
      AuditoriaPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
