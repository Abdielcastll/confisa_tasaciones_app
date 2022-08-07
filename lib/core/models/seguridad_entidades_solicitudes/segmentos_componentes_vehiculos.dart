import 'dart:convert';

SegmentosComponentesVehiculosResponse
    segmentoscomponentesVehiculosResponseFromJson(String str) =>
        SegmentosComponentesVehiculosResponse.fromJson(json.decode(str));

String segmentoscomponentesVehiculosResponseToJson(
        SegmentosComponentesVehiculosResponse data) =>
    json.encode(data.toJson());

class SegmentosComponentesVehiculosResponse {
  SegmentosComponentesVehiculosResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<SegmentosComponentesVehiculosData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory SegmentosComponentesVehiculosResponse.fromJson(
          Map<String, dynamic> json) =>
      SegmentosComponentesVehiculosResponse(
          data: json["data"]
              .map<SegmentosComponentesVehiculosData>(
                  (e) => SegmentosComponentesVehiculosData.fromJson(e))
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

class SegmentosComponentesVehiculosData {
  SegmentosComponentesVehiculosData(
      {required this.id, required this.descripcion});

  String descripcion;
  int id;

  factory SegmentosComponentesVehiculosData.fromJson(
          Map<String, dynamic> json) =>
      SegmentosComponentesVehiculosData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
      };
}

SegmentosComponentesVehiculosResponse
    segmentoscomponentesVehiculosPOSTResponseFromJson(String str) =>
        SegmentosComponentesVehiculosResponse.fromJson(json.decode(str));

String segmentoscomponentesVehiculosPOSTResponseToJson(
        SegmentosComponentesVehiculosResponse data) =>
    json.encode(data.toJson());

class SegmentosComponentesVehiculosPOSTResponse {
  SegmentosComponentesVehiculosPOSTResponse({required this.data});

  bool data;

  factory SegmentosComponentesVehiculosPOSTResponse.fromJson(
          Map<String, dynamic> json) =>
      SegmentosComponentesVehiculosPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
