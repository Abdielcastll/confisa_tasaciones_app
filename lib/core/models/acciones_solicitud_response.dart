import 'dart:convert';

AccionesSolicitudResponse accionesSolicitudResponseFromJson(String str) =>
    AccionesSolicitudResponse.fromJson(json.decode(str));

String accionesSolicitudResponseToJson(AccionesSolicitudResponse data) =>
    json.encode(data.toJson());

class AccionesSolicitudResponse {
  AccionesSolicitudResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<AccionesSolicitudData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory AccionesSolicitudResponse.fromJson(Map<String, dynamic> json) =>
      AccionesSolicitudResponse(
          data: json["data"]
              .map<AccionesSolicitudData>(
                  (e) => AccionesSolicitudData.fromJson(e))
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

class AccionesSolicitudData {
  AccionesSolicitudData(
      {required this.id,
      required this.comentario,
      required this.listo,
      required this.notas,
      required this.fechaHora,
      required this.idSolicitud,
      required this.tipo,
      required this.usuarioComentario,
      required this.usuario,
      required this.noSolicitudCredito,
      required this.noTasacion});

  String fechaHora, usuario, notas, comentario, usuarioComentario;
  int id, idSolicitud, tipo, noTasacion, noSolicitudCredito;
  bool listo;

  factory AccionesSolicitudData.fromJson(Map<String, dynamic> json) =>
      AccionesSolicitudData(
        id: json["id"] ?? 0,
        idSolicitud: json["idSolicitud"] ?? 0,
        noSolicitudCredito: json["noSolicitudCredito"] ?? 0,
        noTasacion: json["noTasacion"] ?? 0,
        comentario: json["comentario"] ?? '',
        usuarioComentario: json["usuarioComentario"] ?? '',
        notas: json["notas"] ?? '',
        fechaHora: json["fechaHora"] ?? '',
        tipo: json["tipo"] ?? 0,
        usuario: json["usuario"] ?? '',
        listo: json["listo"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idSolicitud": idSolicitud,
        "comentario": comentario,
        "usuarioComentario": usuarioComentario,
        "notas": notas,
        "fechaHora": fechaHora,
        "tipo": tipo,
        "usuario": usuario,
        "listo": listo,
        "noSolicitudCredito": noSolicitudCredito,
        "noTasacion": noTasacion
      };
}

AccionesSolicitudResponse accionesSolicitudPOSTResponseFromJson(String str) =>
    AccionesSolicitudResponse.fromJson(json.decode(str));

String aAccionesSolicitudPOSTResponseToJson(AccionesSolicitudResponse data) =>
    json.encode(data.toJson());

class AccionesSolicitudPOSTResponse {
  AccionesSolicitudPOSTResponse({required this.data});

  bool data;

  factory AccionesSolicitudPOSTResponse.fromJson(Map<String, dynamic> json) =>
      AccionesSolicitudPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
