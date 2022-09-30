import 'dart:convert';

DocumentosFacturacionResponse documentosFacturacionResponseFromJson(
        String str) =>
    DocumentosFacturacionResponse.fromJson(json.decode(str));

String documentosFacturacionResponseToJson(
        DocumentosFacturacionResponse data) =>
    json.encode(data.toJson());

class DocumentosFacturacionResponse {
  DocumentosFacturacionResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<DocumentosFacturacionData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory DocumentosFacturacionResponse.fromJson(Map<String, dynamic> json) =>
      DocumentosFacturacionResponse(
          data: json["data"]
              .map<DocumentosFacturacionData>(
                  (e) => DocumentosFacturacionData.fromJson(e))
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

class DocumentosFacturacionData {
  DocumentosFacturacionData({
    required this.id,
    required this.descripcion,
    required this.descripcionEstadoTasacion,
  });

  String descripcion, descripcionEstadoTasacion;
  int id;

  factory DocumentosFacturacionData.fromJson(Map<String, dynamic> json) =>
      DocumentosFacturacionData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
        descripcionEstadoTasacion: json["descripcionEstadoTasacion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "descripcionEstadoTasacion": descripcionEstadoTasacion,
      };
}

DocumentosFacturacionResponse documentosFacturacionPOSTResponseFromJson(
        String str) =>
    DocumentosFacturacionResponse.fromJson(json.decode(str));

String documentosFacturacionPOSTResponseToJson(
        DocumentosFacturacionResponse data) =>
    json.encode(data.toJson());

class DocumentosFacturacionPOSTResponse {
  DocumentosFacturacionPOSTResponse({required this.data});

  bool data;

  factory DocumentosFacturacionPOSTResponse.fromJson(
          Map<String, dynamic> json) =>
      DocumentosFacturacionPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
