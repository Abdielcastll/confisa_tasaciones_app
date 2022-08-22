import 'dart:convert';

PeriodoTasacionPromedioResponse periodoTasacionPromedioResponseFromJson(
        String str) =>
    PeriodoTasacionPromedioResponse.fromJson(json.decode(str));

String periodoTasacionPromedioResponseToJson(
        PeriodoTasacionPromedioResponse data) =>
    json.encode(data.toJson());

class PeriodoTasacionPromedioResponse {
  PeriodoTasacionPromedioResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<PeriodoTasacionPromedioData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory PeriodoTasacionPromedioResponse.fromJson(Map<String, dynamic> json) =>
      PeriodoTasacionPromedioResponse(
          data: json["data"]
              .map<PeriodoTasacionPromedioData>(
                  (e) => PeriodoTasacionPromedioData.fromJson(e))
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

class PeriodoTasacionPromedioData {
  PeriodoTasacionPromedioData({required this.value, required this.description});

  String description;
  int value;

  factory PeriodoTasacionPromedioData.fromJson(Map<String, dynamic> json) =>
      PeriodoTasacionPromedioData(
        value: json["value"] ?? 0,
        description: json["description"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "description": description,
      };
}

class OpcionesPeriodoTasacionPromedioResponse {
  OpcionesPeriodoTasacionPromedioResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<OpcionesPeriodoTasacionPromedioData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory OpcionesPeriodoTasacionPromedioResponse.fromJson(
          Map<String, dynamic> json) =>
      OpcionesPeriodoTasacionPromedioResponse(
          data: json["data"]
              .map<OpcionesPeriodoTasacionPromedioData>(
                  (e) => OpcionesPeriodoTasacionPromedioData.fromJson(e))
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

class OpcionesPeriodoTasacionPromedioData {
  OpcionesPeriodoTasacionPromedioData(
      {required this.id, required this.descripcion});

  String descripcion;
  int id;

  factory OpcionesPeriodoTasacionPromedioData.fromJson(
          Map<String, dynamic> json) =>
      OpcionesPeriodoTasacionPromedioData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
      };
}

PeriodoTasacionPromedioResponse periodoTasacionPromedioPOSTResponseFromJson(
        String str) =>
    PeriodoTasacionPromedioResponse.fromJson(json.decode(str));

String periodoTasacionPromedioPOSTResponseToJson(
        PeriodoTasacionPromedioResponse data) =>
    json.encode(data.toJson());

class PeriodoTasacionPromedioPOSTResponse {
  PeriodoTasacionPromedioPOSTResponse({required this.data});

  bool data;

  factory PeriodoTasacionPromedioPOSTResponse.fromJson(
          Map<String, dynamic> json) =>
      PeriodoTasacionPromedioPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
