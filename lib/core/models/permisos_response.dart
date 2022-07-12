import 'dart:convert';

PermisosResponse permisosResponseFromJson(String str) =>
    PermisosResponse.fromJson(json.decode(str));

String permisosResponseToJson(PermisosResponse data) =>
    json.encode(data.toJson());

class PermisosResponse {
  PermisosResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<PermisosData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory PermisosResponse.fromJson(Map<String, dynamic> json) =>
      PermisosResponse(
          data: json["data"]
              .map<PermisosData>((e) => PermisosData.fromJson(e))
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

class PermisosData {
  PermisosData(
      {required this.id,
      required this.descripcion,
      required this.accionNombre,
      required this.esBasico,
      required this.idAccion,
      required this.idRecurso,
      required this.recursoNombre});

  String descripcion, accionNombre, recursoNombre;
  int id, idAccion, idRecurso, esBasico;

  factory PermisosData.fromJson(Map<String, dynamic> json) => PermisosData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
        accionNombre: json["accionNombre"] ?? '',
        esBasico: json["esBasico"] ?? 0,
        idAccion: json["idAccion"] ?? 0,
        idRecurso: json["idRecurso"] ?? 0,
        recursoNombre: json["recursoNombre"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "accionNombre": accionNombre,
        "esBasico": esBasico,
        "idAccion": idAccion,
        "recursoNombre": recursoNombre,
        "idRecurso": idRecurso,
      };
}

PermisosResponse permisosPOSTResponseFromJson(String str) =>
    PermisosResponse.fromJson(json.decode(str));

String permisosPOSTResponseToJson(PermisosResponse data) =>
    json.encode(data.toJson());

class PermisosPOSTResponse {
  PermisosPOSTResponse({required this.data});

  bool data;

  factory PermisosPOSTResponse.fromJson(Map<String, dynamic> json) =>
      PermisosPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
