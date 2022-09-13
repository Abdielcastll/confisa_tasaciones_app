import 'dart:convert';

AlarmasResponse alarmasResponseFromJson(String str) =>
    AlarmasResponse.fromJson(json.decode(str));

String alarmasResponseToJson(AlarmasResponse data) =>
    json.encode(data.toJson());

class AlarmasResponse {
  AlarmasResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<AlarmasData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory AlarmasResponse.fromJson(Map<String, dynamic> json) =>
      AlarmasResponse(
          data: json["data"]
              .map<AlarmasData>((e) => AlarmasData.fromJson(e))
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

class AlarmasData {
  AlarmasData(
      {required this.id,
      required this.descripcion,
      required this.correo,
      required this.fechaCompromiso,
      required this.fechaHora,
      required this.idSolicitud,
      required this.titulo,
      required this.usuario,
      required this.noSolicitudCredito,
      required this.noTasacion});

  String descripcion, fechaHora, usuario, fechaCompromiso, titulo, correo;
  int id, idSolicitud, noTasacion, noSolicitudCredito;

  factory AlarmasData.fromJson(Map<String, dynamic> json) => AlarmasData(
        id: json["id"] ?? 0,
        idSolicitud: json["idSolicitud"] ?? 0,
        noSolicitudCredito: json["noSolicitudCredito"] ?? 0,
        noTasacion: json["noTasacion"] ?? 0,
        descripcion: json["descripcion"] ?? '',
        correo: json["correo"] ?? '',
        fechaCompromiso: json["fechaCompromiso"] ?? '',
        fechaHora: json["fechaHora"] ?? '',
        titulo: json["titulo"] ?? '',
        usuario: json["usuario"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "idSolicitud": idSolicitud,
        "correo": correo,
        "fechaCompromiso": fechaCompromiso,
        "fechaHora": fechaHora,
        "titulo": titulo,
        "usuario": usuario,
        "noSolicitudCredito": noSolicitudCredito,
        "noTasacion": noTasacion
      };
}

AlarmasResponse alarmasPOSTResponseFromJson(String str) =>
    AlarmasResponse.fromJson(json.decode(str));

String aAlarmasPOSTResponseToJson(AlarmasResponse data) =>
    json.encode(data.toJson());

class AlarmasPOSTResponse {
  AlarmasPOSTResponse({required this.data});

  bool data;

  factory AlarmasPOSTResponse.fromJson(Map<String, dynamic> json) =>
      AlarmasPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
