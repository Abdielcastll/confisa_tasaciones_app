import 'dart:convert';

NotasResponse notasResponseFromJson(String str) =>
    NotasResponse.fromJson(json.decode(str));

String notasResponseToJson(NotasResponse data) => json.encode(data.toJson());

class NotasResponse {
  NotasResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<NotasData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory NotasResponse.fromJson(Map<String, dynamic> json) => NotasResponse(
      data: json["data"].map<NotasData>((e) => NotasData.fromJson(e)).toList(),
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

class NotasData {
  NotasData(
      {required this.id,
      required this.descripcion,
      required this.fechaHora,
      required this.idSolicitud,
      required this.titulo,
      required this.usuario});

  String descripcion, fechaHora, usuario, titulo;
  int id, idSolicitud;

  factory NotasData.fromJson(Map<String, dynamic> json) => NotasData(
        id: json["id"] ?? 0,
        idSolicitud: json["idSolicitud"] ?? 0,
        descripcion: json["descripcion"] ?? '',
        fechaHora: json["fechaHora"] ?? '',
        titulo: json["titulo"] ?? '',
        usuario: json["usuario"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "idSolicitud": idSolicitud,
        "fechaHora": fechaHora,
        "titulo": titulo,
        "usuario": usuario
      };
}

NotasResponse notasPOSTResponseFromJson(String str) =>
    NotasResponse.fromJson(json.decode(str));

String notasPOSTResponseToJson(NotasResponse data) =>
    json.encode(data.toJson());

class NotasPOSTResponse {
  NotasPOSTResponse({required this.data});

  bool data;

  factory NotasPOSTResponse.fromJson(Map<String, dynamic> json) =>
      NotasPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
