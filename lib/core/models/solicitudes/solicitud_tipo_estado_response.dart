import 'dart:convert';

EstadoSolicitudResponse estadoSolicitudResponseFromJson(String str) =>
    EstadoSolicitudResponse.fromJson(json.decode(str));

String estadoSolicitudResponseToJson(EstadoSolicitudResponse data) =>
    json.encode(data.toJson());

class EstadoSolicitudResponse {
  EstadoSolicitudResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<EstadoSolicitudData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory EstadoSolicitudResponse.fromJson(Map<String, dynamic> json) =>
      EstadoSolicitudResponse(
          data: json["data"]
              .map<EstadoSolicitudData>((e) => EstadoSolicitudData.fromJson(e))
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

class EstadoSolicitudData {
  EstadoSolicitudData({required this.id, required this.descripcion});

  String descripcion;
  int id;

  factory EstadoSolicitudData.fromJson(Map<String, dynamic> json) =>
      EstadoSolicitudData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {"id": id, "descripcion": descripcion};
}

TipoTasacionResponse tipoTasacionResponseFromJson(String str) =>
    TipoTasacionResponse.fromJson(json.decode(str));

String tipoTasacionResponseToJson(TipoTasacionResponse data) =>
    json.encode(data.toJson());

class TipoTasacionResponse {
  TipoTasacionResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<TipoTasacionData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory TipoTasacionResponse.fromJson(Map<String, dynamic> json) =>
      TipoTasacionResponse(
          data: json["data"]
              .map<TipoTasacionData>((e) => TipoTasacionData.fromJson(e))
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

class TipoTasacionData {
  TipoTasacionData({required this.id, required this.descripcion});

  String descripcion;
  int id;

  factory TipoTasacionData.fromJson(Map<String, dynamic> json) =>
      TipoTasacionData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {"id": id, "descripcion": descripcion};
}
